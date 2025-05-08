fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game 'rdr3'

author 'RexShack#3041'
description 'stx-hotel'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    '@jo_libs/init.lua',
    '@rsg-core/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua',
    'config.lua',
}

client_scripts {
    'client/client.lua'
}

server_scripts {
    'server/server.lua',
    '@oxmysql/lib/MySQL.lua',
}

dependencies {
    'rsg-core',
    'ox_lib',
}

jo_libs {
    'menu',
    'animation',
  }

  ui_page "nui://jo_libs/nui/menu/index.html"

lua54 'yes'


