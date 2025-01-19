SLASH_SETUPCHAT1 = "/csetupchat"

function SlashCmdList.SETUPCHAT()

    local retail = (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE)

    -- CVars General
    SetCVar('chatStyle', 'classic')
    SetCVar('whisperMode', 'inline')
    SetCVar('colorChatNamesByClass', 1)
    SetCVar('chatClassColorOverride', 0)

    -- CVars Voice Transcription
    SetCVar('speechToText', 0)
    SetCVar('textToSpeech', 0)

    -- Reset chat to Blizzard defaults
    FCF_ResetChatWindows()

    -- Create new tabs
    FCF_OpenNewWindow()
    FCF_OpenNewWindow()
    

    -- Rename and color all tabs
    for _, name in ipairs(_G.CHAT_FRAMES) do
        local frame = _G[name]
        local id = frame:GetID()

        -- Font size 14 for all tabs
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
        elseif id == 5 and retail then
            FCF_SetWindowName(frame, 'Services')
        elseif id == 5 and not retail then
            FCF_SetWindowName(frame, 'LFG')
        end
    end

    -- Remove from main tab
    chatGeneralTab = {'COMBAT_XP_GAIN', 'COMBAT_HONOR_GAIN', 'COMBAT_FACTION_CHANGE', 'LOOT', 'CURRENCY', 'MONEY', 'TRADESKILL'}
    ChatFrame_RemoveAllMessageGroups(_G.ChatFrame1)
    ChatFrame_RemoveChannel(_G.ChatFrame1, "Trade")
    ChatFrame_RemoveChannel(_G.ChatFrame1, "Services")
    for _, k in ipairs(chatGeneralTab) do
        ChatFrame_RemoveMessageGroup(_G.ChatFrame1, v)
    end

    -- Setup Loot tab
    chatLootTab = {'COMBAT_XP_GAIN', 'COMBAT_HONOR_GAIN', 'COMBAT_FACTION_CHANGE', 'SKILL', 'LOOT', 'CURRENCY', 'MONEY', 'TRADESKILL'}
    ChatFrame_RemoveAllMessageGroups(_G.ChatFrame4)
    ChatFrame_AddChannel(_G.ChatFrame4, "Trade")
    for _, k in ipairs(chatLootTab) do
        ChatFrame_AddMessageGroup(_G.ChatFrame4, k)
    end

    -- Join LFG channel in Classic and TBC (English client only)
    if not retail and GetLocale() == 'enUS' then
        JoinPermanentChannel('LookingForGroup')
        JoinPermanentChannel('Layer')
        ChatFrame_AddChannel(_G.ChatFrame5, 'LookingForGroup')
        
    end
    if retail then
        -- Setup Services tab
        chats = {}
        ChatFrame_RemoveAllMessageGroups(_G.ChatFrame5)
        ChatFrame_AddChannel(_G.ChatFrame5, "Services")
        for _, k in ipairs(chats) do
            ChatFrame_AddMessageGroup(_G.ChatFrame5, k)
        end
        ChatFrame_AddMessageGroup(_G.ChatFrame1, 'PING')
    end

    -- Jump back to main tab
    FCFDock_SelectWindow(_G.GENERAL_CHAT_DOCK, _G.ChatFrame1)

    print('|cffbe1c1cChat setup successful.|r')
end
