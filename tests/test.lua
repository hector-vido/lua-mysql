-- test.lua

math.randomseed(os.clock() * 100000000000)

local app = math.random(10000, 99999)
local mysql = math.random(10000, 99999)
local network = math.random(10000, 99999)

function main()
	assert(os.execute(string.format('docker network create --subnet 172.27.0.0/16 %s', network)))
	assert(os.execute(string.format('docker container run -dti --name %s --network %s --ip 172.27.0.10 alpine', app, network)))
	assert(os.execute(string.format("docker container run -dti -e MYSQL_ROOT_PASSWORD='!Abc123' -e MYSQL_USER=lua -e MYSQL_PASSWORD=lua -e MYSQL_DATABASE=lua --name %s --network %s --ip 172.27.0.20 mariadb", mysql, network)))
	
	assert(os.execute(string.format('docker exec -ti %s "apk add luarocks5.1 && luarocks-5.1 install faker"', app)))
end

function clear()
	os.execute(string.format('docker container rm -f %s %s', app, mysql))
	os.execute(string.format('docker network rm %s', network))
end

local status, err = pcall(main)
if not status then
	print(err)
end
clear()