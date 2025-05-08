resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

fx_version "adamant"
games {"rdr3"}
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author 'DFA-Developments'
description 'DFA-Mining By DFA-Developments'

shared_scripts {
    '@ox_lib/init.lua',
}

server_scripts {
	'config.lua',
	'server/sv_main.lua'
}

client_scripts {
	'config.lua',
	'client/cl_main.lua',
	'client/Util.lua'
}



lua54 'yes'