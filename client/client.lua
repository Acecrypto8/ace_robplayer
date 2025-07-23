local C = Config
local S = C.Settings
local D = C.DebugMode
local cmdName = S.cmdName or 'rob'
local CanRobPersonel = S.ProtectOnDutyPersonel or nil
local robbingMode = S.Mode or nil

local function DebugPrint(msg)
    local msg = tostring(msg)
    if D then
        print('[DEBUG] ' .. msg)
    end
end
