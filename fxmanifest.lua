
fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
author 'KevinGirardx'
description 'Item Trading System'
lua54 'yes'
game 'gta5'

files {
    'configs/*.lua',
    'client/*.lua',
}

shared_scripts {
    '@ox_lib/init.lua',
}

client_scripts {
    'bridge/client/**.lua',
    'bridge/interaction.lua',
    '@qbx_core/modules/lib.lua', -- comment this line if you don't use qbox
	'client/*.lua',
}

ox_libs {
	'math',
	-- 'locale',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'bridge/server/**.lua',
    'bridge/logging.lua',
    '@qbx_core/modules/lib.lua', -- comment this line if you don't use qbox
	'server/*.lua',
}