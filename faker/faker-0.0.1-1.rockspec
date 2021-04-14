package = 'faker'
version = '0.0.1-1'

source = {
	url = 'github.com/hector-vido/lua-faker.git'
}

description = {
	summary = 'Faker is a lua library that generates fake data for you.',
	detailed = [[
Faker is a lua library that generates fake data for you.
Whether you need to bootstrap your database, create good-looking XML documents, fill-in your persistence to stress test it, or anonymize data taken from a production service, Faker is for you.
Faker is heavily inspired by PHP Faker, Perl Faker, Ruby Faker and by Python Faker.
]],
	homepage = 'github.com/hector-vido/lua-faker',
	license = 'MIT'
}

dependencies = {
	'lua >= 5.1',
}

build = {
	type = 'builtin',
	modules = {
		['faker.init'] = 'faker/init.lua',
		['faker.generators.en_US'] = 'faker/generators/en_US.lua',
		['faker.generators.pt_BR'] = 'faker/generators/pt_BR.lua',
	},
	copy_directories = {'data'}
}
