


fx_version 'cerulean'
description 'yamn'
author 'by yamn Dev '

game 'gta5'
shared_scripts {'@ox_lib/init.lua', 'shared/shared.lua'}

client_scripts {'client/client.lua',}

server_scripts {'server/server.lua',}

ui_page 'html/index.html'


files {
    'html/index.html',
    'html/styles.css',
    'html/script.js',
    'html/*.*',

}

server_scripts { '@mysql-async/lib/MySQL.lua' }

lua54 'yes'

escrow_ignore {
    'shared/shared.lua',
}

