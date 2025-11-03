-- CalmChat CVars Module
-- Author: Calmcacil
-- CVar configuration management functionality

local function ConfigureCVars()
    local SafeCall = CalmChat_Utils.SafeCall
    local CHAT_CONFIG = CalmChat_Config.CHAT_CONFIG

    for cvar, value in pairs(CHAT_CONFIG.CVARS) do
        SafeCall(SetCVar, cvar, value)
    end
end

-- Export CVars functionality
CalmChat_CVars = {
    ConfigureCVars = ConfigureCVars
}