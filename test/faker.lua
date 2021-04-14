-- faker.lua
-- Generates random names, emails, numbers and etc

local Faker = {}

math.randomseed(os.clock() * 100000000000)
local random = math.random

function Faker:new(o)
	o = o or {locale = 'en_US'}
	o.generator = require(o.locale)
	setmetatable(o, self)
	self.__index = function(t, k)
		return self[k] or o.generator[k]
	end
	return o
end

function Faker.randstring(size)
	local piece = tostring(Faker.randint(size or 10))
	if #piece < 7 then piece = '0' .. piece end
	local rstring = {}
	for char in string.gmatch(piece, '.') do
		rstring[#rstring + 1] = string.char((char % 122) + 97)
	end
	return table.concat(rstring)
end

function Faker.randint(size)
	if size then
		local first = '1' .. string.rep('0', size - 1)
		local second = string.rep('9', size)
		return random(first, second)
	else
		return random(9999999999)
	end
end

local faker = Faker:new({locale = 'pt_BR'})
for i = 1, 10 do
	print(faker.randstring())
	print(faker.randint(10))
	print(faker.name())
	print(faker.email())
	print(faker.cpf())
	print(faker.country())
	print(faker.state())
	print(faker.city())
	print(faker.cep())
end

return Faker