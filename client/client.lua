local C = Config
local S = C.Settings
local D = C.DebugMode
local cmdName = S.cmdName or 'rob'

local function DebugPrint(msg)
    local msg = tostring(msg)
    if D then
        print('[DEBUG] ' .. msg)
    end
end


RegisterCommand(cmdName, function ()
    SendNotification('robbing_initiated', NotifSystemTypes.typeInform, true)
    Wait(100)
    InitiateRobbery()
end, false)