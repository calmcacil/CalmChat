-- CalmChat - Custom Chat Setup Addon
-- Author: Calmcacil
-- Optimized version with improved error handling and code quality

local ADDON_NAME = "CalmChat"

-- Settings
local AUTO_SETUP_ENABLED = true -- Set to false to disable automatic setup

-- Constants
local CHAT_CONFIG = {
    FONT_SIZE = 14,
    FRAME_OFFSET_X = 1,
    FRAME_OFFSET_Y = 3,

    -- Frame Names
    FRAME_NAMES = {
        [1] = "General",
        [2] = "Log",
        [3] = nil, -- Voice/Transcription (special handling)
        [4] = "Loot/Trade",
        [5] = nil, -- Dynamic (Services/LFG based on version)
    },

    -- CVars to configure
    CVARS = {
        chatStyle = "classic",
        whisperMode = "inline",
        colorChatNamesByClass = "1",
        chatClassColorOverride = "0",
        speechToText = "0",
        textToSpeech = "0",
    },

    -- Message groups to remove from General
    GENERAL_REMOVALS = {
        "COMBAT_XP_GAIN",
        "COMBAT_HONOR_GAIN",
        "COMBAT_FACTION_CHANGE",
        "LOOT",
        "TRADESKILL"
    },

    -- Message groups to add to Loot/Trade frame
    LOOT_GROUPS = {
        "COMBAT_XP_GAIN",
        "COMBAT_HONOR_GAIN",
        "COMBAT_FACTION_CHANGE",
        "SKILL",
        "LOOT",
        "CURRENCY",
        "MONEY",
        "TRADESKILL"
    },
}

-- Utility Functions
local function SafeCall(func, ...)
    local success, err = pcall(func, ...)
    if not success then
        print("|cffbe1c1c[" .. ADDON_NAME .. "]|r Error:", err)
        return false
    end
    return true
end

local function IsRetail()
    return WOW_PROJECT_ID == WOW_PROJECT_MAINLINE
end

local function FrameExists(frameName)
    return _G[frameName] ~= nil
end

local function GetChatFrameByName(name)
    if not _G.CHAT_FRAMES then return nil end

    for _, frameName in ipairs(_G.CHAT_FRAMES) do
        local frame = _G[frameName]
        if frame and frame.name == name then
            return frame
        end
    end
    return nil
end

local function IsChatAlreadyConfigured()
    -- Check if the expected custom chat frames exist
    local expectedFrames = {
        "Loot/Trade",
        IsRetail() and "Services" or "LFG"
    }

    for _, expectedName in ipairs(expectedFrames) do
        if not GetChatFrameByName(expectedName) then
            return false
        end
    end

    -- Check if we have at least 5 chat frames
    local frameCount = 0
    if _G.CHAT_FRAMES then
        for _, frameName in ipairs(_G.CHAT_FRAMES) do
            if _G[frameName] then
                frameCount = frameCount + 1
            end
        end
    end

    if frameCount < 5 then
        return false
    end

    return true
end

-- Configuration Functions
local function ConfigureCVars()
    for cvar, value in pairs(CHAT_CONFIG.CVARS) do
        SafeCall(SetCVar, cvar, value)
    end
end

local function SetupChatFrames()
    -- Reset and create new windows
    if not SafeCall(FCF_ResetChatWindows) then
        return false
    end

    SafeCall(FCF_OpenNewWindow)
    SafeCall(FCF_OpenNewWindow)

    -- Configure each chat frame
    for _, frameName in ipairs(_G.CHAT_FRAMES or {}) do
        local frame = _G[frameName]
        if frame then
            local id = frame:GetID()

            -- Set font size for all frames
            SafeCall(FCF_SetChatWindowFontSize, nil, frame, CHAT_CONFIG.FONT_SIZE)

            -- Configure specific frames
            if id == 1 then
                -- General chat
                SafeCall(FCF_SetWindowName, frame, CHAT_CONFIG.FRAME_NAMES[1])

                -- Position frame (fix: was frame:Point, should be frame:SetPoint)
                if FrameExists("LeftChatToggleButton") then
                    SafeCall(function()
                        frame:ClearAllPoints()
                        frame:SetPoint(
                            "BOTTOMLEFT",
                            _G.LeftChatToggleButton,
                            "TOPLEFT",
                            CHAT_CONFIG.FRAME_OFFSET_X,
                            CHAT_CONFIG.FRAME_OFFSET_Y
                        )
                    end)
                end
            elseif id == 2 then
                -- Log
                SafeCall(FCF_SetWindowName, frame, CHAT_CONFIG.FRAME_NAMES[2])
            elseif id == 3 then
                -- Voice/Transcription frame
                if VoiceTranscriptionFrame_UpdateVisibility then
                    SafeCall(VoiceTranscriptionFrame_UpdateVisibility, frame)
                end
                if VoiceTranscriptionFrame_UpdateVoiceTab then
                    SafeCall(VoiceTranscriptionFrame_UpdateVoiceTab, frame)
                end
                if VoiceTranscriptionFrame_UpdateEditBox then
                    SafeCall(VoiceTranscriptionFrame_UpdateEditBox, frame)
                end
            elseif id == 4 then
                -- Loot/Trade
                SafeCall(FCF_SetWindowName, frame, CHAT_CONFIG.FRAME_NAMES[4])
            elseif id == 5 then
                -- Services (Retail) or LFG (Classic)
                local name = IsRetail() and "Services" or "LFG"
                SafeCall(FCF_SetWindowName, frame, name)
            end
        else
            print("|cffbe1c1c[" .. ADDON_NAME .. "]|r Warning: Frame", frameName, "not found")
        end
    end

    return true
end

local function ConfigureMessageGroups()
    local cf1 = _G.ChatFrame1
    local cf4 = _G.ChatFrame4

    if not cf1 or not cf4 then
        print("|cffbe1c1c[" .. ADDON_NAME .. "]|r Error: Required chat frames not found")
        return false
    end

    -- Remove unwanted messages from General chat
    SafeCall(RemoveChatWindowChannel, cf1:GetID(), "Trade")
    SafeCall(RemoveChatWindowChannel, cf1:GetID(), "Services")

    for _, group in ipairs(CHAT_CONFIG.GENERAL_REMOVALS) do
        SafeCall(ChatFrame_RemoveMessageGroup, cf1, group)
    end

    -- Configure Loot/Trade frame
    SafeCall(ChatFrame_RemoveAllMessageGroups, cf4)
    SafeCall(AddChatWindowChannel, cf4:GetID(), "Trade")

    for _, group in ipairs(CHAT_CONFIG.LOOT_GROUPS) do
        SafeCall(ChatFrame_AddMessageGroup, cf4, group)
    end

    return true
end

local function SetupChannels()
    local cf5 = _G.ChatFrame5

    if not cf5 then
        print("|cffbe1c1c[" .. ADDON_NAME .. "]|r Warning: ChatFrame5 not found")
        return false
    end

    if not IsRetail() then
        -- Classic Era/Season of Discovery channels
        local locale = GetLocale()
        if locale == "enUS" or locale == "enGB" then
            SafeCall(JoinPermanentChannel, "LookingForGroup")
            SafeCall(JoinPermanentChannel, "Layer")
            SafeCall(AddChatWindowChannel, cf5:GetID(), "LookingForGroup")
        end
    else
        -- Retail specific setup
        SafeCall(ChatFrame_RemoveAllMessageGroups, cf5)
        SafeCall(AddChatWindowChannel, cf5:GetID(), "Services")

        -- Add ping notifications to General chat
        if _G.ChatFrame1 then
            SafeCall(ChatFrame_AddMessageGroup, _G.ChatFrame1, "PING")
        end
    end

    return true
end

-- Main Setup Function
local function SetupChat(isAutomatic)
    if isAutomatic then
        print("|cff00ff00[" .. ADDON_NAME .. "]|r Auto-configuring chat (missing tabs detected)...")
    else
        print("|cff00ff00[" .. ADDON_NAME .. "]|r Starting chat setup...")
    end

    local success = true

    -- Step 1: Configure CVars
    ConfigureCVars()

    -- Step 2: Setup chat frames
    if not SetupChatFrames() then
        success = false
    end

    -- Step 3: Configure message groups
    if not ConfigureMessageGroups() then
        success = false
    end

    -- Step 4: Setup channels
    if not SetupChannels() then
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

-- Slash Command Registration
SLASH_SETUPCHAT1 = "/csetupchat"
SLASH_SETUPCHAT2 = "/calmchat"
SlashCmdList["SETUPCHAT"] = function()
    SetupChat(false) -- false = manual setup
end

-- Toggle auto-setup command
SLASH_CALMCHAT_AUTO1 = "/csetupauto"
SlashCmdList["CALMCHAT_AUTO"] = function(arg)
    if arg == "on" then
        AUTO_SETUP_ENABLED = true
        print("|cff00ff00[" .. ADDON_NAME .. "]|r Automatic setup |cff00ff00enabled|r.")
    elseif arg == "off" then
        AUTO_SETUP_ENABLED = false
        print("|cff00ff00[" .. ADDON_NAME .. "]|r Automatic setup |cffff0000disabled|r.")
    else
        local status = AUTO_SETUP_ENABLED and "|cff00ff00enabled|r" or "|cffff0000disabled|r"
        print("|cff00ff00[" .. ADDON_NAME .. "]|r Automatic setup is currently " .. status .. ".")
        print("Usage: /csetupauto [on|off]")
    end
end
