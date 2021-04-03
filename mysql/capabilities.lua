-- capabilities.lua
-- define the client capabilities used in initial_handshake
-- all constants had they prefix "CLIENT_" removed

local capabilities = {}

capabilities.client = {
	LONG_PASSWORD = 0x00000001,
	FOUND_ROWS = 0x00000002,
	LONG_FLAG = 0x00000004,
	CONNECT_WITH_DB = 0x00000008,
	NO_SCHEMA = 0x00000010,
	COMPRESS = 0x00000020,
	ODBC = 0x00000040,
	LOCAL_FILES = 0x00000080,
	IGNORE_SPACE = 0x00000100,
	PROTOCOL_41 = 0x00000200,
	INTERACTIVE = 0x00000400,
	SSL = 0x00000800,
	IGNORE_SIGPIPE = 0x00001000,
	TRANSACTIONS = 0x00002000,
	RESERVED = 0x00004000,
	SECURE_CONNECTION = 0x00008000,
	MULTI_STATEMENTS = 0x00010000,
	MULTI_RESULTS = 0x00020000,
	PS_MULTI_RESULTS = 0x00040000,
	PLUGIN_AUTH = 0x00080000 ,
	CONNECT_ATTRS = 0x00100000,
	PLUGIN_AUTH_LENENC_DATA = 0x00200000,
	CAN_HANDLE_EXPIRED_PASSWORDS = 0x00400000,
	SESSION_TRACK = 0x00800000,
	DEPRECATE_EOF = 0x01000000
}

function capabilities.client_default()
	return 
		capabilities.client.LONG_PASSWORD
		+ capabilities.client.LONG_FLAG
		+ capabilities.client.PROTOCOL_41
		+ capabilities.client.TRANSACTIONS
		+ capabilities.client.SECURE_CONNECTION
		+ capabilities.client.MULTI_RESULTS
		+ capabilities.client.PLUGIN_AUTH 
		+ capabilities.client.PLUGIN_AUTH_LENENC_DATA
		+ capabilities.client.CONNECT_ATTRS
end

return capabilities
