-- CalmChat Channels Module
-- Author: Calmcacil
-- Channel setup and joining functionality

local function SetupChannels()
    local SafeCall = CalmChat_Utils.SafeCall
    local IsRetail = CalmChat_Utils.IsRetail
    local ADDON_NAME = CalmChat_Config.ADDON_NAME

    local cf5 = _G.ChatFrame5

    if not cf5 then
        print("|cffbe1c1c[" .. ADDON_NAME .. "]|r Warning: ChatFrame5 not found")
        return false
    end

    if not IsRetail() then
        -- Classic Era/Season of Discovery channels
        local locale = GetLocale()
        if locale == "enUS" or locale == "enGB" then
            SafeCall(JoinPermanentChannel, "LookingForGroup")
            SafeCall(JoinPermanentChannel, "Layer")
            SafeCall(AddChatWindowChannel, cf5:GetID(), "LookingForGroup")
        end
    else
        -- Retail specific setup
        SafeCall(ChatFrame_RemoveAllMessageGroups, cf5)
        SafeCall(AddChatWindowChannel, cf5:GetID(), "Services")

        -- Add ping notifications to General chat
        if _G.ChatFrame1 then
            SafeCall(ChatFrame_AddMessageGroup, _G.ChatFrame1, "PING")
        end
    end

    return true
end

-- Export Channels functionality
CalmChat_Channels = {
    SetupChannels = SetupChannels
}