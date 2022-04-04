fx_version 'adamant'

game 'gta5'

client_scripts {
    "src/RMenu.lua",
    "src/menu/RageUI.lua",
    "src/menu/Menu.lua",
    "src/menu/MenuController.lua",
    "src/components/*.lua",
    "src/menu/elements/*.lua",
    "src/menu/items/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/windows/*.lua"
}

client_scripts {
    '@es_extended/locale.lua',
    'config.lua',
	'ballas/client.lua',
    'ballas/cl_boss.lua',
    'famillies/client.lua',
    'famillies/cl_boss.lua',
    'marabunta/client.lua',
    'marabunta/cl_boss.lua',
    'vagos/client.lua',
    'vagos/cl_boss.lua',
    'cartel/client.lua',
    'cartel/cl_boss.lua',
    'mafia/client.lua',
    'mafia/cl_boss.lua',
    'bloods/client.lua',
    'bloods/cl_boss.lua',
    'blanchisseur/client.lua',
    'blanchisseur/cl_boss.lua' ,
}

server_scripts {
    '@es_extended/locale.lua',
    '@mysql-async/lib/MySQL.lua',
	'ballas/server.lua',
    'famillies/server.lua',
    'vagos/server.lua',
    'cartel/server.lua',
    'mafia/server.lua',
    'bloods/server.lua',
    'marabunta/server.lua',
    'blanchisseur/server.lua'
}

dependencies {
	'es_extended'
}