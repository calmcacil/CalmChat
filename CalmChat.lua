SLASH_SETUPCHAT1 = "/csetupchat"

function SlashCmdList.SETUPCHAT()
    local retail = (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE)

    -- Helper: Set CVars
    local function configureCVars()
        -- General
        SetCVar('chatStyle', 'classic')
        SetCVar('whisperMode', 'inline')
        SetCVar('colorChatNamesByClass', 1)
        SetCVar('chatClassColorOverride', 0)
        -- Voice Transcription
        SetCVar('speechToText', 0)
        SetCVar('textToSpeech', 0)
    end

    -- Helper: Setup Chat Frames
    local function setupChatFrames()
        FCF_ResetChatWindows()
        FCF_OpenNewWindow()
        FCF_OpenNewWindow()

        for _, name in ipairs(_G.CHAT_FRAMES) do
            local frame = _G[name]
            local id = frame:GetID()

            FCF_SetChatWindowFontSize(nil, frame, 14)

            if id == 1 then
                FCF_SetWindowName(frame, 'General')
                frame:ClearAllPoints()
                frame:Point('BOTTOMLEFT', _G.LeftChatToggleButton, 'TOPLEFT', 1, 3)
            elseif id == 2 then
                FCF_SetWindowName(frame, 'Log')
            elseif id == 3 then
                VoiceTranscriptionFrame_UpdateVisibility(frame)
                VoiceTranscriptionFrame_UpdateVoiceTab(frame)
                VoiceTranscriptionFrame_UpdateEditBox(frame)
            elseif id == 4 then
                FCF_SetWindowName(frame, 'Loot/Trade')
            elseif id == 5 then
                FCF_SetWindowName(frame, retail and 'Services' or 'LFG')
            end
        end
    end

    -- Helper: Configure Message Groups
    local function configureMessageGroups()
        local generalRemovals = {
            'COMBAT_XP_GAIN', 'COMBAT_HONOR_GAIN', 'COMBAT_FACTION_CHANGE', 'LOOT', 'TRADESKILL'
        }
        ChatFrame_RemoveChannel(_G.ChatFrame1, "Trade")
        ChatFrame_RemoveChannel(_G.ChatFrame1, "Services")
        for _, group in ipairs(generalRemovals) do
            ChatFrame_RemoveMessageGroup(_G.ChatFrame1, group)
        end

        local lootGroups = {
            'COMBAT_XP_GAIN', 'COMBAT_HONOR_GAIN', 'COMBAT_FACTION_CHANGE',
            'SKILL', 'LOOT', 'CURRENCY', 'MONEY', 'TRADESKILL'
        }
        ChatFrame_RemoveAllMessageGroups(_G.ChatFrame4)
        ChatFrame_AddChannel(_G.ChatFrame4, "Trade")
        for _, group in ipairs(lootGroups) do
            ChatFrame_AddMessageGroup(_G.ChatFrame4, group)
        end
    end

    -- Helper: Setup Channels
    local function setupChannels()
        if not retail and GetLocale() == 'enUS' then
            JoinPermanentChannel('LookingForGroup')
            JoinPermanentChannel('Layer')
            ChatFrame_AddChannel(_G.ChatFrame5, 'LookingForGroup')
        end

        if retail then
            ChatFrame_RemoveAllMessageGroups(_G.ChatFrame5)
            ChatFrame_AddChannel(_G.ChatFrame5, "Services")
            ChatFrame_AddMessageGroup(_G.ChatFrame1, 'PING')
        end
    end

    configureCVars()
    setupChatFrames()
    configureMessageGroups()
    setupChannels()

    FCFDock_SelectWindow(_G.GENERAL_CHAT_DOCK, _G.ChatFrame1)
    print('|cffbe1c1cChat setup successful.|r')
end
