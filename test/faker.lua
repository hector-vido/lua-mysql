-- faker.lua
-- Generates random names, emails, numbers and etc

local Faker = {__index = Faker}

math.randomseed(os.clock() * 100000000000)
local random = math.random

local randstring = function(size)
	local piece = random(9999999999)
	if piece < 99999999 then piece = '0' .. piece end
	local rstring = {}
	for char in string.gmatch(piece, '.') do
		rstring[#rstring + 1] = string.char((char % 122) + 97)
	end
	return table.concat(rstring)
end

local randint = function(size)
	if size then
		local first = '1' .. string.rep('0', size - 1)
		local second = string.rep('9', size)
		return random(first, second)
	else
		return random(9999999999)
	end
end

function Faker:new(o)
	local faker = faker or {}
	setmetatable(faker, self)
	return faker
end

for i = 1, 10 do
	print(randstring())
	print(randint(10))
end

return Faker