-- test.lua

math.randomseed(os.clock() * 100000000000)

local app = 'app_lua'
local mysql = 'mysql_lua'
local network = 'network_lua'

function sh(cmd, ...)
	local status, a, b, c = os.execute(string.format(cmd, unpack(arg)))
	if status ~= 0 then
		clear(1)
	end
end

function clear(rc)
	sh('docker rm -f %s %s', app, mysql)
	sh('docker network rm %s', network)
	os.exit(rc)
end

sh('docker network create --subnet 172.27.0.0/24 %s', network)
sh('docker run -dti --name %s --network %s alpine', app, network)
sh("docker run -d -e MYSQL_ROOT_PASSWORD=123 --name %s --network %s mariadb", mysql, network)

sh('docker cp ../ %s:/opt/lua-mysql', app)
--sh('docker exec -ti %s apk add luarocks5.1 lua5.1-dev gcc musl-dev git', app)
sh('docker exec -ti %s apk add luarocks5.1 lua-socket git', app)
sh('docker exec -ti %s sh -c "sed -i \'s/.*luasocket.*//\' /opt/lua-mysql/lua-mysql-0.0.1-1.rockspec"', app)
sh("docker exec -ti %s sh -c 'cd /opt/lua-mysql && luarocks-5.1 make *.rockspec'", app)
sh('docker exec -ti %s lua /opt/lua-mysql/tests/ddl.lua', app)
clear(0)