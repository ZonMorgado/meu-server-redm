fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game 'rdr3'

description 'rex-guarma'
version '2.0.1'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

client_scripts {
    'client/client.lua',
    'client/npcs.lua',
}

server_scripts {
    'server/server.lua',
    'server/versionchecker.lua'
}

dependencies {
    'ox_lib',
    'rsg-core',
}

files {
  'locales/*.json'
}

lua54 'yes'
