-- server.lua
local socket = require('socket')
local struct = require('struct')

mysql = socket.tcp()
mysql:connect('127.0.0.1', 3306)
mysql:settimeout(1)

local payload = ''

a, b, c = mysql:receive('1')
while b ~= 'timeout' do
	payload = payload .. a
	a, b, c = mysql:receive(1)
end

-- io.write(payload)
-- os.exit(0)
-- -- local proto, server, id, scramble1, fill, cap1, charset, status, cap2, auth_size, reserved, scramble2, plugin = struct.pack('<BsIc8BHBHHBc10c13s', payload)
-- local packed = struct.pack('<B', payload)
-- -- local packed = struct.pack('<BsIc8BHBHHBc10c13s', payload)
-- print(packed)
-- os.exit(0)

local server = assert(socket.bind('*', 3307))
print('Esperando...')
while 1 do
  -- wait for a connection from any client
  local client = server:accept()
  -- make sure we don't block waiting for this client's line
  client:settimeout(10)
  -- receive the line
  -- local line, err = client:receive()
  -- if there was no error, send it back to the client
  -- if not err then client:send(line .. '\n') end
  -- done with client, close the object
  client:send(payload)
  local line, err = client:receive()
  if not err then io.write(line) end
  client:close()
end
