-- init.lua

local inspect = require('inspect')
local sha1 = require('sha1')
local socket = require('socket')
local struct = require('struct')
local bit = require('bitop.funcs')

local packets = require('mysql.packets')
local columns = require('mysql.columns')
local commands = require('mysql.commands')
local capabilities = require('mysql.capabilities')

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
	-- userdata to close connection on script ending
	connection.proxy = newproxy(true)
	getmetatable(connection.proxy).__gc = function() connection:__gc() end
	
	connection.client = connection:getsocket() -- tcp socket with a new function
	connection.client:settimeout(connection.timeout or 10)
  connection.client:setoption('keepalive', true)
	
	connection:initial_handshake()
	
	return connection
end

-- does the initial handshake
function MySQL:initial_handshake()

	local a, b, c = self.client:receive('*l') -- version
	self.server = self.client:receive_until_null() -- server
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
	self.auth_plugin = self.client:receive_until_null() -- auth_plugin
	
	local hash = self:digest_password(scramble1, scramble2) -- password inside self.password
	
	local payload = {[8] = ''}
	local client_capabilities = capabilities.client_default()
	
	if self.database then -- add a capability to informa a database to connect
		client_capabilities = client_capabilities + capabilities.client.CONNECT_WITH_DB
		payload[8] = self.database .. '\0'
	end
	
	payload[1] = struct.pack('<i', client_capabilities)
	payload[2] = struct.pack('<i', 16 * 1024 * 1024)
	payload[3] = struct.pack('<b', 33)
	payload[4] = struct.pack('<c23', '\0')
	payload[5] = self.user .. '\0'
	payload[6] = struct.pack('<b', 20)
	payload[7] = hash
	payload[9] = self.auth_plugin .. '\0'
	payload[10] = self:assemble_client_attributes()
	
	payload = table.concat(payload)

	self.client:send(
		struct.pack('<h', #payload) .. -- packet size (should be 3 byte)
		'\0' .. -- don't know how to create a 3 byte integer
		struct.pack('<b', 1) .. --  sequence
		payload
	)
	
end

function MySQL:receive_packet(repeated)

	local length, sequence, payload, header = self:generic_packet()
	
	if header == packets.OK or header == packets.EOF then -- ok
		return self:ok_packet(repeated)
	elseif header == packets.ERR then -- error
		return self:err_packet(payload)
	else -- query, payload = header
		return self:query_response(payload)
	end
end

function MySQL:generic_packet()	
	local length = string.byte(self.client:receive(3))
	local sequence = string.byte(self.client:receive(1))
	local payload = self.client:receive(length)
	local header = string.byte(string.sub(payload, 1, 1))
	return length, sequence, payload, header
end

function MySQL:ok_packet(repeatead)
	if repeatead then
		return true
	else
		return self:receive_packet(true)
	end
end

function MySQL:err_packet(payload)
	local error_code = struct.unpack('<h', string.sub(payload, 2, 3))
	-- ignoring marker # (4, 4)
	local sql_state = string.sub(payload, 5, 9)
	local error_message = string.sub(payload, 10)
	return false, string.format('ERROR %s (%s): %s', error_code, sql_state, error_message)
end

function MySQL:eof_packet()
end

function MySQL:query_response(number_columns)
	
	local columns = {}
	number_columns = string.byte(number_columns)
	for i = 1, number_columns do
		local length, sequence, payload, header = self:generic_packet()
		table.insert(columns, self:column_definition(payload))
	end
	
	local length, sequence, payload, header = self:generic_packet() -- eof
	
	local rows = {}
	length, sequence, payload, header = self:generic_packet()
	while header ~= packets.EOF do
		local row = {}
		local position = 1
		for i = 1, #columns do
			local size = struct.unpack('<b', string.sub(payload, position, position))
			position = position + 1
			row[columns[i]] = string.sub(payload, position, position + size - 1)
			position = position + size
		end
		table.insert(rows, row)
		length, sequence, payload, header = self:generic_packet()
	end
	
	return rows
	
end

function MySQL:column_definition(payload)
	local definition = {}
	local position = 1
	for k, field in ipairs(columns.definition41) do
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

function MySQL:command(cmd, data)
	local payload = commands.by_name(cmd) .. (data or '')
	return struct.pack('<h', #payload) .. struct.pack('<b', 0) .. struct.pack('<b', 0) .. payload
end

-- send a query
function MySQL:execute(query)
	self.client:send(self:command('QUERY', query))
	return self:receive_packet()
end

-- apply the formula SHA1(password) ^ SHA1(s1 + s2 + SHA1(SHA1(password)) on password
function MySQL:digest_password(scramble1, scramble2)
	local pass_sha1 = sha1.binary(self.password)
	local pass_scramble_sha1 = sha1.binary(scramble1 .. scramble2 .. sha1.binary(pass_sha1))

	local hash = {}
	for i = 1, #pass_sha1 do
		a = string.byte(pass_sha1:sub(i,i))
		b = string.byte(pass_scramble_sha1:sub(i,i))
		table.insert(hash, string.char(bit.bxor(a, b)))
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
	self.client:send(self:command('QUIT'))
	self.client:close()
end

-- close the connection when this table is destroyed
function MySQL:__gc()
	self:close()
end

-- return a tcp socket with a new function "receive_until_null()"
function MySQL:getsocket()
	local _s = socket.connect(self.host, 3306)
	local _mt = getmetatable(_s)
	function _mt.__index:receive_until_null()
		local t = {}
		local a, b, c = self:receive(1)
		while a ~= '\0' do
			t[#t + 1] = a
			a, b, c = self:receive(1)
		end
		return table.concat(t)
	end
	return _s
end

return MySQL