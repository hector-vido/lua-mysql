-- client.lua
local socket = require("socket")

mysql = socket.tcp()
mysql:connect('127.0.0.1', 3306)
mysql:settimeout(1)

a, b, c = mysql:receive()
io.write(a)
while b ~= 'timeout' do
	io.write(a)
	a, b, c = mysql:receive(1)
end

