-- pack.lua

local inspect = require 'inspect'
local struct = require 'struct'
local packed = struct.pack('<I', 33280)
-- local a = struct.unpack('<i', packed)
print(type(packed))
print(inspect(packed))
print(string.len(packed))
