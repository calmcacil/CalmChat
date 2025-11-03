-- CalmChat MessageGroups Module
-- Author: Calmcacil
-- Message filtering and group configuration functionality

local function ConfigureMessageGroups()
    local SafeCall = CalmChat_Utils.SafeCall
    local CHAT_CONFIG = CalmChat_Config.CHAT_CONFIG
    local ADDON_NAME = CalmChat_Config.ADDON_NAME

    local cf1 = _G.ChatFrame1
    local cf4 = _G.ChatFrame4

    if not cf1 or not cf4 then
        print("|cffbe1c1c[" .. ADDON_NAME .. "]|r Error: Required chat frames not found")
        return false
    end

    -- Remove unwanted messages from General chat
    SafeCall(RemoveChatWindowChannel, cf1:GetID(), "Trade")
    SafeCall(RemoveChatWindowChannel, cf1:GetID(), "Services")

    for _, group in ipairs(CHAT_CONFIG.GENERAL_REMOVALS) do
        SafeCall(ChatFrame_RemoveMessageGroup, cf1, group)
    end

    -- Configure Loot/Trade frame
    SafeCall(ChatFrame_RemoveAllMessageGroups, cf4)
    SafeCall(AddChatWindowChannel, cf4:GetID(), "Trade")

    for _, group in ipairs(CHAT_CONFIG.LOOT_GROUPS) do
        SafeCall(ChatFrame_AddMessageGroup, cf4, group)
    end

    return true
end

-- Export MessageGroups functionality
CalmChat_MessageGroups = {
    ConfigureMessageGroups = ConfigureMessageGroups
}