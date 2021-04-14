-- faker.lua
-- Generates random names, emails, numbers and etc

local Faker = {}

math.randomseed(os.clock() * 100000000000)
local random = math.random

function Faker:new(o)
	o = o or {locale = 'en_US'}
	local generator = require(o.locale)
	for k, v in pairs(generator) do
		o[k] = v
	end
	setmetatable(o, self)
	self.__index = self
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

function Faker:firstname(properties)
	self.firstnames = self.load_firstnames()
	function self:firstname(properties)
		properties = properties or {}
		local gender = 1
		if properties.gender == 'masculine' then
			gender = 2
		elseif properties.gender ~= 'feminine' then
			gender = math.random(1, 2)
		end
		return self.firstnames[gender][math.random(1, #self.firstnames[gender])]
	end
	return self:firstname(properties)
end

function Faker:lastname()
	self.lastnames = self.load_lastnames()
	function self:lastname()
		return self.lastnames[math.random(1, #self.lastnames)]
	end
	return self:lastname()
end

function Faker:name(properties)
	return self:firstname(properties or {}) .. ' ' .. self:lastname()
end

function Faker:email(properties)
	local username = self:firstname(properties) .. '.' .. string.gsub(self:lastname(), '%s+', '')
	return string.gsub(string.lower(self.normalize(username)), "'", '') .. '@example.com'
end

function Faker:country()
	self.countries = self.load_countries()
	function self:country()
		return self.countries[math.random(1, #self.countries)]
	end
	return self:country()
end

function Faker:state()
	self.states = self.load_states()
	function self:state()
		return self.states[math.random(1, #self.states)]
	end
	return self:state()
end

function Faker:city()
	self.cities = self.load_cities()
	function self:city()
		return self.cities[math.random(1, #self.cities)]
	end
	return self:city()
end

local faker = Faker:new({locale = 'en_US'})
for i = 1, 100 do
	print(faker.randstring())
	print(faker.randint(10))
	print(faker:name())
	print(faker:email())
	-- print(faker.cpf())
	print(faker:country())
	print(faker:state())
	print(faker:city())
	print(faker.ssn())
	-- print(faker.cep())
end

return Faker