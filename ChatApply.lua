local ADDON_NAME, Addon = ...

local Apply = {}
Addon.ChatApply = Apply

local warnedClassicLocale

local function ConfigureGeneralFrame()
    local chatFrame1 = _G.ChatFrame1
    Addon.util.CallFrame(chatFrame1, "RemoveChannel", "Trade")
    Addon.util.CallFrame(chatFrame1, "RemoveChannel", "Services")

    for _, groupName in ipairs(Addon.GENERAL_REMOVALS) do
        Addon.util.CallFrame(chatFrame1, "RemoveMessageGroup", groupName)
    end
end

local function ConfigureLootFrame(frame, tabs)
    if not frame then
        return
    end

    local lootTab = tabs.lootTrade
    Addon.util.CallFrame(frame, "RemoveAllMessageGroups")
    Addon.util.CallFrame(frame, "RemoveAllChannels")

    Addon.util.CallFrame(frame, "AddMessageGroup", "CHANNEL")
    for _, channelName in ipairs(lootTab.channels or {}) do
        Addon.util.CallFrame(frame, "AddChannel", channelName)
    end

    for _, groupName in ipairs(lootTab.messageGroups or {}) do
        Addon.util.CallFrame(frame, "AddMessageGroup", groupName)
    end
end

local function ConfigureClassicLFGChannels(frame, channels)
    if not frame then
        return
    end

    if GetLocale() ~= "enUS" then
        if not warnedClassicLocale then
            warnedClassicLocale = true
            print("|cffffff00[CalmChat] Classic LFG auto-join currently supports enUS channel names only.|r")
        end

        Addon.util.CallFrame(frame, "AddMessageGroup", "CHANNEL")
        for _, channelName in ipairs(channels) do
            Addon.util.CallFrame(frame, "AddChannel", channelName)
        end
        return
    end

    Addon.util.CallFrame(frame, "AddMessageGroup", "CHANNEL")
    for _, channelName in ipairs(channels) do
        local _, joinedName = Addon.util.CallGlobal("JoinPermanentChannel", channelName, nil, frame:GetID(), 1)
        Addon.util.CallFrame(frame, "AddChannel", joinedName or channelName)
    end
end

local function ConfigureSecondaryFrame(frame, plan)
    if not frame or not plan.secondary.enabled then
        return
    end

    Addon.util.CallFrame(frame, "RemoveAllMessageGroups")
    Addon.util.CallFrame(frame, "RemoveAllChannels")

    if plan.secondary.kind == "services" then
        Addon.util.CallFrame(frame, "AddMessageGroup", "CHANNEL")
        for _, channelName in ipairs(plan.secondary.channels or {}) do
            Addon.util.CallFrame(frame, "AddChannel", channelName)
        end
    elseif plan.secondary.kind == "lfg" then
        if plan.secondary.autoJoin then
            ConfigureClassicLFGChannels(frame, plan.secondary.channels or {})
        else
            Addon.util.CallFrame(frame, "AddMessageGroup", "CHANNEL")
            for _, channelName in ipairs(plan.secondary.channels or {}) do
                Addon.util.CallFrame(frame, "AddChannel", channelName)
            end
        end
    end

    if plan.capabilities.isRetail then
        Addon.util.CallFrame(_G.ChatFrame1, "AddMessageGroup", "PING")
    end
end

local function ConfigureFrameTitles(lootFrame, secondaryFrame, plan)
    local tabs = plan.tabs
    local chatFontSize = tonumber(plan.settings.chatFontSize) or Addon.DEFAULTS.settings.chatFontSize

    if chatFontSize < Addon.CHAT_FONT_SIZE_MIN then
        chatFontSize = Addon.CHAT_FONT_SIZE_MIN
    elseif chatFontSize > Addon.CHAT_FONT_SIZE_MAX then
        chatFontSize = Addon.CHAT_FONT_SIZE_MAX
    end

    for _, name in ipairs(_G.CHAT_FRAMES or {}) do
        local frame = _G[name]
        if frame then
            local id = frame:GetID()

            Addon.util.CallGlobal("FCF_SetChatWindowFontSize", nil, frame, chatFontSize)

            if frame == lootFrame then
                Addon.util.CallGlobal("FCF_SetWindowName", frame, tabs.lootTrade.name)
            elseif frame == secondaryFrame and plan.secondary.enabled then
                Addon.util.CallGlobal("FCF_SetWindowName", frame, plan.secondary.name)
            elseif id == 1 then
                Addon.util.CallGlobal("FCF_SetWindowName", frame, tabs.general.name)
                if _G.LeftChatToggleButton then
                    frame:ClearAllPoints()
                    frame:SetPoint("BOTTOMLEFT", _G.LeftChatToggleButton, "TOPLEFT", 1, 3)
                end
            elseif id == 2 then
                Addon.util.CallGlobal("FCF_SetWindowName", frame, tabs.log.name)
            elseif plan.capabilities.isRetail and id == 3 and plan.settings.keepRetailVoiceFrame then
                Addon.util.CallGlobal("VoiceTranscriptionFrame_UpdateVisibility", frame)
                Addon.util.CallGlobal("VoiceTranscriptionFrame_UpdateVoiceTab", frame)
                Addon.util.CallGlobal("VoiceTranscriptionFrame_UpdateEditBox", frame)
            end
        end
    end
end

local function SelectGeneralWindow()
    if type(FCFDock_SelectWindow) == "function" and _G.GENERAL_CHAT_DOCK and _G.ChatFrame1 then
        FCFDock_SelectWindow(_G.GENERAL_CHAT_DOCK, _G.ChatFrame1)
    end
end

local function ApplyCVars()
    for _, cvar in ipairs(Addon.CVARS) do
        Addon.util.SetCVarIfAvailable(cvar[1], cvar[2])
    end
end

local function CreateFrames(plan)
    local tabs = plan.tabs

    if plan.settings.resetBeforeApply then
        FCF_ResetChatWindows()
    end

    local lootFrame
    if tabs.lootTrade.enabled then
        lootFrame = FCF_OpenNewWindow(tabs.lootTrade.name) or _G.ChatFrame4
    end

    local secondaryFrame
    if plan.secondary.enabled then
        secondaryFrame = FCF_OpenNewWindow(plan.secondary.name) or _G.ChatFrame5
    end

    return lootFrame, secondaryFrame
end

function Apply.Execute(plan)
    if type(plan) ~= "table" then
        return false, "Invalid apply plan"
    end

    if not plan.capabilities.hasChatAPI then
        return false, "Blizzard chat window APIs are unavailable."
    end

    ApplyCVars()

    local lootFrame, secondaryFrame = CreateFrames(plan)
    ConfigureFrameTitles(lootFrame, secondaryFrame, plan)
    ConfigureGeneralFrame()
    ConfigureLootFrame(lootFrame, plan.tabs)
    ConfigureSecondaryFrame(secondaryFrame, plan)
    SelectGeneralWindow()

    return true
end
