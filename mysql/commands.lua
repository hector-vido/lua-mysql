-- commands.lua
-- define the client commands to interact on a opened connection
-- all constants had they prefix "COM_" removed

local COMMANDS = {
	SLEEP = 0x00,
	QUIT = 0x01,
	INIT_DB = 0x02,
	QUERY = 0x03,
	FIELD_LIST = 0x04,
	CREATE_DB = 0x05,
	DROP_DB = 0x06,
	REFRESH = 0x07,
	SHUTDOWN = 0x08,
	STATISTICS = 0x09,
	PROCESS_INFO = 0x0a,
	CONNECT = 0x0b,
	PROCESS_KILL = 0x0c,
	DEBUG = 0x0d,
	PING = 0x0e,
	TIME = 0x0f,
	DELAYED_INSERT = 0x10,
	CHANGE_USER = 0x11,
	BINLOG_DUMP = 0x12,
	TABLE_DUMP = 0x13,
	CONNECT_OUT = 0x14,
	REGISTER_SLAVE = 0x15,
	STMT_PREPARE = 0x16,
	STMT_EXECUTE = 0x17,
	STMT_SEND_LONG_DATA = 0x18,
	STMT_CLOSE = 0x19,
	STMT_RESET = 0x1a,
	SET_OPTION = 0x1b,
	STMT_FETCH = 0x1c,
	DAEMON = 0x1d,
	BINLOG_DUMP_GTID = 0x1e,
	RESET_CONNECTION = 0x1f
}

return COMMANDS
