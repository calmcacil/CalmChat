-- CalmChat Configuration Module
-- Author: Calmcacil
-- Central configuration constants for the addon

local ADDON_NAME = "CalmChat"

-- Settings
local AUTO_SETUP_ENABLED = true -- Set to false to disable automatic setup

-- Constants
local CHAT_CONFIG = {
    FONT_SIZE = 14,
    FRAME_OFFSET_X = 1,
    FRAME_OFFSET_Y = 3,

    -- Frame Names
    FRAME_NAMES = {
        [1] = "General",
        [2] = "Log",
        [3] = nil, -- Voice/Transcription (special handling)
        [4] = "Loot/Trade",
        [5] = nil, -- Dynamic (Services/LFG based on version)
    },

    -- CVars to configure
    CVARS = {
        chatStyle = "classic",
        whisperMode = "inline",
        colorChatNamesByClass = "1",
        chatClassColorOverride = "0",
        speechToText = "0",
        textToSpeech = "0",
    },

    -- Message groups to remove from General
    GENERAL_REMOVALS = {
        "COMBAT_XP_GAIN",
        "COMBAT_HONOR_GAIN",
        "COMBAT_FACTION_CHANGE",
        "LOOT",
        "TRADESKILL"
    },

    -- Message groups to add to Loot/Trade frame
    LOOT_GROUPS = {
        "COMBAT_XP_GAIN",
        "COMBAT_HONOR_GAIN",
        "COMBAT_FACTION_CHANGE",
        "SKILL",
        "LOOT",
        "CURRENCY",
        "MONEY",
        "TRADESKILL"
    },
}

-- Export configuration
CalmChat_Config = {
    ADDON_NAME = ADDON_NAME,
    AUTO_SETUP_ENABLED = AUTO_SETUP_ENABLED,
    CHAT_CONFIG = CHAT_CONFIG
}