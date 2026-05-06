local ADDON_NAME, Addon = ...

local Builder = {}
Addon.PresetBuilder = Builder

local function PushUniqueNonEmpty(target, seen, value)
    value = Addon.util.Trim(value)
    if value == "" or seen[value] then
        return
    end

    seen[value] = true
    target[#target + 1] = value
end

local function BuildClassicLFGChannels(settings, tabs)
    local channels = {}
    local seen = {}

    PushUniqueNonEmpty(channels, seen, settings.classicChannelNames.lfg)
    PushUniqueNonEmpty(channels, seen, settings.classicChannelNames.layer)

    for _, name in ipairs(tabs.lfg.channels or {}) do
        PushUniqueNonEmpty(channels, seen, name)
    end

    return channels
end

function Builder.Build()
    local db = Addon.DB.Get() or Addon.DB.Initialize()
    local settings = db.settings
    local tabs = db.tabs
    local capabilities = Addon.GetCapabilities()

    local plan = {
        capabilities = capabilities,
        settings = settings,
        tabs = tabs,
        secondary = {
            enabled = false,
            kind = nil,
            name = nil,
            channels = {},
            autoJoin = false,
        },
    }

    if capabilities.isRetail then
        if settings.enableRetailServicesTab then
            plan.secondary.enabled = true
            plan.secondary.kind = "services"
            plan.secondary.name = tabs.services.name
            plan.secondary.channels = tabs.services.channels
        end
    elseif settings.enableClassicLFGTab then
        plan.secondary.enabled = true
        plan.secondary.kind = "lfg"
        plan.secondary.name = tabs.lfg.name
        plan.secondary.channels = BuildClassicLFGChannels(settings, tabs)
        plan.secondary.autoJoin = tabs.lfg.autoJoin
    end

    return plan
end
