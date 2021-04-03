-- columns.lua
-- define each data type inside MySQL
-- all columns constants had they prefix "MYSQL_TYPE_" removed
local struct = require('struct')

local COLUMNS = {
	DECIMAL = 0x00,
	TINY = 0x01,
	SHORT = 0x02,
	LONG = 0x03,
	FLOAT = 0x04,
	DOUBLE = 0x05,
	NULL = 0x06,
	TIMESTAMP = 0x07,
	LONGLONG = 0x08,
	INT24 = 0x09,
	DATE = 0x0a,
	TIME = 0x0b,
	DATETIME = 0x0c,
	YEAR = 0x0d,
	NEWDATE = 0x0e,
	VARCHAR = 0x0f,
	BIT = 0x10,
	TIMESTAMP2 = 0x11,
	DATETIME2 = 0x12,
	TIME2 = 0x13,
	NEWDECIMAL = 0xf6,
	ENUM = 0xf7,
	SET = 0xf8,
	TINY_BLOB = 0xf9,
	MEDIUM_BLOB = 0xfa,
	LONG_BLOB = 0xfb,
	BLOB = 0xfc,
	VAR_STRING = 0xfd,
	STRING = 0xfe,
	GEOMETRY = 0xff,
}

function COLUMNS.dummy_parser(data)
	return data
end

function COLUMNS.byte_parser(data)
	return string.byte(data)
end

function COLUMNS.signedint_parser(data)
	return struct.unpack('<i', data)
end

COLUMNS.DEFINITION41 = {
	{size = nil, name = 'catalog', parser = COLUMNS.dummy_parser},
	{size = nil, name = 'schema', parser = COLUMNS.dummy_parser},
	{size = nil, name = 'table', parser = COLUMNS.dummy_parser},
	{size = nil, name = 'org_table', parser = COLUMNS.dummy_parser},
	{size = nil, name = 'name', parser = COLUMNS.dummy_parser},
	{size = nil, name = 'org_name', parser = COLUMNS.dummy_parser},
	{size = 1, name = 'length_fixed_fields', parser = COLUMNS.byte_parser}, -- always [0c]
	{size = 2, name = 'character_set', parser = COLUMNS.byte_parser},
	{size = 4, name = 'column_length', parser = COLUMNS.signedint_parser},
	{size = 1, name = 'type', parser = COLUMNS.byte_parser},
	{size = 2, name = 'flags', parser = COLUMNS.byte_parser},
	{size = 1, name = 'decimals', parser = COLUMNS.byte_parser},
	{size = 2, name = 'filler', parser = COLUMNS.dummy_parser}
}

return COLUMNS
