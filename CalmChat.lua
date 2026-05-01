local ADDON_NAME = "CalmChat"
local DEFAULT_SETTINGS = {
    enableServicesTab = false,
    enableVoiceFrame = true,
    autoJoinClassicLFG = true,
    setupOnLogin = false,
}

local settingsCategoryID
local warnedClassicLocale

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

local function EnsureSettings()
    CalmChatDB = CalmChatDB or {}
    for key, value in pairs(DEFAULT_SETTINGS) do
        if CalmChatDB[key] == nil then
            CalmChatDB[key] = value
        end
    end
    return CalmChatDB
end

local function RegisterBooleanSetting(category, key, label, tooltip)
    local variable = ADDON_NAME .. "_" .. key
    local setting = Settings.RegisterAddOnSetting(category, variable, key, CalmChatDB, Settings.VarType.Boolean, label, DEFAULT_SETTINGS[key])
    Settings.CreateCheckbox(category, setting, tooltip)
end

local function RegisterSettingsPanel()
    if settingsCategoryID then
        return
    end

    if not (Settings and Settings.RegisterVerticalLayoutCategory and Settings.RegisterAddOnCategory and Settings.RegisterAddOnSetting and Settings.CreateCheckbox and Settings.VarType) then
        return
    end

    EnsureSettings()
    local category, layout = Settings.RegisterVerticalLayoutCategory(ADDON_NAME)
    if layout and Settings.CreateElementInitializer and type(layout.AddInitializer) == "function" then
        local ok, initializer = pcall(Settings.CreateElementInitializer, "SettingsListSectionHeaderTemplate", {
            name = "Run /calmchat after changing options",
            tooltip = "CalmChat applies layout changes when /calmchat is run.",
        })
        if ok and initializer then
            pcall(layout.AddInitializer, layout, initializer)
        end
    end

    RegisterBooleanSetting(category, "enableServicesTab", "Create Services tab on Retail", "Creates a dedicated Services chat tab when running /calmchat on Retail clients.")
    RegisterBooleanSetting(category, "enableVoiceFrame", "Keep Retail voice transcription frame", "Preserves Blizzard's voice transcription frame when configuring Retail chat windows.")
    RegisterBooleanSetting(category, "autoJoinClassicLFG", "Auto-join Classic LFG channels", "On English Classic clients, joins LookingForGroup and Layer and routes them to the LFG tab.")
    RegisterBooleanSetting(category, "setupOnLogin", "Run setup after login or reload", "Automatically applies the selected chat preset shortly after PLAYER_LOGIN.")
    Settings.RegisterAddOnCategory(category)
    settingsCategoryID = type(category.GetID) == "function" and category:GetID() or category.ID
end

local function OpenSettingsPanel()
    if not settingsCategoryID then
        RegisterSettingsPanel()
    end

    if settingsCategoryID and Settings and Settings.OpenToCategory then
        Settings.OpenToCategory(settingsCategoryID)
        return true
    else
        print("|cffff2020[CalmChat] Settings are unavailable on this client.|r")
        return false
    end
end

-- Main slash command handler
SLASH_CALMCHAT1 = "/csetupchat"
SLASH_CALMCHAT2 = "/calmchat"

function SlashCmdList.CALMCHAT(msg)
    msg = msg and string.lower(string.match(msg, "^%s*(.-)%s*$")) or ""
    if msg == "config" or msg == "options" or msg == "settings" then
        OpenSettingsPanel()
    elseif msg == "help" then
        print("|cffbe1c1c[CalmChat]|r Usage: /calmchat to apply setup, /calmchat settings to open options.")
    else
        SetupChat()
    end
end

function CalmChat_OnAddonCompartmentClick()
    if not OpenSettingsPanel() then
        SetupChat()
    end
end

local function ApplyChatCVars()
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
end

local function CreateConfiguredFrames(config, retail)
    FCF_ResetChatWindows()

    local lootFrame = FCF_OpenNewWindow("Loot/Trade") or _G.ChatFrame4
    local servicesOrLFGFrame
    if config.enableServicesTab or not retail then
        servicesOrLFGFrame = FCF_OpenNewWindow(retail and "Services" or "LFG") or _G.ChatFrame5
    end

    return lootFrame, servicesOrLFGFrame
end

local function ConfigureFrameTitles(lootFrame, servicesOrLFGFrame, retail, config)
    for _, name in ipairs(_G.CHAT_FRAMES or {}) do
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
            elseif retail and id == 3 and config.enableVoiceFrame then
                CallGlobal("VoiceTranscriptionFrame_UpdateVisibility", frame)
                CallGlobal("VoiceTranscriptionFrame_UpdateVoiceTab", frame)
                CallGlobal("VoiceTranscriptionFrame_UpdateEditBox", frame)
            end
        end
    end
end

local function ConfigureGeneralFrame()
    local generalRemovals = {"COMBAT_XP_GAIN", "COMBAT_HONOR_GAIN", "COMBAT_FACTION_CHANGE", "LOOT", "TRADESKILL"}
    CallFrame(_G.ChatFrame1, "RemoveChannel", "Trade")
    CallFrame(_G.ChatFrame1, "RemoveChannel", "Services")
    for _, groupName in ipairs(generalRemovals) do
        CallFrame(_G.ChatFrame1, "RemoveMessageGroup", groupName)
    end
end

local function ConfigureLootFrame(lootFrame)
    if not lootFrame then
        return
    end

    CallFrame(lootFrame, "RemoveAllMessageGroups")
    CallFrame(lootFrame, "RemoveAllChannels")
    CallFrame(lootFrame, "AddMessageGroup", "CHANNEL")
    CallFrame(lootFrame, "AddChannel", "Trade")

    local lootGroups = {"COMBAT_XP_GAIN", "COMBAT_HONOR_GAIN", "COMBAT_FACTION_CHANGE", "SKILL", "LOOT", "CURRENCY", "MONEY", "TRADESKILL"}
    for _, groupName in ipairs(lootGroups) do
        CallFrame(lootFrame, "AddMessageGroup", groupName)
    end
end

local function ConfigureClassicLFGChannels(frame)
    if GetLocale() ~= "enUS" then
        if not warnedClassicLocale then
            warnedClassicLocale = true
            print("|cffffff00[CalmChat] Classic LFG auto-join currently supports enUS channel names only.|r")
        end
        return
    end

    local _, lfgChannel = CallGlobal("JoinPermanentChannel", "LookingForGroup", nil, frame:GetID(), 1)
    local _, layerChannel = CallGlobal("JoinPermanentChannel", "Layer", nil, frame:GetID(), 1)
    CallFrame(frame, "AddMessageGroup", "CHANNEL")
    CallFrame(frame, "AddChannel", lfgChannel or "LookingForGroup")
    CallFrame(frame, "AddChannel", layerChannel or "Layer")
end

local function ConfigureServicesOrLFGFrame(frame, retail, config)
    if not frame then
        return
    end

    CallFrame(frame, "RemoveAllMessageGroups")
    CallFrame(frame, "RemoveAllChannels")

    if retail then
        CallFrame(frame, "AddMessageGroup", "CHANNEL")
        CallFrame(frame, "AddChannel", "Services")
    elseif config.autoJoinClassicLFG then
        ConfigureClassicLFGChannels(frame)
    end

    if retail then
        CallFrame(_G.ChatFrame1, "AddMessageGroup", "PING")
    end
end

local function SelectGeneralWindow()
    if type(FCFDock_SelectWindow) == "function" and _G.GENERAL_CHAT_DOCK and _G.ChatFrame1 then
        FCFDock_SelectWindow(_G.GENERAL_CHAT_DOCK, _G.ChatFrame1)
    end
end

function SetupChat()
    local config = EnsureSettings()
    local retail = IsRetailClient()

    if type(FCF_ResetChatWindows) ~= "function" or type(FCF_OpenNewWindow) ~= "function" then
        print("|cffff2020[CalmChat] Blizzard chat window APIs are unavailable.|r")
        return
    end

    ApplyChatCVars()
    local lootFrame, servicesOrLFGFrame = CreateConfiguredFrames(config, retail)
    ConfigureFrameTitles(lootFrame, servicesOrLFGFrame, retail, config)
    ConfigureGeneralFrame()
    ConfigureLootFrame(lootFrame)
    ConfigureServicesOrLFGFrame(servicesOrLFGFrame, retail, config)
    SelectGeneralWindow()
    print("|cffbe1c1c[CalmChat] Chat setup successful.|r")
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:SetScript("OnEvent", function(_, event, addonName)
    if event == "ADDON_LOADED" and addonName == ADDON_NAME then
        EnsureSettings()
        RegisterSettingsPanel()
    elseif event == "PLAYER_LOGIN" then
        local config = EnsureSettings()
        if config.setupOnLogin then
            if C_Timer and C_Timer.After then
                C_Timer.After(1, SetupChat)
            else
                SetupChat()
            end
        end
    end
end)
