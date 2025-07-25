local C = Config
local S = C.Settings
local D = C.DebugMode
local N = C.NotiMessages
local NotificationType = string.lower(S.Notification) or nil
local language = S.lang
local Translation = C.NotiMessages
local frameWorkType = string.lower(S.FrameWork) or nil
local InventoryType = string.lower(S.FrameWork) or nil

CurrentNotiSystem = nil
CurrentFramework = nil
CurrentInventory = nil
CanScriptRun = true
FrameWorkExport = nil


-- Tables for storing info
GetFrameWork = {
    QBcore = 'qb',
    ESX = 'esx',
    -- Add more here
}
GetInventory = {
    OX = 'ox_inventory',
    QBcore = 'qb_invetory',
    -- Add more here
}
GetNotiSystem = {
    OX = 'ox',
    QBcore = 'qb',
    ESX = 'esx',
    -- Add more here
}
NotifSystemTypes = { -- Defualt values, but will change with different notification systems
    typeInform = 'inform',
    typeError = 'error',
    typeSuccess = 'success',
    typeWarning = 'warning'
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
        CanScriptRun = false
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
        CanScriptRun = false
    end
end

function InitializeNotiType()
    if NotificationType == GetNotiSystem.OX then
        CurrentNotiSystem = 'ox'
        NotifSystemTypes = {
            typeInform = 'inform',
            typeError = 'error',
            typeSuccess = 'success',
            typeWarning = 'warning'
        }
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

---@param msg string
---@param type string
---@param translation boolean -- If true will run msg through GetTranslation function
function SendNotification(msg, type, translation)
    local title = '[ACE] Player Rob'
    local msg = msg
    local translation = translation or false
    if not msg then DebugPrint("No msg provided for Notification, cant send") return end
    if translation then
         msg = GetTranslation(msg) or '[ERROR] no message provided for notification'
    else
        msg = msg or '[ERROR] no message provided for notification'
    end
    type = type or 'success'

    if CurrentNotiSystem == 'ox' then
        lib.notify({
            title = title,
            description = msg,
            type = type
        })
    elseif CurrentNotiSystem == 'qb' then
        TriggerEvent('QBCore:Notify', msg, type)
    elseif CurrentNotiSystem == 'esx' then
        FrameWorkExport.ShowNotification(msg)
    else
        -- Custom noti system here
    end
end

RegisterCommand('acedebugrob', function ()
    PrintStartDebugInfo()
end, false)

InitializeFrameWork()
InitializeInventory()
InitializeNotiType()
if D then PrintStartDebugInfo() SendNotification('script_initiated', NotifSystemTypes.typeInform, true) end