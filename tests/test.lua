-- test.lua

local stdout = assert(io.popen('docker container ls'))
print(stdout:read('*all'))