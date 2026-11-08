Config = {}

-- Language for the key binding's name in GTA's settings. 'auto' follows ox_lib's language (setr ox:locale
-- "de" in server.cfg) and is English when that isn't set. Or name a file from locales/, such as 'de'.
Config.Locale = 'auto'

-- The key and the command. Players can change the key in GTA's Settings -> Key Bindings -> FiveM.
-- Codes: https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/
Config.Key = 'LCONTROL'
Config.Command = 'crouch'

-- Ctrl normally puts the player in GTA's stealth mode on foot. true turns that off, so Ctrl only crouches.
-- false keeps GTA's stealth mode as well (set Config.Key to another key then).
Config.ReplaceStealth = true

-- Players can't jump while crouched. false lets them (it stands them up).
Config.BlockJump = true

-- Update checks are controlled in server.cfg for every Pigeon Studios resource at once:
--     set pigeon_update_check "on"      (default)  |  "quiet"  |  "off"
