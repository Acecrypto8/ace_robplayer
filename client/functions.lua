-- General Guide: Player = Source[Robber], NearestPlayer = The player that is being robbed

local C = Config
local S = C.Settings
local D = C.DebugMode
local RobbingMode = S.Mode
local CanRobPersonel = S.ProtectOnDutyPersonel or nil
local ItemNeeded = S.NeedsItem or false
local NearestPlayer, isNearestPlayerDead, isSourceDead
CurrentRobbingMode = nil
local RobbingModesTable = {
    handsup = 'handsuponly',
    Dead = 'onlydead',
    Both = 'bothdeadandhandsuponly'
}

local function DebugPrint(msg)
    local msg = tostring(msg)
    if D then
        print('[DEBUG] ' .. msg)
    end
end

function InitializeRobbingMode(mode)
    if not mode then return end
    if mode == 'OnlyWhenHandsUp' then
        CurrentRobbingMode = RobbingModesTable.handsup
    elseif mode == 'OnlyWhenDead' then
        CurrentRobbingMode = RobbingModesTable.Dead
    elseif mode == 'Both' then
        CurrentRobbingMode = RobbingModesTable.Both
    else
        CurrentRobbingMode = RobbingModesTable.handsup
        DebugPrint(string.format("Invalid Mode selected in config, defaulting to %s", CurrentRobbingMode))
        DebugPrint('---')
    end
    DebugPrint(string.format("Setting Robbing Mode to: %s", CurrentRobbingMode))
end


local function QBcore_initiateRobbery()
    local success = false
    
    return success
end

local function ox_inventory_initiateRobbery()
    local success =  false

    return success
end


function InitiateRobbery()
    if not CanScriptRun then SendNotification('This script isnt configured correctly and therefore cannot run!', NotifSystemTypes.typeError, false) return end

    local playerPed = GetPlayerPed(-1)
    if IsEntityDead(playerPed) then SendNotification('robbing_while_dead', NotifSystemTypes.typeError, true) isSourceDead = true return else isSourceDead = false end

    local fwSuccess, invSuccess
    if CurrentFramework == GetFrameWork.QBcore then
        DebugPrint("Proceeding With QBcore FrameWork")
        fwSuccess = QBcore_initiateRobbery()
    end
    if not fwSuccess then
        SendNotification('robbing_distrupted', NotifSystemTypes.typeError, true)
        return
    end
    if CurrentInventory == GetInventory.OX then
        DebugPrint("Proceeding with Ox_Inventory")
        invSuccess = ox_inventory_initiateRobbery()
    end

    if invSuccess and fwSuccess then
        SendNotification('robbing_initiated', NotifSystemTypes.typeSuccess, true)
    else
        SendNotification('robbing_distrupted', NotifSystemTypes.typeError, true)
    end
end


Wait(100)
InitializeRobbingMode(RobbingMode)