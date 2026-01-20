fx_version 'cerulean'
game 'gta5'

author 'Zalco Team'
description 'Systeme de jobs interimaires avec 3D UI - 8 metiers'
version '1.0.0'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    '@es_extended/imports.lua',
    'config/config.lua',
}

client_scripts {
    'client/main.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
}

dependencies {
    'es_extended',
    'ox_lib',
    'ox_inventory',
    'oxmysql',
}
