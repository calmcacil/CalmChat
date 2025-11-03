-- CalmChat SlashCommands Module
-- Author: Calmcacil
-- Slash command handlers

-- Import required modules
local ADDON_NAME = CalmChat_Config.ADDON_NAME
local AUTO_SETUP_ENABLED = CalmChat_Config.AUTO_SETUP_ENABLED

-- Main setup function (will be available from Core module)
local function SetupChat(isAutomatic)
    -- This function will be provided by Core.lua
    if CalmChat_Core and CalmChat_Core.SetupChat then
        CalmChat_Core.SetupChat(isAutomatic)
    end
end

-- Toggle auto-setup command
local function ToggleAutoSetup(arg)
    if arg == "on" then
        CalmChat_Config.AUTO_SETUP_ENABLED = true
        print("|cff00ff00[" .. ADDON_NAME .. "]|r Automatic setup |cff00ff00enabled|r.")
    elseif arg == "off" then
        CalmChat_Config.AUTO_SETUP_ENABLED = false
        print("|cff00ff00[" .. ADDON_NAME .. "]|r Automatic setup |cffff0000disabled|r.")
    else
        local status = CalmChat_Config.AUTO_SETUP_ENABLED and "|cff00ff00enabled|r" or "|cffff0000disabled|r"
        print("|cff00ff00[" .. ADDON_NAME .. "]|r Automatic setup is currently " .. status .. ".")
        print("Usage: /csetupauto [on|off]")
    end
end

-- Register slash commands
SLASH_SETUPCHAT1 = "/csetupchat"
SLASH_SETUPCHAT2 = "/calmchat"
SlashCmdList["SETUPCHAT"] = function()
    SetupChat(false) -- false = manual setup
end

-- Toggle auto-setup command
SLASH_CALMCHAT_AUTO1 = "/csetupauto"
SlashCmdList["CALMCHAT_AUTO"] = ToggleAutoSetup

-- Export SlashCommands functionality
CalmChat_SlashCommands = {
    SetupChat = SetupChat,
    ToggleAutoSetup = ToggleAutoSetup
}