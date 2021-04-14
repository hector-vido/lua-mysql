-- en_US.lua

local en_US = {lastnames = {}, countries = {}, states = {}, cities = {}}

function en_US.load_firstnames()
	local firstnames = {{}, {}} -- avoid some rehashes
	-- 1 - feminine
	local data = assert(io.open('data/en_US/firstnames-feminine.csv', 'rb')):read('*all')
	for name in string.gmatch(data, '[%S]+') do
		firstnames[1][#firstnames[1] + 1] = name
	end
	-- 2 - masculine
	data = assert(io.open('data/en_US/firstnames-masculine.csv', 'rb')):read('*all')
	for name in string.gmatch(data, '[%S]+') do
		firstnames[2][#firstnames[2] + 1] = name
	end
	return firstnames
end

function en_US.load_lastnames()
	local lastnames = {} -- avoid some rehashes
	local data = assert(io.open('data/en_US/lastnames.csv', 'rb')):read('*all')
	for name in string.gmatch(data, '[^\n]+') do
		lastnames[#lastnames + 1] = name
	end
	return lastnames
end

function en_US.load_countries()
	local countries = {}
	local data = assert(io.open('data/en_US/countries.csv', 'rb')):read('*all')
	for item in string.gmatch(data, '[^\n]+') do
		countries[#countries + 1] = item
	end
	return countries
end

function en_US.load_states()
	local states = {}
	local data = assert(io.open('data/en_US/states.csv', 'rb')):read('*all')
	for item in string.gmatch(data, '[^\n]+') do
		states[#states + 1] = item
	end
	return states
end

function en_US.load_cities()
	local cities = {}
	local data = assert(io.open('data/en_US/cities.csv', 'rb')):read('*all')
	for item in string.gmatch(data, '[^\n]+') do
		cities[#cities + 1] = item
	end
	return cities
end

function en_US.ssn() -- ITIN
	local area = math.random(900, 999)
	local serial = math.random(0, 9999)
	local group = math.random(70, 99)
	while group == 89 or group == 93 do
		group = math.random(70, 99)
	end
	return string.format('%03d-%02d-%04d', area, group, serial)
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
function en_US.normalize(str)
	return string.gsub(str, '[%z\1-\127\194-\244][\128-\191]*', accents)
end

return en_US
