-- Services and Voice frame configuration
local ENABLE_SERVICES_TAB = false
local ENABLE_VOICE_FRAME = true

local function IsRetailClient()
    return WOW_PROJECT_MAINLINE ~= nil and WOW_PROJECT_ID == WOW_PROJECT_MAINLINE
end

local function CallGlobal(name, ...)
    local func = _G[name]
    if type(func) == "function" then
        return func(...)
    end
end

local function CallFrame(frame, method, ...)
    local func = frame and frame[method]
    if type(func) == "function" then
        return func(frame, ...)
    end
end

local function SetCVarIfAvailable(name, value)
    if type(SetCVar) == "function" then
        pcall(SetCVar, name, value)
    end
end

-- Main slash command handler
SLASH_CALMCHAT1 = "/csetupchat"
SLASH_CALMCHAT2 = "/calmchat"

function SlashCmdList.CALMCHAT()
    SetupChat()
end

function CalmChat_OnAddonCompartmentClick()
    SetupChat()
end

function SetupChat()
    local retail = IsRetailClient()

    if type(FCF_ResetChatWindows) ~= "function" or type(FCF_OpenNewWindow) ~= "function" then
        print("|cffff2020[CalmChat] Blizzard chat window APIs are unavailable.|r")
        return
    end

    -- CVars
    local cvars = {
        {"chatStyle", "classic"},
        {"whisperMode", "inline"},
        {"colorChatNamesByClass", "1"},
        {"chatClassColorOverride", "0"},
        {"speechToText", "0"},
        {"textToSpeech", "0"},
    }

    for _, cvar in ipairs(cvars) do
        SetCVarIfAvailable(cvar[1], cvar[2])
    end

    -- Reset and create dedicated windows. Use returned frames so Classic clients
    -- without Retail's voice tab still get the intended Loot/LFG layout.
    FCF_ResetChatWindows()

    local lootFrame = FCF_OpenNewWindow("Loot/Trade") or _G.ChatFrame4
    local servicesOrLFGFrame
    if ENABLE_SERVICES_TAB or not retail then
        servicesOrLFGFrame = FCF_OpenNewWindow(retail and "Services" or "LFG") or _G.ChatFrame5
    end

    -- Configure all chat frames
    for _, name in ipairs(_G.CHAT_FRAMES) do
        local frame = _G[name]
        if frame then
            local id = frame:GetID()

            CallGlobal("FCF_SetChatWindowFontSize", nil, frame, 14)

            if frame == lootFrame then
                CallGlobal("FCF_SetWindowName", frame, "Loot/Trade")
            elseif frame == servicesOrLFGFrame then
                CallGlobal("FCF_SetWindowName", frame, retail and "Services" or "LFG")
            elseif id == 1 then
                CallGlobal("FCF_SetWindowName", frame, "General")
                frame:ClearAllPoints()
                if _G.LeftChatToggleButton then
                    frame:SetPoint("BOTTOMLEFT", _G.LeftChatToggleButton, "TOPLEFT", 1, 3)
                end
            elseif id == 2 then
                CallGlobal("FCF_SetWindowName", frame, "Log")
            elseif retail and id == 3 then
                if ENABLE_VOICE_FRAME then
                    CallGlobal("VoiceTranscriptionFrame_UpdateVisibility", frame)
                    CallGlobal("VoiceTranscriptionFrame_UpdateVoiceTab", frame)
                    CallGlobal("VoiceTranscriptionFrame_UpdateEditBox", frame)
                end
            end
        end
    end

    -- Configure ChatFrame1 (General)
    local generalRemovals = {"COMBAT_XP_GAIN", "COMBAT_HONOR_GAIN", "COMBAT_FACTION_CHANGE", "LOOT", "TRADESKILL"}
    CallFrame(_G.ChatFrame1, "RemoveChannel", "Trade")
    CallFrame(_G.ChatFrame1, "RemoveChannel", "Services")
    for _, v in ipairs(generalRemovals) do
        CallFrame(_G.ChatFrame1, "RemoveMessageGroup", v)
    end

    -- Configure Loot/Trade
    if lootFrame then
        CallFrame(lootFrame, "RemoveAllMessageGroups")
        CallFrame(lootFrame, "RemoveAllChannels")
        CallFrame(lootFrame, "AddMessageGroup", "CHANNEL")
        CallFrame(lootFrame, "AddChannel", "Trade")
        local lootGroups = {"COMBAT_XP_GAIN", "COMBAT_HONOR_GAIN", "COMBAT_FACTION_CHANGE", "SKILL", "LOOT", "CURRENCY", "MONEY", "TRADESKILL"}
        for _, k in ipairs(lootGroups) do
            CallFrame(lootFrame, "AddMessageGroup", k)
        end
    end

    -- Configure Services or LFG
    if servicesOrLFGFrame then
        CallFrame(servicesOrLFGFrame, "RemoveAllMessageGroups")
        CallFrame(servicesOrLFGFrame, "RemoveAllChannels")

        if retail then
            CallFrame(servicesOrLFGFrame, "AddMessageGroup", "CHANNEL")
            CallFrame(servicesOrLFGFrame, "AddChannel", "Services")
        elseif not retail and GetLocale() == "enUS" then
            local _, lfgChannel = CallGlobal("JoinPermanentChannel", "LookingForGroup", nil, servicesOrLFGFrame:GetID(), 1)
            local _, layerChannel = CallGlobal("JoinPermanentChannel", "Layer", nil, servicesOrLFGFrame:GetID(), 1)
            CallFrame(servicesOrLFGFrame, "AddMessageGroup", "CHANNEL")
            CallFrame(servicesOrLFGFrame, "AddChannel", lfgChannel or "LookingForGroup")
            CallFrame(servicesOrLFGFrame, "AddChannel", layerChannel or "Layer")
        end

        if retail then
            CallFrame(_G.ChatFrame1, "AddMessageGroup", "PING")
        end
    end

    -- Select General tab and finish
    if type(FCFDock_SelectWindow) == "function" and _G.GENERAL_CHAT_DOCK and _G.ChatFrame1 then
        FCFDock_SelectWindow(_G.GENERAL_CHAT_DOCK, _G.ChatFrame1)
    end
    print("|cffbe1c1c[CalmChat] Chat setup successful.|r")
end
