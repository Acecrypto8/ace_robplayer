local C = Config
local S = C.Settings
local D = C.DebugMode
local NotificationType = string.lower(S.Notification) or nil
local language = S.lang
local Translation = C.NotiMessages
local frameWorkType = string.lower(S.FrameWork) or nil
local InventoryType = string.lower(S.FrameWork) or nil

CurrentNotiSystem = nil
CurrentInventory = nil
CurrentFramework = nil
CanScriptRun = true
FrameWorkExport = nil


-- Tables for storing info
local GetFrameWork = {
    QBcore = 'qb',
    ESX = 'esx',
    -- Add more here
}
local GetInventory = {
    OX = 'ox_inventory',
    QBcore = 'qb_invetory',
    -- Add more here
}
local GetNotiSystem = {
    OX = 'ox',
    QBcore = 'qb',
    ESX = 'esx',
    -- Add more here
}
---

---@param msg string
local function DebugPrint(msg)
    local msg = tostring(msg)
    if D then
        print('[DEBUG] ' .. msg)
    end
end

---@param key string -- e.g robbing_canceled
function GetTranslation(key)
    if not key then DebugPrint("Cannot get translation for this, no key provided!") return end
    if not language then DebugPrint("Cannot get translation for this, incorrect Language value in config!") return end
    if not Translation then DebugPrint("Cannot get translation for this, incorrect Translation value in config!") return end

    if not Translation[language] then DebugPrint("Cannot get translation for this, Translation Table doesnt exist!") return end
    if not Translation[language][key] then DebugPrint("Cannot get translation for this, Key doesnt exist!") return end

    return Translation[language][key]
end

function InitializeFrameWork()
    if frameWorkType == 'auto' then
        if GetResourceState('es_extended') == 'started' then
            FrameWorkExport = exports['es_extended']:getSharedObject()
            CurrentFramework = 'esx'
        elseif  GetResourceState('qb-core') == 'started' then
            FrameWorkExport = exports['qb-core']:GetCoreObject()
            CurrentFramework = 'qb'          
        else
            DebugPrint("Cant Find a compatible framework")
            CanScriptRun = false
        end
    elseif frameWorkType == GetFrameWork.QBcore then
        FrameWorkExport = exports['qb-core']:GetCoreObject()
        CurrentFramework = 'qb'
    elseif frameWorkType == GetFrameWork.ESX then
        FrameWorkExport = exports['es_extended']:getSharedObject()
        CurrentFramework = 'esx'
    else
        -- Custom FrameWork
        CanScriptRun = false -- Remove this if you implement custom logic
    end
end

function InitializeInventory() -- The script only supports ox_inventory
    if InventoryType == 'auto' then
        if GetResourceState('ox_inventory') == 'started' then
            CurrentInventory = GetInventory.OX
        elseif GetResourceState('qb-inventory') == 'started' then
            CurrentInventory = GetInventory.QBcore
        else
            DebugPrint("Cant find a supported CurrentInventory to use")
            CanScriptRun = false
        end
    elseif InventoryType == GetInventory.OX then
        CurrentInventory = GetInventory.OX
    elseif InventoryType == GetInventory.QBcore then
        CurrentInventory = GetInventory.QBcore
    else
        -- Custom CurrentInventory Here
        CanScriptRun = false -- Remove this if you implement custom logic
    end
end

function InitializeNotiType()
    if NotificationType == GetNotiSystem.OX then
        CurrentNotiSystem = 'ox'
    end
end

function PrintStartDebugInfo()
    DebugPrint('---')
    DebugPrint(string.format('Detected FrameWork: %s', CurrentFramework or "none"))
    DebugPrint(string.format('Detected CurrentInventory: %s', CurrentInventory or "none"))
    DebugPrint(string.format('Configured Notification System: %s', CurrentNotiSystem or "none"))
    DebugPrint(string.format('Language: %s', language or "none"))

    if not CanScriptRun then
        DebugPrint("The script is not configured correctly!")
    end
    DebugPrint('---')
end

function SendNotificationToClient(playerid, msg, type)
    if not playerid then DebugPrint("No player ID specified for notification, cannot send") return end
    local title = '[ACE] Player Rob'
    msg = msg or '[ERROR] no message provided for notification'
    type = type or 'success'

    if CurrentNotiSystem == 'ox' then
        TriggerClientEvent('ox_lib:notify', playerid, {
            type = type or 'error',
            title = title,
            description = msg or "Error"
        })
    elseif CurrentNotiSystem == 'qb' then
    
    elseif CurrentNotiSystem == 'esx' then

    else
        -- Custom noti system here
    end
end


InitializeFrameWork()
InitializeInventory()
InitializeNotiType()
if D then PrintStartDebugInfo() end