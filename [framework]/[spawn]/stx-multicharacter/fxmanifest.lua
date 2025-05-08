fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

description 'rsg-multicharacter'
version '2.3.0'

ui_page "nui://jo_libs/nui/menu/index.html"


client_scripts {
    'client/functions.lua',
    'client/main.lua'
}

shared_scripts {
    '@jo_libs/init.lua',
    '@ox_lib/init.lua',
    'config.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/versionchecker.lua'
}

escrow_ignore {
    'config.lua',
}

dependencies {
    'jo_libs',
    'rsg-core'
}

jo_libs {
    'print',
    'menu',
    'ui',
}



lua54 'yes'
