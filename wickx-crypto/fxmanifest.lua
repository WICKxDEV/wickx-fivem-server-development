fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'Kakarot'
description 'Provides the logic for handling cryptocurrency aka wickxbit'
version '1.2.1'

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
client_script 'client/main.lua'

dependency 'wickx-minigames'
