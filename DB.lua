local ADDON_NAME, Addon = ...

local DB = {}
Addon.DB = DB

local function NormalizeText(value, fallback)
    value = Addon.util.Trim(value)
    if value == "" then
        return fallback
    end

    return value
end

local function NormalizeFontSize(value, fallback)
    local numberValue = tonumber(value)
    if not numberValue then
        numberValue = tonumber(fallback) or Addon.CHAT_FONT_SIZE_MIN
    end

    numberValue = math.floor(numberValue + 0.5)
    if numberValue < Addon.CHAT_FONT_SIZE_MIN then
        return Addon.CHAT_FONT_SIZE_MIN
    end

    if numberValue > Addon.CHAT_FONT_SIZE_MAX then
        return Addon.CHAT_FONT_SIZE_MAX
    end

    return numberValue
end

local function MigrateLegacyFields(db)
    Addon.util.DeepMergeDefaults(db, Addon.DEFAULTS)

    local settings = db.settings
    local tabs = db.tabs

    if db.enableServicesTab ~= nil then
        settings.enableRetailServicesTab = Addon.util.ToBoolean(db.enableServicesTab, settings.enableRetailServicesTab)
    end

    if db.enableVoiceFrame ~= nil then
        settings.keepRetailVoiceFrame = Addon.util.ToBoolean(db.enableVoiceFrame, settings.keepRetailVoiceFrame)
    end

    if db.autoJoinClassicLFG ~= nil then
        local enabled = Addon.util.ToBoolean(db.autoJoinClassicLFG, settings.enableClassicLFGTab)
        settings.enableClassicLFGTab = enabled
        tabs.lfg.autoJoin = enabled
    end

    if db.setupOnLogin ~= nil then
        settings.setupOnLogin = Addon.util.ToBoolean(db.setupOnLogin, settings.setupOnLogin)
    end

    db.enableServicesTab = nil
    db.enableVoiceFrame = nil
    db.autoJoinClassicLFG = nil
    db.setupOnLogin = nil
end

local function NormalizeSchema(db)
    Addon.util.DeepMergeDefaults(db, Addon.DEFAULTS)

    db.version = Addon.SCHEMA_VERSION
    db.initializedPresetVersion = tonumber(db.initializedPresetVersion) or 0

    local settings = db.settings
    local tabs = db.tabs

    settings.setupOnLogin = Addon.util.ToBoolean(settings.setupOnLogin, Addon.DEFAULTS.settings.setupOnLogin)
    settings.resetBeforeApply = Addon.util.ToBoolean(settings.resetBeforeApply, Addon.DEFAULTS.settings.resetBeforeApply)
    settings.chatFontSize = NormalizeFontSize(settings.chatFontSize, Addon.DEFAULTS.settings.chatFontSize)
    settings.keepRetailVoiceFrame = Addon.util.ToBoolean(settings.keepRetailVoiceFrame, Addon.DEFAULTS.settings.keepRetailVoiceFrame)
    settings.enableRetailServicesTab = Addon.util.ToBoolean(settings.enableRetailServicesTab, Addon.DEFAULTS.settings.enableRetailServicesTab)
    settings.enableClassicLFGTab = Addon.util.ToBoolean(settings.enableClassicLFGTab, Addon.DEFAULTS.settings.enableClassicLFGTab)

    settings.classicChannelNames.lfg = NormalizeText(settings.classicChannelNames.lfg, Addon.DEFAULTS.settings.classicChannelNames.lfg)
    settings.classicChannelNames.layer = NormalizeText(settings.classicChannelNames.layer, Addon.DEFAULTS.settings.classicChannelNames.layer)

    tabs.general.name = NormalizeText(tabs.general.name, Addon.DEFAULTS.tabs.general.name)
    tabs.log.name = NormalizeText(tabs.log.name, Addon.DEFAULTS.tabs.log.name)
    tabs.lootTrade.name = NormalizeText(tabs.lootTrade.name, Addon.DEFAULTS.tabs.lootTrade.name)
    tabs.services.name = NormalizeText(tabs.services.name, Addon.DEFAULTS.tabs.services.name)
    tabs.lfg.name = NormalizeText(tabs.lfg.name, Addon.DEFAULTS.tabs.lfg.name)

    tabs.general.enabled = Addon.util.ToBoolean(tabs.general.enabled, Addon.DEFAULTS.tabs.general.enabled)
    tabs.log.enabled = Addon.util.ToBoolean(tabs.log.enabled, Addon.DEFAULTS.tabs.log.enabled)
    tabs.lootTrade.enabled = Addon.util.ToBoolean(tabs.lootTrade.enabled, Addon.DEFAULTS.tabs.lootTrade.enabled)
    tabs.services.enabled = Addon.util.ToBoolean(tabs.services.enabled, Addon.DEFAULTS.tabs.services.enabled)
    tabs.lfg.enabled = Addon.util.ToBoolean(tabs.lfg.enabled, Addon.DEFAULTS.tabs.lfg.enabled)

    tabs.lfg.autoJoin = Addon.util.ToBoolean(tabs.lfg.autoJoin, Addon.DEFAULTS.tabs.lfg.autoJoin)

    tabs.lootTrade.channels = type(tabs.lootTrade.channels) == "table" and tabs.lootTrade.channels or Addon.util.DeepCopy(Addon.DEFAULTS.tabs.lootTrade.channels)
    tabs.lootTrade.messageGroups = type(tabs.lootTrade.messageGroups) == "table" and tabs.lootTrade.messageGroups or Addon.util.DeepCopy(Addon.DEFAULTS.tabs.lootTrade.messageGroups)
    tabs.services.channels = type(tabs.services.channels) == "table" and tabs.services.channels or Addon.util.DeepCopy(Addon.DEFAULTS.tabs.services.channels)
    tabs.lfg.channels = type(tabs.lfg.channels) == "table" and tabs.lfg.channels or Addon.util.DeepCopy(Addon.DEFAULTS.tabs.lfg.channels)
end

function DB.Migrate(fromVersion)
    local db = CalmChatDB
    if type(db) ~= "table" then
        return
    end

    if type(fromVersion) ~= "number" then
        fromVersion = 0
    end

    if fromVersion < 3 then
        MigrateLegacyFields(db)
    end

    NormalizeSchema(db)
end

function DB.Initialize()
    CalmChatDB = type(CalmChatDB) == "table" and CalmChatDB or {}

    local fromVersion = tonumber(CalmChatDB.version) or 0
    DB.Migrate(fromVersion)

    return CalmChatDB
end

function DB.Get()
    return CalmChatDB
end

function DB.GetSettings()
    return CalmChatDB and CalmChatDB.settings
end

function DB.GetTabs()
    return CalmChatDB and CalmChatDB.tabs
end

function DB.ResetToDefaults()
    CalmChatDB = Addon.util.DeepCopy(Addon.DEFAULTS)
    CalmChatDB.version = Addon.SCHEMA_VERSION
    CalmChatDB.initializedPresetVersion = 0
    return CalmChatDB
end

function DB.GetDefaults()
    return Addon.DEFAULTS
end

function DB.NormalizeText(value, fallback)
    return NormalizeText(value, fallback)
end

function DB.GetInitializedPresetVersion()
    return (CalmChatDB and tonumber(CalmChatDB.initializedPresetVersion)) or 0
end

function DB.SetInitializedPresetVersion(version)
    if type(CalmChatDB) ~= "table" then
        return
    end

    CalmChatDB.initializedPresetVersion = tonumber(version) or 0
end
