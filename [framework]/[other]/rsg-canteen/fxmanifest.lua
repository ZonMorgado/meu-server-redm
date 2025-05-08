fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game 'rdr3'

description 'rsg-canteen'
version '2.0.2'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client/client.lua'
}

server_scripts {
    'server/server.lua',
    'server/versionchecker.lua'
}

dependencies {
    'rsg-core',
}

files {
  'locales/*.json'
}

lua54 'yes'
