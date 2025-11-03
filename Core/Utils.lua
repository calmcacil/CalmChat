-- CalmChat Utilities Module
-- Author: Calmcacil
-- Shared utility functions and helpers

-- Utility Functions
local function SafeCall(func, ...)
    local success, err = pcall(func, ...)
    if not success then
        local ADDON_NAME = CalmChat_Config and CalmChat_Config.ADDON_NAME or "CalmChat"
        print("|cffbe1c1c[" .. ADDON_NAME .. "]|r Error:", err)
        return false
    end
    return true
end

local function IsRetail()
    return WOW_PROJECT_ID == WOW_PROJECT_MAINLINE
end

local function FrameExists(frameName)
    return _G[frameName] ~= nil
end

local function GetChatFrameByName(name)
    if not _G.CHAT_FRAMES then return nil end

    for _, frameName in ipairs(_G.CHAT_FRAMES) do
        local frame = _G[frameName]
        if frame and frame.name == name then
            return frame
        end
    end
    return nil
end

local function IsChatAlreadyConfigured()
    -- Check if the expected custom chat frames exist
    local expectedFrames = {
        "Loot/Trade",
        IsRetail() and "Services" or "LFG"
    }

    for _, expectedName in ipairs(expectedFrames) do
        if not GetChatFrameByName(expectedName) then
            return false
        end
    end

    -- Check if we have at least 5 chat frames
    local frameCount = 0
    if _G.CHAT_FRAMES then
        for _, frameName in ipairs(_G.CHAT_FRAMES) do
            if _G[frameName] then
                frameCount = frameCount + 1
            end
        end
    end

    if frameCount < 5 then
        return false
    end

    return true
end

-- Export utilities
CalmChat_Utils = {
    SafeCall = SafeCall,
    IsRetail = IsRetail,
    FrameExists = FrameExists,
    GetChatFrameByName = GetChatFrameByName,
    IsChatAlreadyConfigured = IsChatAlreadyConfigured
}