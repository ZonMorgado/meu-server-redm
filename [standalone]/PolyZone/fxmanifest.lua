game 'rdr3'
fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

lua54 'yes'
description 'Define zones of different shapes and test whether a point is inside or outside of the zone'
version '2.6.2'

client_scripts {
    'client.lua',
    'BoxZone.lua',
    'EntityZone.lua',
    'CircleZone.lua',
    'ComboZone.lua',
    'creation/client/*.lua'
}

server_scripts {
    'creation/server/*.lua',
    'server.lua'
}
