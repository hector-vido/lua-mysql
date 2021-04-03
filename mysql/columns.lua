-- columns.lua
-- define each data type inside MySQL
-- all columns constants had they prefix "MYSQL_TYPE_" removed
local struct = require('struct')

local columns = {}

columns.types = {
	['0x00'] = 'DECIMAL',
	['0x01'] = 'TINY',
	['0x02'] = 'SHORT',
	['0x03'] = 'LONG',
	['0x04'] = 'FLOAT',
	['0x05'] = 'DOUBLE',
	['0x06'] = 'NULL',
	['0x07'] = 'TIMESTAMP',
	['0x08'] = 'LONGLONG',
	['0x09'] = 'INT24',
	['0x0a'] = 'DATE',
	['0x0b'] = 'TIME',
	['0x0c'] = 'DATETIME',
	['0x0d'] = 'YEAR',
	['0x0e'] = 'NEWDATE',
	['0x0f'] = 'VARCHAR',
	['0x10'] = 'BIT',
	['0x11'] = 'TIMESTAMP2',
	['0x12'] = 'DATETIME2',
	['0x13'] = 'TIME2',
	['0xf6'] = 'NEWDECIMAL',
	['0xf7'] = 'ENUM',
	['0xf8'] = 'SET',
	['0xf9'] = 'TINY_BLOB',
	['0xfa'] = 'MEDIUM_BLOB',
	['0xfb'] = 'LONG_BLOB',
	['0xfc'] = 'BLOB',
	['0xfd'] = 'VAR_STRING',
	['0xfe'] = 'STRING',
	['0xff'] = 'GEOMETRY',
}

function columns.dummy_parser(data)
	return data
end

function columns.byte_parser(data)
	return string.byte(data)
end

function columns.signedint_parser(data)
	return struct.unpack('<i', data)
end

columns.definition41 = {
	{size = nil, name = 'catalog', parser = columns.dummy_parser},
	{size = nil, name = 'schema', parser = columns.dummy_parser},
	{size = nil, name = 'table', parser = columns.dummy_parser},
	{size = nil, name = 'org_table', parser = columns.dummy_parser},
	{size = nil, name = 'name', parser = columns.dummy_parser},
	{size = nil, name = 'org_name', parser = columns.dummy_parser},
	{size = 1, name = 'length_fixed_fields', parser = columns.byte_parser}, -- always [0c]
	{size = 2, name = 'character_set', parser = columns.byte_parser},
	{size = 4, name = 'column_length', parser = columns.signedint_parser},
	{size = 1, name = 'type', parser = columns.byte_parser},
	{size = 2, name = 'flags', parser = columns.byte_parser},
	{size = 1, name = 'decimals', parser = columns.byte_parser},
	{size = 2, name = 'filler', parser = columns.dummy_parser}
}

return columns
