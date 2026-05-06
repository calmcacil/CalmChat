local ADDON_NAME, Addon = ...

Addon.SCHEMA_VERSION = 3
Addon.PRESET_VERSION = 3
Addon.CHAT_FONT_SIZE_MIN = 8
Addon.CHAT_FONT_SIZE_MAX = 24

Addon.DEFAULTS = {
    version = Addon.SCHEMA_VERSION,
    initializedPresetVersion = 0,
    settings = {
        setupOnLogin = false,
        resetBeforeApply = true,
        chatFontSize = 14,
        keepRetailVoiceFrame = true,
        enableRetailServicesTab = false,
        enableClassicLFGTab = true,
        classicChannelNames = {
            lfg = "LookingForGroup",
            layer = "Layer",
        },
    },
    tabs = {
        general = {
            enabled = true,
            name = "General",
        },
        log = {
            enabled = true,
            name = "Log",
        },
        lootTrade = {
            enabled = true,
            name = "Loot/Trade",
            channels = {
                "Trade",
            },
            messageGroups = {
                "COMBAT_XP_GAIN",
                "COMBAT_HONOR_GAIN",
                "COMBAT_FACTION_CHANGE",
                "SKILL",
                "LOOT",
                "CURRENCY",
                "MONEY",
                "TRADESKILL",
            },
        },
        services = {
            enabled = false,
            name = "Services",
            channels = {
                "Services",
            },
            retailOnly = true,
        },
        lfg = {
            enabled = true,
            name = "LFG",
            channels = {
                "LookingForGroup",
                "Layer",
            },
            classicOnly = true,
            autoJoin = true,
        },
    },
}

Addon.CVARS = {
    { "chatStyle", "classic" },
    { "whisperMode", "inline" },
    { "colorChatNamesByClass", "1" },
    { "chatClassColorOverride", "0" },
    { "speechToText", "0" },
    { "textToSpeech", "0" },
}

Addon.GENERAL_REMOVALS = {
    "COMBAT_XP_GAIN",
    "COMBAT_HONOR_GAIN",
    "COMBAT_FACTION_CHANGE",
    "LOOT",
    "TRADESKILL",
}
