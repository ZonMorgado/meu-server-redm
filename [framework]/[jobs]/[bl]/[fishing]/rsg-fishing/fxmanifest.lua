fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game 'rdr3'

description 'rsg-fishing'
version '2.0.3'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

client_scripts {
    'client/client_js.js',
    'client/client.lua',
}

server_scripts {
    'server/server.lua',
    'server/versionchecker.lua'
}

files {
    'locales/*.json',
}

dependencies {
    'rsg-core',
    'ox_lib'
}

exports {
    'GET_TASK_FISHING_DATA',
    'SET_TASK_FISHING_DATA',
    'VERTICAL_PROBE'
}

lua54 'yes'
