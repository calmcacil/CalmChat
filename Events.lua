local ADDON_NAME, Addon = ...

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")

eventFrame:SetScript("OnEvent", function(self, event, addonName)
    if event == "ADDON_LOADED" then
        if addonName ~= ADDON_NAME then
            return
        end

        Addon.DB.Initialize()
        Addon.SettingsUI.Register()
        self:UnregisterEvent("ADDON_LOADED")
        return
    end

    if event == "PLAYER_LOGIN" then
        local settings = Addon.DB.GetSettings() or Addon.DB.Initialize().settings
        if settings.setupOnLogin then
            local capabilities = Addon.GetCapabilities()
            if capabilities.hasTimer then
                C_Timer.After(1, function()
                    local _, applied = Addon.InitializePresetIfNeeded({ successMessage = false })
                    if applied then
                        Addon.Print("Applied chat setup for this character on login.")
                    end
                end)
            else
                local _, applied = Addon.InitializePresetIfNeeded({ successMessage = false })
                if applied then
                    Addon.Print("Applied chat setup for this character on login.")
                end
            end
        end

        self:UnregisterEvent("PLAYER_LOGIN")
    end
end)
