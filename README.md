# Lua MySQL

A pure lua driver for MySQL.

## Integer - 3 bytes

```lua
local struct = require('struct')

bytes4 = struct.pack('<I', 8388607)
print(string.format('Hex: 0x%04x Size: %s', struct.unpack('<I', bytes4), #bytes4))

bytes3 = string.sub(bytes4, 1, 3)
print(string.format('Hex: 0x%04x Size: %s', struct.unpack('<I', bytes3 .. '\0'), #bytes3))
```
