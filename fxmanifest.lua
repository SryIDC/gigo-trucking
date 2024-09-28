fx_version 'cerulean'
game 'gta5'

author "GIGO"
description 'Basic Trucking job qbx'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'shared.lua'
}

client_scripts {
    '@qbx_core/modules/playerdata.lua',
    'client/*.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}

lua54 'yes'