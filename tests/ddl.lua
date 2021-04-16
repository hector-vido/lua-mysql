-- ddl.lua
-- Execute lots of ddl commands

local MySQL = require('mysql')

local options = {
	host='mysql_lua',
	user='root',
	password='123'
}

local mysql = MySQL:connect(options)
assert(mysql:execute("CREATE DATABASE lua"))
assert(mysql:execute("USE lua"))
assert(mysql:execute("CREATE TABLE users (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255), email VARCHAR(255), country (200), state (200), city (200))"))
