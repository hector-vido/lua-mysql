-- pt_BR.lua

local pt_BR = {firstnames = {{}, {}}, lastnames = {}}

-- firstnames - 1 - feminine
local data = assert(io.open('data/pt_BR/firstnames-feminine.csv', 'rb')):read('*all')
for name in string.gmatch(data, '[%S]+') do
	pt_BR.firstnames[1][#pt_BR.firstnames[1] + 1] = name
end

-- firstnames - 2 - masculine
data = assert(io.open('data/pt_BR/firstnames-masculine.csv', 'rb')):read('*all')
for name in string.gmatch(data, '[%S]+') do
	pt_BR.firstnames[2][#pt_BR.firstnames[2] + 1] = name
end

-- lastnames
data = assert(io.open('data/pt_BR/lastnames.csv', 'rb')):read('*all')
for name in string.gmatch(data, '[^\n]+') do
	pt_BR.lastnames[#pt_BR.lastnames + 1] = name
end

function pt_BR.firstname(properties)
	properties = properties or {}
	local gender = 1
	if properties.gender == 'masculine' then
		gender = 2
	elseif properties.gender ~= 'feminine' then
		gender = math.random(1, 2)
	end
	return pt_BR.firstnames[gender][math.random(1, #pt_BR.firstnames[gender])]
end

function pt_BR.lastname()
	return pt_BR.lastnames[math.random(1, #pt_BR.lastnames)]
end

function pt_BR.name(properties)
	return pt_BR.firstname(properties or {}) .. ' ' .. pt_BR.lastname()
end

function pt_BR.email(properties)
	return pt_BR.normalize(string.lower(pt_BR.firstname(properties) .. '.' .. string.gsub(pt_BR.lastname(), '%s+', ''))) .. '@example.com'
end

function pt_BR.cpf()
	local n = {0,0,0,0,0,0,0,0,0}
	for i = 1, 9 do
		n[i] = math.random(1, 9)
	end
	
	local d1 = 0
	for i = 1, 9 do
		d1 = d1 + n[#n + 1 - i] * (i + 1) -- reverse index
	end
	d1 = 11 - (d1 % 11)
	if d1 >= 10 then d1 = 0	end
	
	local d2 = 0
	n[#n + 1] = d1
	for i = 1, 10 do
		d2 = d2 + n[#n + 1 - i] * (i + 1) -- reverse index
	end
	d2 = 11 - (d2 % 11)
	if d2 >= 10 then d2 = 0	end
	
	return string.format('%s%s%s.%s%s%s.%s%s%s-%s%s', n[1], n[2], n[3], n[4], n[5], n[6], n[7], n[8], n[9], d1, d2)
end

local accents = {
	["à"] = "a", ["á"] = "a", ["â"] = "a", ["ã"] = "a", ["ä"] = "a",
	["ç"] = "c",
	["è"] = "e", ["é"] = "e", ["ê"] = "e", ["ë"] = "e",
	["ì"] = "i", ["í"] = "i", ["î"] = "i", ["ï"] = "i",
	["ñ"] = "n",
	["ò"] = "o", ["ó"] = "o", ["ô"] = "o", ["õ"] = "o", ["ö"] = "o",
	["ù"] = "u", ["ú"] = "u", ["û"] = "u", ["ü"] = "u",
	["ý"] = "y", ["ÿ"] = "y"
}
function pt_BR.normalize(str)
	return string.gsub(str, "[%z\1-\127\194-\244][\128-\191]*", accents)
end

return pt_BR
