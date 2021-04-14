-- test.lua

local stdout = assert(io.popen('docker container ls'))
for line in stdout:lines() do
	print(line)
end