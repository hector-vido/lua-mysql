-- commands.lua
-- define the client commands to interact on a opened connection
-- all constants had they prefix "COM_" removed

local COMMANDS = {
	SLEEP = '\0',                -- 0x00
	QUIT = '\1',                 -- 0x01
	INIT_DB = '\2',              -- 0x02
	QUERY = '\3',                -- 0x03
	FIELD_LIST = '\4',           -- 0x04
	CREATE_DB = '\5',            -- 0x05
	DROP_DB = '\6',              -- 0x06
	REFRESH = '\7',              -- 0x07
	SHUTDOWN = '\8',             -- 0x08
	STATISTICS = '\9',           -- 0x09
	PROCESS_INFO = '\10',        -- 0x0a
	CONNECT = '\11',             -- 0x0b
	PROCESS_KILL = '\12',        -- 0x0c
	DEBUG = '\13',               -- 0x0d
	PING = '\14',                -- 0x0e
	TIME = '\15',                -- 0x0f
	DELAYED_INSERT = '\16',      -- 0x10
	CHANGE_USER = '\17',         -- 0x11
	BINLOG_DUMP = '\18',         -- 0x12
	TABLE_DUMP = '\19',          -- 0x13
	CONNECT_OUT = '\20',         -- 0x14
	REGISTER_SLAVE = '\21',      -- 0x15
	STMT_PREPARE = '\22',        -- 0x16
	STMT_EXECUTE = '\23',        -- 0x17
	STMT_SEND_LONG_DATA = '\24', -- 0x18
	STMT_CLOSE = '\25',          -- 0x19
	STMT_RESET = '\26',          -- 0x1a
	SET_OPTION = '\27',          -- 0x1b
	STMT_FETCH = '\28',          -- 0x1c
	DAEMON = '\29',              -- 0x1d
	BINLOG_DUMP_GTID = '\30',    -- 0x1e
	RESET_CONNECTION = '\31'     -- 0x1f
}

return COMMANDS
