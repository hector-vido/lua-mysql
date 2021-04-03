package = "lua-mysql"
version = "0.0.1-1"

source = {
   url = "github.com/hector-vido/lua-mysql.git"
}

description = {
   summary = "A pure lua driver for MySQL.",
   detailed = [[
A pure lua driver for MySQL.
]],
   homepage = "github.com/hector-vido/lua-mysql",
   license = "MIT"
}

dependencies = {
	"bitop-lua",
	"luasocket",
	"lua-struct",
	"sha1"
}

build = {
   type = "builtin",
   modules = {
      ["mysql.capabilities"] = "mysql/capabilities.lua",
      ["mysql.charsets"] = "mysql/charsets.lua",
      ["mysql.columns"] = "mysql/columns.lua",
      ["mysql.commands"] = "mysql/commands.lua",
      ["mysql.init"] = "mysql/init.lua",
      ["mysql.packets"] = "mysql/packets.lua"
   }
}
