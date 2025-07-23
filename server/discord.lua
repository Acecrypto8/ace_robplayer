local Settings = Config.DiscordLogs
local log = Settings.logActions
if not log then return end

local function DebugPrint(msg)
    local msg = tostring(msg)
    if Config.DebugMode then
        print('[DEBUG] ' .. msg)
    end
end

local logTypes = {
    resourceStart = {
        color = 3447003, -- Blue
        title = "Resource Has started"
    },
    openAdminMenu = {
        color = 3447003, -- Blue
        title = "Admin Menu Access"
    },
    createCompStash = {
        color = 15105570, -- Orange
        title = "Comp Stash Creation"
    },
    OpenGlobalStash = {
        color = 10181046, -- Purple
        title = "Global Stash Opened"
    },
    ClearStash = {
        color = 15158332, -- Red
        title = "Stash Cleared"
    },
    ClaimStash = {
        color = 3066993, -- Red
        title = "Stash Claimed by Player"
    },
}


---@param message string The message content to send
---@param type string The log type to determine which webhook, color, and title to use
function SendToDiscord(message, type)
    local webhookURL = Settings[type]
    local logMeta = logTypes[type]

    if not webhookURL then
        DebugPrint("^1[Discord Log]^0 Disabled webhook config or metadata for type: " .. (type or "unknown"))
    end

    if webhookURL == "N/A" or not logMeta then
        DebugPrint("^1[Discord Log Error]^0 Invalid or missing webhook config or metadata for type: " .. (type or "unknown"))
        return
    end

    local embed = {{
        ["color"] = logMeta.color,
        ["title"] = "**" .. logMeta.title .. "**",
        ["description"] = message,
        ["footer"] = { ["text"] = "Monitoring System - By AceCrypto" },
        ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }}

    PerformHttpRequest(webhookURL, function(err, text, headers)
        if err ~= 204 then
            DebugPrint("^1[Discord Log Error]^0 Failed to send webhook: " .. (text or "unknown error"))
        end
    end, 'POST', json.encode({
        username = "Ace - Stash Management Logs",
        avatar_url = "https://i.ibb.co/VWYnxMRR/Ace-Studios.png",
        embeds = embed
    }), {
        ['Content-Type'] = 'application/json'
    })
end
