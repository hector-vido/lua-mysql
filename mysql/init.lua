-- init.lua

local sha1 = require('sha1')
local socket = require('socket')
local struct = require('struct')
local bit = require('bitop.funcs')

local PACKETS = require('mysql.packets')
local COLUMNS = require('mysql.columns')
local COMMANDS = require('mysql.commands')
local CAPABILITIES = require('mysql.capabilities')

local MySQL = {}
MySQL.attrs = {client_name = 'lua-mysql', client_version = '0.0.1'}

function MySQL:connect(connection)
	
	connection = connection or {}
	for _, v in ipairs({'host', 'user', 'password'}) do
		assert(connection[v], v .. ' is mandatory')
	end
	connection.port = connection.port or 3306
	setmetatable(connection, self)
	self.__index = self
	
	connection.client = assert(socket.connect(connection.host, 3306))
	connection.client:settimeout(connection.timeout or 10)
	connection.client:setoption('keepalive', true)
	
	-- userdata to close connection on script ending
	connection.proxy = newproxy(true)
	getmetatable(connection.proxy).__gc = function() connection:__gc() end
	
	connection:initial_handshake()
	assert(connection:parse_response(connection:get_packet()))
	return connection
end

-- does the initial handshake
function MySQL:initial_handshake()

	local a, b, c = self.client:receive('*l') -- version
	self.server = self:receive_until_null() -- server
	self.connection_id, b, c = self.client:receive(4) -- connection id
	a, b, c = self.client:receive(8) -- scramble 1st
	local scramble1 = a
	a, b, c = self.client:receive(1) -- reserved
	a, b, c = self.client:receive(2) -- capabilities 1st
	a, b, c = self.client:receive(1) -- collation
	self.status, b, c = self.client:receive(2) -- status
	a, b, c = self.client:receive(2) -- capabilities 2nd
	a, b, c = self.client:receive(1) -- auth data length
	a, b, c = self.client:receive(6) -- filler
	a, b, c = self.client:receive(4) -- filler or capabilities 3rd
	a, b, c = self.client:receive(13) -- scramble 2nd
	local scramble2 = a:sub(1, #a - 1)
	self.auth_plugin = self:receive_until_null() -- auth_plugin
	
	local payload = {0,0,0,0,0,0,0,0,0,0}
	local client_capabilities = CAPABILITIES.DEFAULT
	
	if self.database then -- add a capability to informa a database to connect
		client_capabilities = client_capabilities + CAPABILITIES.CONNECT_WITH_DB
		payload[8] = self.database .. '\0'
	end
	
	payload[1] = struct.pack('<I', client_capabilities)
	payload[2] = struct.pack('<I', 16 * 1024 * 1024)
	payload[3] = '\33' -- charset
	payload[4] = string.rep('\0', 23) -- reserved
	payload[5] = self.user .. '\0'
	payload[6] = '\20' -- auth response size
	payload[7] = self:digest_password(scramble1, scramble2) -- password inside self.password
	payload[9] = self.auth_plugin .. '\0'
	payload[10] = self:assemble_client_attributes()
	
	payload = table.concat(payload)
	self.client:send(
		string.sub(struct.pack('<I', #payload), 1, 3) .. -- packet size (3 bytes)
		'\1' .. --  sequence, authentication needs sequence = 1
		payload
	)
end

function MySQL:parse_response(length, sequence, payload, header)
	if header == PACKETS.OK then
		return self:ok_packet(payload)
	elseif header == PACKETS.EOF then
		return self:eof_packet(payload)
	elseif header == PACKETS.ERR then
		return self:err_packet(payload)
	else -- query, payload = header
		return self:parse_resultset(payload)
	end
end

function MySQL:send_packet(payload)
	self.client:send(
		string.sub(struct.pack('<I', #payload), 1, 3) .. -- packet size (3 bytes)
		'\0' .. --  sequence
		payload
	)
end

function MySQL:get_packet()
	local length = struct.unpack('<I', self.client:receive(3) .. '\0')
	local sequence = string.byte(self.client:receive(1))
	local payload = self.client:receive(length)
	local header = string.byte(string.sub(payload, 1, 1))
	return length, sequence, payload, header
end

function MySQL:ok_packet(payload)
	local position, affected_rows, last_insert_id = 2, nil, nil
	affected_rows, position = self:length_encoded_integer(payload, position) -- at least position++
	last_insert_id, position = self:length_encoded_integer(payload, position) -- at least position++
	return last_insert_id or true
end

function MySQL:err_packet(payload)
	local error_code = struct.unpack('<h', string.sub(payload, 2, 3))
	-- ignoring marker # (4, 4)
	local sql_state = string.sub(payload, 5, 9)
	local error_message = string.sub(payload, 10)
	return false, string.format('ERROR %s (%s): %s', error_code, sql_state, error_message)
end

function MySQL:eof_packet(payload)
	return true
end

-- parse a resultset response
function MySQL:parse_resultset(number_columns)
	
	local columns = {}
	local length, sequence, payload, header
	number_columns = string.byte(number_columns)
	for _ = 1, number_columns do
		length, sequence, payload, header = self:get_packet()
		table.insert(columns, self:column_definition(payload))
	end
	
	length, sequence, payload, header = self:get_packet() -- eof
	
	local rows = {}
	length, sequence, payload, header = self:get_packet()
	while header ~= PACKETS.EOF do
		local row = {}
		local position = 1
		for i = 1, #columns do
			local size = struct.unpack('<b', string.sub(payload, position, position))
			position = position + 1
			row[columns[i]] = string.sub(payload, position, position + size - 1)
			position = position + size
		end
		table.insert(rows, row)
		length, sequence, payload, header = self:get_packet()
	end
	
	return rows
	
end

function MySQL:length_encoded_integer(payload, position)
	local int = string.byte(string.sub(payload, position, position))
	position = position + 1
	if int == 0xfc then
		int = struct.unpack('<H', string.sub(payload, position, position + 1))
		position = position + 2
	elseif int == 0xfd then
		int = struct.unpack('<I', string.sub(payload, position, position + 2) .. '\0')
		position = position + 3
	elseif  int == 0xfe then
		int = struct.unpack('<L', string.sub(payload, position, position + 7))
		position = position + 8
	end
	return int, position
end

function MySQL:column_definition(payload)
	local definition = {0,0,0,0,0,0,0,0,0,0,0,0,0} -- avoid some table rehash
	local position = 1
	for _, field in ipairs(COLUMNS.DEFINITION41) do
		local size = field.size
		if not size then
			size = string.byte(string.sub(payload, position, position))
			position = position + 1
		end
		size = size - 1  -- lua includes the right argument in string.sub
		definition[field.name] = field.parser(string.sub(payload, position, position + size))
		position = position + size + 1
	end
	return definition.name
end

function MySQL:prepare_statement(statement)
	local length, sequence, payload, header
	payload = COMMANDS.STMT_PREPARE .. statement
	self:send_packet(payload)
	length, sequence, payload, header = self:get_packet()
	if header == PACKETS.ERR then
		return self:err_packet(payload)
	end
	local statement_id = string.sub(payload, 2, 5)
	length, sequence, payload, header = self:get_packet()
	while header ~= PACKETS.EOF do
		length, sequence, payload, header = self:get_packet()
	end
	return statement_id
end

function MySQL:execute_statement(statement_id, values)
	
	local types = {}
	local parameters = {}
	for _, v in ipairs(values) do
		if type(v) == 'string' then
			table.insert(types, struct.pack('<H', COLUMNS.VAR_STRING .. '\0'))
			table.insert(parameters, struct.pack('<B', #v)) -- string size
			table.insert(parameters, struct.pack('<c' .. #v, v))
		elseif type(v) == 'number' then
			if v % 1 == 0 then -- integer
				table.insert(types, struct.pack('<H', COLUMNS.LONGLONG .. '\0'))
				table.insert(parameters, struct.pack('<L', v)) -- 8 bytes, always
			else -- float
				table.insert(types, struct.pack('<H', COLUMNS.DOUBLE .. '\0'))
				table.insert(parameters, struct.pack('<d', v))
			end
		elseif type(v) == 'boolean' then
			table.insert(types, struct.pack('<H', COLUMNS.TINY .. '\0'))
			table.insert(parameters, struct.pack('<B', v)) -- 1 byte
		end
	end
	types = table.concat(types)
	parameters = table.concat(parameters)
	
	local payload =
		COMMANDS.STMT_EXECUTE .. 
		statement_id .. 
		'\0' ..  -- flags, CURSOR_TYPE_NO_CURSOR
		'\1\0\0\0' .. -- iteration-count, always 1
		string.rep('\0', math.floor((#values + 7) / 8)) .. -- null bitmap
		'\1' ..
		types ..
		parameters

	self:send_packet(payload)
	
	return self:parse_response(self:get_packet())
end

-- send a query
function MySQL:execute(statement, values)
	if values then
		local statement_id = self:prepare_statement(statement)
		local response = self:execute_statement(statement_id, values)
		self:send_packet(COMMANDS.STMT_CLOSE .. statement_id)
		return response
	else
		self:send_packet(COMMANDS.QUERY .. statement)
	end
	return self:parse_response(self:get_packet())
end

-- apply the formula SHA1(password) ^ SHA1(s1 + s2 + SHA1(SHA1(password)) on password
function MySQL:digest_password(scramble1, scramble2)
	local pass_sha1 = sha1.binary(self.password)
	local pass_scramble_sha1 = sha1.binary(scramble1 .. scramble2 .. sha1.binary(pass_sha1))

	local hash = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0} -- avoid some table rehash
	for i = 1, #pass_sha1 do
		local a = string.byte(pass_sha1:sub(i,i))
		local b = string.byte(pass_scramble_sha1:sub(i,i))
		hash[i] = string.char(bit.bxor(a, b))
	end

	return table.concat(hash)
end

-- concatenate client attributes to send with payload
function MySQL:assemble_client_attributes()
	local attrs = {}
	table.insert(attrs, string.char(#self.attrs.client_name + #self.attrs.client_version + 2))
	for k, v in pairs(self.attrs) do
		table.insert(attrs, string.char(#k) .. k)
		table.insert(attrs, string.char(#v) .. v)
	end
	return table.concat(attrs)
end

-- close the connection
function MySQL:close()
	self:send_packet(COMMANDS.QUIT)
	self.client:close()
end

-- close the connection when this table is destroyed
function MySQL:__gc()
	self:close()
end

-- read at null byte "\0"
function MySQL:receive_until_null()
	local t = {} -- avoid some table rehash
	local a, b, c = self.client:receive(1)
	while a ~= '\0' do
		t[#t + 1] = a
		a, b, c = self.client:receive(1)
	end
	return table.concat(t)
end

return MySQL
