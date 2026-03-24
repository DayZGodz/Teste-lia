fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'LR_MAPS'
description 'LR_MAPS'
version '1.0.0'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/script.js'
}

shared_scripts {
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua',
    'permissions.lua'
}
