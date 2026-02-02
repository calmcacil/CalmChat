-- Services and Voice frame configuration
local ENABLE_SERVICES_TAB = false
local ENABLE_VOICE_FRAME = true

-- Main slash command handler
SLASH_SETUPCHAT1 = "/csetupchat"

function SlashCmdList.SETUPCHAT()
    SetupChat()
end

function SetupChat()
    local retail = (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE)

    -- CVars
    SetCVar("chatStyle", "classic")
    SetCVar("whisperMode", "inline")
    SetCVar("colorChatNamesByClass", "1")
    SetCVar("chatClassColorOverride", "0")
    SetCVar("speechToText", "0")
    SetCVar("textToSpeech", "0")

    -- Reset and create new windows (only create 4 frames if Services disabled)
    FCF_ResetChatWindows()
    FCF_OpenNewWindow()  -- Frame 4 (Loot/Trade)
    
    if ENABLE_SERVICES_TAB then
        FCF_OpenNewWindow()  -- Frame 5 (Services)
    end

    -- Configure all chat frames
    for _, name in ipairs(_G.CHAT_FRAMES) do
        local frame = _G[name]
        if frame then
            local id = frame:GetID()

            FCF_SetChatWindowFontSize(nil, frame, 14)

            if id == 1 then
                FCF_SetWindowName(frame, "General")
                frame:ClearAllPoints()
                if _G.LeftChatToggleButton then
                    frame:SetPoint("BOTTOMLEFT", _G.LeftChatToggleButton, "TOPLEFT", 1, 3)
                end
            elseif id == 2 then
                FCF_SetWindowName(frame, "Log")
            elseif id == 3 then
                if ENABLE_VOICE_FRAME then
                    if VoiceTranscriptionFrame_UpdateVisibility then
                        VoiceTranscriptionFrame_UpdateVisibility(frame)
                    end
                    if VoiceTranscriptionFrame_UpdateVoiceTab then
                        VoiceTranscriptionFrame_UpdateVoiceTab(frame)
                    end
                    if VoiceTranscriptionFrame_UpdateEditBox then
                        VoiceTranscriptionFrame_UpdateEditBox(frame)
                    end
                end
            elseif id == 4 then
                FCF_SetWindowName(frame, "Loot/Trade")
            elseif id == 5 then
                if retail and ENABLE_SERVICES_TAB then
                    FCF_SetWindowName(frame, "Services")
                elseif not retail then
                    FCF_SetWindowName(frame, "LFG")
                end
            end
        end
    end

    -- Configure ChatFrame1 (General)
    local generalRemovals = {"COMBAT_XP_GAIN", "COMBAT_HONOR_GAIN", "COMBAT_FACTION_CHANGE", "LOOT", "TRADESKILL"}
    _G.ChatFrame1:RemoveChannel("Trade")
    _G.ChatFrame1:RemoveChannel("Services")
    for _, v in ipairs(generalRemovals) do
        _G.ChatFrame1:RemoveMessageGroup(v)
    end

    -- Configure ChatFrame4 (Loot/Trade)
    if _G.ChatFrame4 then
        _G.ChatFrame4:RemoveAllMessageGroups()
        _G.ChatFrame4:AddChannel("Trade")
        local lootGroups = {"COMBAT_XP_GAIN", "COMBAT_HONOR_GAIN", "COMBAT_FACTION_CHANGE", "SKILL", "LOOT", "CURRENCY", "MONEY", "TRADESKILL"}
        for _, k in ipairs(lootGroups) do
            _G.ChatFrame4:AddMessageGroup(k)
        end
    end

    -- Configure ChatFrame5 (Services or LFG) - only if it exists
    if _G.ChatFrame5 then
        _G.ChatFrame5:RemoveAllMessageGroups()
        
        if retail and ENABLE_SERVICES_TAB then
            _G.ChatFrame5:AddChannel("Services")
        elseif not retail and GetLocale() == "enUS" then
            _G.ChatFrame5:AddChannel("LookingForGroup")
            JoinPermanentChannel("LookingForGroup")
            JoinPermanentChannel("Layer")
        end
        
        if retail and ENABLE_SERVICES_TAB then
            _G.ChatFrame1:AddMessageGroup("PING")
        end
    end

    -- Select General tab and finish
    FCFDock_SelectWindow(_G.GENERAL_CHAT_DOCK, _G.ChatFrame1)
    print("|cffbe1c1c[CalmChat] Chat setup successful.|r")
end
