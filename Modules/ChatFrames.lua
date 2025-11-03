-- CalmChat ChatFrames Module
-- Author: Calmcacil
-- Chat frame creation and positioning functionality

local function SetupChatFrames()
    local SafeCall = CalmChat_Utils.SafeCall
    local CHAT_CONFIG = CalmChat_Config.CHAT_CONFIG
    local IsRetail = CalmChat_Utils.IsRetail
    local FrameExists = CalmChat_Utils.FrameExists

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

                -- Position frame
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
            local ADDON_NAME = CalmChat_Config.ADDON_NAME
            print("|cffbe1c1c[" .. ADDON_NAME .. "]|r Warning: Frame", frameName, "not found")
        end
    end

    return true
end

-- Export ChatFrames functionality
CalmChat_ChatFrames = {
    SetupChatFrames = SetupChatFrames
}