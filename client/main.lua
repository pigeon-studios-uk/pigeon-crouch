--[[
    Pigeon Crouch: client.

    Left Ctrl crouches and stands up again, with GTA's own crouched walk (move_ped_crouched) and crouched
    aiming (move_ped_crouched_strafing). Ctrl's own stealth mode is turned off on foot so the two don't fight.
    Getting into a vehicle, swimming, falling, climbing, ragdolling or dying stands the player up.

    Other resources can read the replicated `crouching` state bag, the IsCrouching export, or listen for the
    local `pigeon-crouch:changed` event (for example to put a walk style back), and stop crouching with
    SetBlocked. Movement clipsets are synced by the game, so everyone sees it.
]]

local RESOURCE = GetCurrentResourceName()

local WALK = 'move_ped_crouched'
local STRAFE = 'move_ped_crouched_strafing'
local WALK_HASH = GetHashKey(WALK)
local BLEND = 0.25
local TOGGLE_MS = 500           -- the shortest time between crouching and standing, so it can't be spammed

local STEALTH = 36              -- INPUT_DUCK: Ctrl's stealth mode
local JUMP = 22

-- 'auto' follows ox_lib's language (the ox:locale convar), and English when that isn't set.
local locale = Config.Locale == 'auto' and GetConvar('ox:locale', 'en') or Config.Locale
local strings = Locales[locale] or Locales.en

local crouched = false
local blocked = false           -- set by other resources through SetBlocked
local lastToggle = -math.huge

local function loadClipSet(name)
    if HasClipSetLoaded(name) then return true end
    RequestClipSet(name)
    local giveUp = GetGameTimer() + 3000
    while not HasClipSetLoaded(name) and GetGameTimer() < giveUp do Wait(0) end
    return HasClipSetLoaded(name)
end

--- True if the player is somewhere they can't crouch.
local function cantHere(ped)
    if IsPedInAnyVehicle(ped, false) or IsPedGettingIntoAVehicle(ped) then return true end
    if IsPedSwimming(ped) or IsPedFalling(ped) or IsPedClimbing(ped) or IsPedRagdoll(ped) then return true end
    if IsPedInParachuteFreeFall(ped) or IsPedDeadOrDying(ped, true) then return true end
    local parachute = GetPedParachuteState(ped)
    return parachute == 1 or parachute == 2
end

local function applyClipSets(ped)
    SetPedMovementClipset(ped, WALK, BLEND)
    SetPedStrafeClipset(ped, STRAFE)
end

local function setCrouched(value)
    crouched = value
    lastToggle = GetGameTimer()
    LocalPlayer.state:set('crouching', value or nil, true)
    TriggerEvent('pigeon-crouch:changed', value)
end

local function crouch()
    local ped = PlayerPedId()
    if blocked or cantHere(ped) then return end
    if not loadClipSet(WALK) or not loadClipSet(STRAFE) then return end
    if GetPedStealthMovement(ped) then SetPedStealthMovement(ped, false, 'DEFAULT_ACTION') end
    applyClipSets(ped)
    setCrouched(true)
end

local function stand()
    local ped = PlayerPedId()
    ResetPedMovementClipset(ped, BLEND)
    ResetPedStrafeClipset(ped)
    setCrouched(false)
end

-- Every frame on foot: keep Ctrl's stealth mode off, and while crouched, keep the crouched walk on (some
-- resources reset it, such as when changing weapons) and stand up if the player can't stay crouched.
CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local onFoot = not IsPedInAnyVehicle(ped, false)
        if crouched then
            if blocked or cantHere(ped) then
                stand()
            else
                if Config.BlockJump then DisableControlAction(0, JUMP, true) end
                if GetPedMovementClipset(ped) ~= WALK_HASH then applyClipSets(ped) end
            end
        end
        if Config.ReplaceStealth and onFoot then
            DisableControlAction(0, STEALTH, true)
            Wait(0)
        elseif crouched then
            Wait(0)
        else
            Wait(250)
        end
    end
end)

---------------------------------------------------------------------------
-- Key, command and exports

RegisterCommand(Config.Command, function()
    if GetGameTimer() - lastToggle < TOGGLE_MS then return end
    if crouched then stand() else crouch() end
end, false)
RegisterKeyMapping(Config.Command, strings.key_crouch or Locales.en.key_crouch, 'keyboard', Config.Key)

--- True while the player is crouched.
exports('IsCrouching', function() return crouched end)

--- Stop the player crouching (true), for example while handcuffed or carried, or let them again (false).
--- Blocking while they're crouched stands them up.
exports('SetBlocked', function(value) blocked = value and true or false end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= RESOURCE or not crouched then return end
    local ped = PlayerPedId()
    ResetPedMovementClipset(ped, 0.0)
    ResetPedStrafeClipset(ped)
    LocalPlayer.state:set('crouching', nil, true)
end)
