local ADDON_NAME, Addon = ...

local RED = "|cffff2020"
local GOLD = "|cffffff00"
local BRAND = "|cffbe1c1c"

function Addon.Print(message)
    print(BRAND .. "[CalmChat] " .. tostring(message) .. "|r")
end

function Addon.PrintError(message)
    print(RED .. "[CalmChat] " .. tostring(message) .. "|r")
end

function Addon.PrintWarning(message)
    print(GOLD .. "[CalmChat] " .. tostring(message) .. "|r")
end

function Addon.GetConfig()
    return Addon.DB.Get() or Addon.DB.Initialize()
end

local function ResolveSuccessMessage(options)
    local defaultMessage = "Chat setup successful."
    if type(options) ~= "table" then
        return defaultMessage
    end

    if options.successMessage == false then
        return nil
    end

    if options.successMessage == nil then
        return defaultMessage
    end

    return tostring(options.successMessage)
end

local function SetupChatInternal(options)
    local plan = Addon.PresetBuilder.Build()
    local ok, err = Addon.ChatApply.Execute(plan)
    if ok then
        Addon.DB.SetInitializedPresetVersion(Addon.PRESET_VERSION)
        local successMessage = ResolveSuccessMessage(options)
        if successMessage and successMessage ~= "" then
            Addon.Print(successMessage)
        end

        return true
    end

    Addon.PrintError(err or "Chat setup failed.")
    return false
end

function Addon.SetupChat()
    return SetupChatInternal(nil)
end

function Addon.SetupChatWithOptions(options)
    return SetupChatInternal(options)
end

function Addon.ApplyDefaults()
    Addon.DB.ResetToDefaults()
end

function Addon.ShouldAutoInitializePreset()
    return Addon.DB.GetInitializedPresetVersion() < Addon.PRESET_VERSION
end

function Addon.InitializePresetIfNeeded(options)
    if not Addon.ShouldAutoInitializePreset() then
        return true, false
    end

    local ok = Addon.SetupChatWithOptions(options)
    return ok, ok
end

function Addon.OpenSettings()
    return Addon.SettingsUI.Open()
end
