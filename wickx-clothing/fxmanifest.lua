fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'Kakarot'
description 'A menu providing players the ability to change their clothing and accessories'
version '1.2.0'

ui_page 'html/index.html'

shared_scripts {
    '@wickx-core/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua',
    'config.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/ComboZone.lua',
    'client/main.lua'
}

files {
    'html/index.html',
    'html/style.css',
    'html/reset.css',
    'html/script.js'
}
