local ADDON_NAME, Addon = ...

SLASH_CALMCHAT1 = "/csetupchat"
SLASH_CALMCHAT2 = "/calmchat"

local function NormalizeCommand(message)
    message = Addon.util.Trim(message or "")
    return string.lower(message)
end

function SlashCmdList.CALMCHAT(message)
    local command = NormalizeCommand(message)
    if command == "config" or command == "options" or command == "settings" then
        Addon.OpenSettings()
    elseif command == "help" then
        Addon.Print("Usage: /calmchat to apply setup, /calmchat settings to open options.")
    else
        Addon.SetupChat()
    end
end

function CalmChat_OnAddonCompartmentClick()
    if not Addon.OpenSettings() then
        Addon.SetupChat()
    end
end
