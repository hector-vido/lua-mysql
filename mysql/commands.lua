-- commands.lua
-- define the client commands to interact on a opened connection
-- all constants had they prefix "COM_" removed

local struct = require('struct')
local commands = {}

commands.options = {
	['00'] = 'SLEEP',
	['01'] = 'QUIT',
	['02'] = 'INIT_DB',
	['03'] = 'QUERY',
	['04'] = 'FIELD_LIST',
	['05'] = 'CREATE_DB',
	['06'] = 'DROP_DB',
	['07'] = 'REFRESH',
	['08'] = 'SHUTDOWN',
	['09'] = 'STATISTICS',
	['0a'] = 'PROCESS_INFO',
	['0b'] = 'CONNECT',
	['0c'] = 'PROCESS_KILL',
	['0d'] = 'DEBUG',
	['0e'] = 'PING',
	['0f'] = 'TIME',
	['10'] = 'DELAYED_INSERT',
	['11'] = 'CHANGE_USER',
	['12'] = 'BINLOG_DUMP',
	['13'] = 'TABLE_DUMP',
	['14'] = 'CONNECT_OUT',
	['15'] = 'REGISTER_SLAVE',
	['16'] = 'STMT_PREPARE',
	['17'] = 'STMT_EXECUTE',
	['18'] = 'STMT_SEND_LONG_DATA',
	['19'] = 'STMT_CLOSE',
	['1a'] = 'STMT_RESET',
	['1b'] = 'SET_OPTION',
	['1c'] = 'STMT_FETCH',
	['1d'] = 'DAEMON',
	['1e'] = 'BINLOG_DUMP_GTID',
	['1f'] = 'RESET_CONNECTION'
}

function commands.by_name(name)
	for cmd in pairs(commands.options) do
		if commands.options[cmd] == name then
			return struct.pack('b', cmd)
		end
	end
	return nil
end

return commands