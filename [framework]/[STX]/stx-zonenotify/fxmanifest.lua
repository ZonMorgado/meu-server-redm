fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game 'rdr3'

author 'VORP @AndrewR3K'
description 'rsg-zonenotify'
version '1.0.0'

client_scripts {
    'client/client.lua',
    'config.lua'
}

shared_scripts {
    'config.lua'
}

files {
    'ui/*',
    'ui/assets/*',
    'ui/assets/fonts/*'
}
    
ui_page {
    'ui/index.html'
}

dependencies { 
    'rsg-core',
}

lua54 'yes'
