-- General Guide: Player = Source[Robber], NearestPlayer = The player that is being robbed

local C = Config
local S = C.Settings
local D = C.DebugMode
local RobbingMode = S.Mode
local ProtectOnDutyPersonel = S.ProtectOnDutyPersonel or nil
local ProtectedPersonelTable = S.ProtectedPersonel
local ItemNeeded = S.NeedsItem or false
local NearestPlayer, isNearestPlayerDead, isSourceDead
CurrentRobbingMode = nil
local RobbingModesTable = {
    handsup = 'handsuponly',
    Dead = 'onlydead',
    Both = 'bothdeadandhandsuponly'
}

-- Player Global Varialbles
CurrentClosestPlayer = nil
CurrentClosestPlayerDistance = nil

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

function GetClosestPlayer()
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 0)

    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
            local distance = GetDistanceBetweenCoords(targetCoords['x'], targetCoords['y'], targetCoords['z'], plyCoords['x'], plyCoords['y'], plyCoords['z'], true)
            if(closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end

    return closestPlayer, closestDistance
end


local function QBcore_initiateRobbery()
    local success = false
    local playerId = PlayerPedId()
    local coords = GetEntityCoords(PlayerPedId())
    local closestPlayer, closestDistance = FrameWorkExport.Functions.GetClosestPlayer(coords) -- Closest player should return id of closest player
    print(closestPlayer)
    if D then
        closestPlayer, closestDistance = FrameWorkExport.Functions.GetPlayerData()
    end
    if closestPlayer == -1 or not closestPlayer then DebugPrint("No player near you! [QB]") return false end
    local job = closestPlayer.job.name
    local onduty = closestPlayer.job.onduty

    CurrentClosestPlayer = closestPlayer
    CurrentClosestPlayerDistance = closestDistance

    print(job)
    if not job then DebugPrint("Error while trying to get player job [QB]") return false end
    --print(ProtectedPersonelTable[job])
    if not ProtectOnDutyPersonel then DebugPrint('ProtectOnDutyPersonel doesnnt exist, this shouldnt happen') return false end
    if ProtectOnDutyPersonel and ProtectedPersonelTable[job] and onduty then
        SendNotification('onduty_personel_error', NotifSystemTypes.typeError, true)
        return false
    end

    -- Start check for mode
    if not CurrentRobbingMode or not RobbingModesTable then DebugPrint("No robbing mode or table available, this shouldnt happen") return false end
    if CurrentRobbingMode == RobbingModesTable.handsup then
        DebugPrint("Proceeding with only hands up mode")
        local isPlayerHandsUp = HandsUpCheck(closestPlayer)
        if isPlayerHandsUp then
            success = true
        else
            SendNotification('player_doesnt_have_handsup', NotifSystemTypes.typeError, true)
        end
    elseif CurrentRobbingMode == RobbingModesTable.Dead then -- Needs testing with a 2nd player [Not done yet]
        DebugPrint("Proceeding with only dead mode")
        local isPlayerDead = closestPlayer.metadata.isdead
        if not isPlayerDead then
            SendNotification('rob_only_dead_players', NotifSystemTypes.typeError, true)
        else
            return true
        end
    end
    return success
end

local function ox_inventory_initiateRobbery()
    local success =  false
    print(CurrentClosestPlayer)
    return success
end


function InitiateRobbery()
    CurrentClosestPlayer = nil
    CurrentClosestPlayerDistance = nil

    if not CanScriptRun then SendNotification('This script isnt configured correctly and therefore cannot run!', NotifSystemTypes.typeError, false) return end

    local playerPed = GetPlayerPed(-1)
    if IsEntityDead(playerPed) then SendNotification('robbing_while_dead', NotifSystemTypes.typeError, true) isSourceDead = true return else isSourceDead = false end

    local fwSuccess, invSuccess
    if CurrentFramework == GetFrameWork.QBcore then
        DebugPrint("Proceeding With QBcore FrameWork")
        fwSuccess = QBcore_initiateRobbery()
    end
    if not fwSuccess then
        --SendNotification('robbing_distrupted', NotifSystemTypes.typeError, true)
        DebugPrint("Framework returned false, proceed cancled!")
        return
    end
    if CurrentInventory == GetInventory.OX then
        DebugPrint("Proceeding with Ox_Inventory")
        invSuccess = ox_inventory_initiateRobbery()
    end

    if invSuccess and fwSuccess then
        SendNotification('robbing_success', NotifSystemTypes.typeSuccess, true)
    else
        SendNotification('robbing_distrupted', NotifSystemTypes.typeError, true)
    end
end

function HandsUpCheck(player)
    local playertocheck = player
    local success = false
    if D then playertocheck = PlayerPedId() end
    local check = IsEntityPlayingAnim(playertocheck, "missminuteman_1ig_2", "handsup_base", 3)
    success = check or false
    DebugPrint(string.format("Checking if player has hands up: %s", check))
    return success
end


Wait(100)
InitializeRobbingMode(RobbingMode)