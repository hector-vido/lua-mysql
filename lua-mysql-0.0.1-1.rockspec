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
      ["mysql.init"] = "mysql/init.lua",
      ["mysql.constants.capabilities"] = "mysql/constants/capabilities.lua",
      ["mysql.constants.charsets"] = "mysql/constants/charsets.lua",
      ["mysql.constants.columns"] = "mysql/constants/columns.lua",
      ["mysql.constants.commands"] = "mysql/constants/commands.lua",
      ["mysql.constants.packets"] = "mysql/constants/packets.lua"
   }
}
