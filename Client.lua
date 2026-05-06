local ADDON_NAME, Addon = ...

local function IsRetailClient()
    return WOW_PROJECT_MAINLINE ~= nil and WOW_PROJECT_ID == WOW_PROJECT_MAINLINE
end

function Addon.GetCapabilities()
    local settingsAvailable = type(Settings) == "table"
        and type(Settings.RegisterCanvasLayoutCategory) == "function"
        and type(Settings.RegisterAddOnCategory) == "function"
        and type(Settings.OpenToCategory) == "function"

    return {
        isRetail = IsRetailClient(),
        hasSettings = not not settingsAvailable,
        hasChatAPI = type(FCF_ResetChatWindows) == "function" and type(FCF_OpenNewWindow) == "function",
        hasCVarSupport = type(SetCVar) == "function",
        hasTimer = C_Timer and C_Timer.After,
    }
end
