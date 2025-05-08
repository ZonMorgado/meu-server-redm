fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game 'rdr3'

author 'Enyo#8414'
description 'Armored Wagon Robbery'

shared_scripts {
	'config.lua',
}

client_scripts {
	'client/*lua',
}

server_scripts {
	 'server/*lua'
}

escrow_ignore {
	'config.lua',  -- Only ignore one file
	'installation/*', 
}

lua54 'yes'
