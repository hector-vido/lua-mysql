local sha1 = require "sha1"

local message = 'hector'

-- Prints module version in MAJOR.MINOR.PATCH format.
print(sha1.version)

-- Returns a hex string of length 40. sha1(message) also works.
local hash_as_hex = sha1.sha1(message)
print(hash_as_hex)

-- Returns raw bytes as a string of length 20.
local hash_as_data = sha1.binary(message)
print(hash_as_data)

-- Returns a hex string of length 40.
-- local hmac_as_hex = sha1.hmac(key, message)

-- Returns raw bytes as a string of length 20.
-- local hmac_as_data = sha1.hmac_binary(key, message)
