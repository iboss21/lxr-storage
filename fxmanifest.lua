fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author 'Brandon Bigness (HHRP)'
description 'Biggies Storage (VORP) — per-town unlinked storage with upgradeable slots via NPC'
version '1.0.0'

dependency 'vorp_core'
dependency 'vorp_inventory'
dependency 'vorp_menu'

shared_scripts {
    'config/config.lua',
    'locales/en.lua'
}

client_scripts {
    '@vorp_core/client/dataview.lua',
    'client/client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/server.lua'
}
