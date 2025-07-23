fx_version 'cerulean'
games { 'gta5' }

author 'AceCrypto <https://www.youtube.com/@acestudios5m>'
description 'A advnaced player robbing script for ox_inventory'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'Config.lua',
}

client_scripts {
    'client/functions.lua',
    'client/client.lua'
}

server_scripts {
    'server/discord.lua',
    'server/functions.lua',
    'server/server.lua'
}

dependencies {
    'ox_lib'
}

lua54 'yes'

-- My Discord: acecrypto
-- Add me if you have any questions!