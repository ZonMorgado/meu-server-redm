fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game 'rdr3'

author 'Wolfe Larsen#0495 rework of RexShack#3041 original work'
description 'rsg-cocaine, credit to rsg-indiantobacco'

client_scripts {
    'client/client.lua',
    'client/trader.lua'
}

server_scripts {
    'server/server.lua',
    '@oxmysql/lib/MySQL.lua',
}

shared_scripts { 
    '@ox_lib/init.lua',
    'config.lua',
}

lua54 'yes'
