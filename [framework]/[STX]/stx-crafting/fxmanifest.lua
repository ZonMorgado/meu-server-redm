fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
lua54 'yes'

author 'Rehan'
description 'Crafting Menu for RedM using JO Lib Menu and RSG-Framework'
version '1.0.0'

client_scripts {
    'client.lua',
}

server_scripts {
    'server.lua',
}
shared_scripts {
  '@jo_libs/init.lua',
  '@ox_lib/init.lua',
  'config.lua'
  }

  jo_libs {
    'menu',
    'animation',
    'notification',
  }

  ui_page "nui://jo_libs/nui/menu/index.html"

dependencies {
    'jo_libs', 
    'rsg-core', 
}


