fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game 'rdr3'

description 'rex-horsetrainer'
version '2.0.1'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

client_scripts {
    'client/client.lua',
    'client/npcs.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/server.lua',
}

dependencies {
    'rsg-core',
    'rsg-horses',
    'ox_lib',
}

files {
  'locales/*.json'
}

lua54 'yes'
