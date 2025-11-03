-- CalmChat Core Module
-- Author: Calmcacil
-- Main addon initialization and event handling

-- Import required modules
local ADDON_NAME = CalmChat_Config.ADDON_NAME
local AUTO_SETUP_ENABLED = CalmChat_Config.AUTO_SETUP_ENABLED
local SafeCall = CalmChat_Utils.SafeCall
local IsChatAlreadyConfigured = CalmChat_Utils.IsChatAlreadyConfigured

-- Main Setup Function
local function SetupChat(isAutomatic)
    if isAutomatic then
        print("|cff00ff00[" .. ADDON_NAME .. "]|r Auto-configuring chat (missing tabs detected)...")
    else
        print("|cff00ff00[" .. ADDON_NAME .. "]|r Starting chat setup...")
    end

    local success = true

    -- Step 1: Configure CVars
    CalmChat_CVars.ConfigureCVars()

    -- Step 2: Setup chat frames
    if not CalmChat_ChatFrames.SetupChatFrames() then
        success = false
    end

    -- Step 3: Configure message groups
    if not CalmChat_MessageGroups.ConfigureMessageGroups() then
        success = false
    end

    -- Step 4: Setup channels
    if not CalmChat_Channels.SetupChannels() then
        success = false
    end

    -- Step 5: Select General chat frame
    if _G.GENERAL_CHAT_DOCK and _G.ChatFrame1 then
        SafeCall(FCFDock_SelectWindow, _G.GENERAL_CHAT_DOCK, _G.ChatFrame1)
    end

    -- Final status message
    if success then
        print("|cff00ff00[" .. ADDON_NAME .. "]|r Chat setup completed successfully!")
    else
        print("|cffff9900[" .. ADDON_NAME .. "]|r Chat setup completed with warnings. Check the log above.")
    end
end

-- Event Handler
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_LOGIN")

eventFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        -- Wait a bit for chat frames to fully load
        C_Timer.After(2, function()
            if AUTO_SETUP_ENABLED and not IsChatAlreadyConfigured() then
                SetupChat(true) -- true = automatic setup
            else
                print("|cff00ff00[" .. ADDON_NAME .. "]|r Loaded. Type |cff00ffff/csetupchat|r to reconfigure chat.")
            end
        end)
    end
end)

-- Export Core functionality
CalmChat_Core = {
    SetupChat = SetupChat
}