fx_version 'cerulean'
game 'gta5'

author 'ZaK2BaK5906'
description 'Système de contrebande d\'alcool avec farming, transformation et vente'
version '1.0.0'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'config/*.lua'
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/css/*.css',
    'html/js/*.js',
    'html/img/*.png',
    'locales/*.json'
}

lua54 'yes'

dependencies {
    'es_extended',
    'ox_inventory',
    'ox_lib',
    'oxmysql'
}
