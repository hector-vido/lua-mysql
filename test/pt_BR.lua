-- pt_BR.lua

local pt_BR = {firstnames = {{}, {}}, lastnames = {}, countries = {}, states = {}, cities = {}}

function pt_BR.firstname(properties)
	-- 1 - feminine
	local data = assert(io.open('data/pt_BR/firstnames-feminine.csv', 'rb')):read('*all')
	for name in string.gmatch(data, '[%S]+') do
		pt_BR.firstnames[1][#pt_BR.firstnames[1] + 1] = name
	end
	-- 2 - masculine
	data = assert(io.open('data/pt_BR/firstnames-masculine.csv', 'rb')):read('*all')
	for name in string.gmatch(data, '[%S]+') do
		pt_BR.firstnames[2][#pt_BR.firstnames[2] + 1] = name
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
	return pt_BR.firstname(properties)
end

function pt_BR.lastname()
	local data = assert(io.open('data/pt_BR/lastnames.csv', 'rb')):read('*all')
	for name in string.gmatch(data, '[^\n]+') do
		pt_BR.lastnames[#pt_BR.lastnames + 1] = name
	end
	function pt_BR.lastname()
		return pt_BR.lastnames[math.random(1, #pt_BR.lastnames)]
	end
	return pt_BR.lastname()
end

function pt_BR.name(properties)
	return pt_BR.firstname(properties or {}) .. ' ' .. pt_BR.lastname()
end

function pt_BR.email(properties)
	local username = pt_BR.firstname(properties) .. '.' .. string.gsub(pt_BR.lastname(), '%s+', '')
	return string.gsub(string.lower(pt_BR.normalize(username)), "'", '') .. '@example.com'
end

function pt_BR.country()
	local data = assert(io.open('data/pt_BR/countries.csv', 'rb')):read('*all')
	for item in string.gmatch(data, '[^\n]+') do
		pt_BR.countries[#pt_BR.countries + 1] = item
	end
	function pt_BR.country()
		return pt_BR.countries[math.random(1, #pt_BR.countries)]
	end
	return pt_BR.country()
end

function pt_BR.state()
	local data = assert(io.open('data/pt_BR/states.csv', 'rb')):read('*all')
	for item in string.gmatch(data, '[^\n]+') do
		pt_BR.states[#pt_BR.states + 1] = item
	end
	function pt_BR.state()
		return pt_BR.states[math.random(1, #pt_BR.states)]
	end
	return pt_BR.state()
end

function pt_BR.city()
	local data = assert(io.open('data/pt_BR/cities.csv', 'rb')):read('*all')
	for item in string.gmatch(data, '[^\n]+') do
		pt_BR.cities[#pt_BR.cities + 1] = item
	end
	function pt_BR.city()
		return pt_BR.cities[math.random(1, #pt_BR.cities)]
	end
	return pt_BR.city()
end

local cep = {0,0,0,0,0,0,0,0}
function pt_BR.cep()
	for i = 1,8 do
		cep[i] = math.random(1,9)
	end
	return string.format('%s%s%s%s%s-%s%s%s', cep[1], cep[2], cep[3], cep[4], cep[5], cep[6], cep[7], cep[8], cep[9])
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
	['à'] = 'a', ['á'] = 'a', ['â'] = 'a', ['ã'] = 'a', ['ä'] = 'a',
	['À'] = 'A', ['Á'] = 'A', ['Â'] = 'A', ['Ã'] = 'A', ['Ä'] = 'A',
	['ç'] = 'c', ['Ç'] = 'C',
	['è'] = 'e', ['é'] = 'e', ['ê'] = 'e', ['ë'] = 'e',
	['È'] = 'E', ['É'] = 'E', ['Ê'] = 'E', ['Ë'] = 'E',
	['ì'] = 'i', ['í'] = 'i', ['î'] = 'i', ['ï'] = 'i',
	['Ì'] = 'I', ['Í'] = 'I', ['Î'] = 'I', ['Ï'] = 'I',
	['ñ'] = 'n', ['Ñ'] = 'N',
	['ò'] = 'o', ['ó'] = 'o', ['ô'] = 'o', ['õ'] = 'o', ['ö'] = 'o',
	['Ò'] = 'O', ['Ó'] = 'O', ['Ô'] = 'O', ['Õ'] = 'O', ['Ö'] = 'O',
	['ù'] = 'u', ['ú'] = 'u', ['û'] = 'u', ['ü'] = 'u',
	['Ù'] = 'U', ['Ú'] = 'U', ['Û'] = 'U', ['Ü'] = 'U',
	['ý'] = 'y', ['ÿ'] = 'y',
	['Ý'] = 'Y', ['Ÿ'] = 'Y'
}
function pt_BR.normalize(str)
	return string.gsub(str, '[%z\1-\127\194-\244][\128-\191]*', accents)
end

return pt_BR
