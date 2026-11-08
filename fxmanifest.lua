fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'pigeon-crouch'
author 'Pigeon Studios'
description 'Crouch on Left Ctrl with GTA\'s own crouched walk and aim, in place of stealth mode, synced for everyone.'
version '1.0.0'
repository 'https://github.com/pigeon-studios-uk/pigeon-crouch'

-- Pigeon Studios version registry entry, read by server/version_check.lua.
pigeon_slug 'pigeon-crouch'

client_scripts {
    'configuration/config.lua',
    'locales/*.lua',
    'client/main.lua',
}

server_scripts {
    'server/version_check.lua',
}
