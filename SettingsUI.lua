local ADDON_NAME, Addon = ...

local SettingsUI = {}
Addon.SettingsUI = SettingsUI

local panelFrame
local categoryID
local CONTENT_LEFT_INSET = 12
local EDITBOX_LEFT_INSET = 4

local function HasModernSettings()
    local settings = Settings
    return settings
        and settings.RegisterCanvasLayoutCategory
        and settings.RegisterAddOnCategory
        and settings.OpenToCategory
end

local function IsClassicClient()
    return not (WOW_PROJECT_MAINLINE ~= nil and WOW_PROJECT_ID == WOW_PROJECT_MAINLINE)
end

local function NormalizeFontSize(value, fallback)
    local numberValue = tonumber(Addon.util.Trim(value))
    if not numberValue then
        numberValue = tonumber(fallback) or Addon.DEFAULTS.settings.chatFontSize
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

local function SetTooltip(widget, title, text)
    if not text or text == "" then
        return
    end

    if not widget or type(widget.SetScript) ~= "function" then
        return
    end

    widget:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(title or "CalmChat", 1, 1, 1)
        GameTooltip:AddLine(text, nil, nil, nil, true)
        GameTooltip:Show()
    end)

    widget:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
end

local function CreateSectionHeader(parent, text, anchor)
    local header = parent:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    header:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -14)
    header:SetText(text)
    return header
end

local function CreateCheckbox(parent, anchor, label, tooltip, getValue, setValue)
    local checkbox = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
    checkbox:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -6)

    local text = parent:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    text:SetPoint("LEFT", checkbox, "RIGHT", 6, 0)
    text:SetText(label)

    SetTooltip(checkbox, label, tooltip)

    checkbox.Refresh = function()
        checkbox:SetChecked(getValue())
    end

    checkbox:SetScript("OnClick", function(self)
        setValue(self:GetChecked() and true or false)
    end)

    checkbox.ToggleShown = function(show)
        if show then
            checkbox:Show()
            text:Show()
        else
            checkbox:Hide()
            text:Hide()
        end
    end

    checkbox.GetBottomAnchor = function()
        return checkbox
    end

    return checkbox
end

local function CreateEditBox(parent, anchor, label, tooltip, getValue, setValue)
    local field = CreateFrame("Frame", nil, parent)
    field:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -10)
    field:SetSize(320, 44)

    local title = field:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    title:SetPoint("TOPLEFT", field, "TOPLEFT", 0, 0)
    title:SetText(label)

    local editBox = CreateFrame("EditBox", nil, field, "InputBoxTemplate")
    editBox:SetAutoFocus(false)
    editBox:SetSize(260, 22)
    editBox:SetPoint("TOPLEFT", title, "BOTTOMLEFT", EDITBOX_LEFT_INSET, -4)

    SetTooltip(editBox, label, tooltip)

    local function RefreshField()
        editBox:SetText(getValue() or "")
        editBox:HighlightText(0, 0)
        editBox:SetCursorPosition(0)
    end

    editBox.Refresh = RefreshField
    field.Refresh = RefreshField

    local function Commit()
        setValue(editBox:GetText())
        editBox:ClearFocus()
        editBox.Refresh()
    end

    editBox:SetScript("OnEnterPressed", Commit)
    editBox:SetScript("OnEditFocusLost", Commit)
    editBox:SetScript("OnEscapePressed", function(self)
        self:ClearFocus()
        self.Refresh()
    end)

    field.ToggleShown = function(show)
        if show then
            field:Show()
        else
            field:Hide()
        end
    end

    field.GetBottomAnchor = function()
        return field
    end

    return field
end

local function CreateDivider(parent, anchor)
    local divider = parent:CreateTexture(nil, "ARTWORK")
    divider:SetColorTexture(1, 1, 1, 0.15)
    divider:SetHeight(1)
    divider:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -10)
    divider:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -20, 0)
    return divider
end

local function EnsureScrollContainer(panel)
    local scrollFrame = CreateFrame("ScrollFrame", nil, panel, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", panel, "TOPLEFT", 16, -16)
    scrollFrame:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -34, 50)

    local content = CreateFrame("Frame", nil, scrollFrame)
    content:SetSize(1, 1)
    scrollFrame:SetScrollChild(content)

    panel.scrollFrame = scrollFrame
    panel.content = content
end

local function ReflowLayout(panel)
    if not panel or not panel.content then
        return
    end

    local controls = panel.controls
    local content = panel.content
    local showClassic = IsClassicClient()
    local showRetailOnly = not showClassic
    local currentAnchor = controls.enableRetailServicesTab:GetBottomAnchor()

    local contentWidth = panel.scrollFrame and panel.scrollFrame:GetWidth() or 680
    if contentWidth < 680 then
        contentWidth = 680
    else
        contentWidth = contentWidth - 20
    end
    content:SetWidth(contentWidth)
    controls.subtitle:SetWidth(math.max(200, contentWidth - CONTENT_LEFT_INSET - 16))

    if showClassic then
        controls.classicHeader:Show()
    else
        controls.classicHeader:Hide()
    end

    controls.enableClassicLFGTab.ToggleShown(showClassic)
    controls.autoJoinClassicLFG.ToggleShown(showClassic)
    controls.classicLfgName.ToggleShown(showClassic)
    controls.classicLayerName.ToggleShown(showClassic)
    controls.servicesTabName.ToggleShown(showRetailOnly)
    controls.lfgTabName.ToggleShown(showClassic)

    if showClassic then
        controls.classicHeader:ClearAllPoints()
        controls.classicHeader:SetPoint("TOPLEFT", currentAnchor, "BOTTOMLEFT", 0, -14)
        controls.enableClassicLFGTab:ClearAllPoints()
        controls.enableClassicLFGTab:SetPoint("TOPLEFT", controls.classicHeader, "BOTTOMLEFT", 0, -6)
        controls.autoJoinClassicLFG:ClearAllPoints()
        controls.autoJoinClassicLFG:SetPoint("TOPLEFT", controls.enableClassicLFGTab, "BOTTOMLEFT", 0, -6)
        controls.classicLfgName:ClearAllPoints()
        controls.classicLfgName:SetPoint("TOPLEFT", controls.autoJoinClassicLFG, "BOTTOMLEFT", 0, -10)
        controls.classicLayerName:ClearAllPoints()
        controls.classicLayerName:SetPoint("TOPLEFT", controls.classicLfgName, "BOTTOMLEFT", 0, -10)
        currentAnchor = controls.classicLayerName:GetBottomAnchor()
    end

    controls.tabsHeader:ClearAllPoints()
    controls.tabsHeader:SetPoint("TOPLEFT", currentAnchor, "BOTTOMLEFT", 0, -14)
    controls.lootTradeTabName:ClearAllPoints()
    controls.lootTradeTabName:SetPoint("TOPLEFT", controls.tabsHeader, "BOTTOMLEFT", 0, -10)
    currentAnchor = controls.lootTradeTabName:GetBottomAnchor()

    if showRetailOnly then
        controls.servicesTabName:ClearAllPoints()
        controls.servicesTabName:SetPoint("TOPLEFT", currentAnchor, "BOTTOMLEFT", 0, -10)
        currentAnchor = controls.servicesTabName:GetBottomAnchor()
    end

    if showClassic then
        controls.lfgTabName:ClearAllPoints()
        controls.lfgTabName:SetPoint("TOPLEFT", currentAnchor, "BOTTOMLEFT", 0, -10)
        currentAnchor = controls.lfgTabName:GetBottomAnchor()
    end

    controls.divider:ClearAllPoints()
    controls.divider:SetPoint("TOPLEFT", currentAnchor, "BOTTOMLEFT", 0, -12)
    controls.divider:SetPoint("TOPRIGHT", content, "TOPRIGHT", -16, 0)

    controls.applyButton:ClearAllPoints()
    controls.applyButton:SetPoint("TOPLEFT", controls.divider, "BOTTOMLEFT", 0, -10)
    controls.resetButton:ClearAllPoints()
    controls.resetButton:SetPoint("LEFT", controls.applyButton, "RIGHT", 10, 0)

    local contentBottom = controls.applyButton:GetBottom()
    local contentTop = controls.title:GetTop()
    if not contentBottom or not contentTop then
        return
    end

    local computedHeight = math.ceil((contentTop - contentBottom) + 24)
    if computedHeight < 1 then
        computedHeight = 1
    end

    content:SetHeight(computedHeight)

    local viewHeight = panel.scrollFrame:GetHeight() or 0
    local hasOverflow = computedHeight > (viewHeight + 2)
    if panel.scrollFrame.ScrollBar then
        panel.scrollFrame.ScrollBar:SetShown(hasOverflow)
    end

    if hasOverflow then
        panel.scrollFrame:ClearAllPoints()
        panel.scrollFrame:SetPoint("TOPLEFT", panel, "TOPLEFT", 16, -16)
        panel.scrollFrame:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -34, 50)
    else
        panel.scrollFrame:ClearAllPoints()
        panel.scrollFrame:SetPoint("TOPLEFT", panel, "TOPLEFT", 16, -16)
        panel.scrollFrame:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -16, 50)
        panel.scrollFrame:SetVerticalScroll(0)
    end
end

local function BuildPanel(panel)
    panel.controls = {}
    EnsureScrollContainer(panel)

    local content = panel.content
    local controls = panel.controls

    controls.title = content:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
    controls.title:SetPoint("TOPLEFT", content, "TOPLEFT", CONTENT_LEFT_INSET, 0)
    controls.title:SetText("CalmChat")

    controls.subtitle = content:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    controls.subtitle:SetPoint("TOPLEFT", controls.title, "BOTTOMLEFT", 0, -6)
    controls.subtitle:SetWidth(680 - CONTENT_LEFT_INSET)
    controls.subtitle:SetJustifyH("LEFT")
    controls.subtitle:SetText("Configure CalmChat defaults. Your current preferences remain the baseline preset.")

    local dbGetter = function()
        return Addon.GetConfig()
    end

    controls.applyHeader = CreateSectionHeader(content, "Apply Behavior", controls.subtitle)
    controls.setupOnLogin = CreateCheckbox(
        content,
        controls.applyHeader,
        "Run setup after login or reload",
        "Automatically applies the selected chat preset shortly after PLAYER_LOGIN.",
        function()
            return dbGetter().settings.setupOnLogin
        end,
        function(value)
            dbGetter().settings.setupOnLogin = value
        end
    )

    controls.resetBeforeApply = CreateCheckbox(
        content,
        controls.setupOnLogin,
        "Always reset chat windows before apply",
        "Keeps full reset behavior before applying CalmChat routing.",
        function()
            return dbGetter().settings.resetBeforeApply
        end,
        function(value)
            dbGetter().settings.resetBeforeApply = value
        end
    )

    controls.chatFontSize = CreateEditBox(
        content,
        controls.resetBeforeApply,
        "Chat font size",
        string.format("Default: %d (range %d-%d)", Addon.DEFAULTS.settings.chatFontSize, Addon.CHAT_FONT_SIZE_MIN, Addon.CHAT_FONT_SIZE_MAX),
        function()
            return tostring(dbGetter().settings.chatFontSize)
        end,
        function(value)
            local settings = dbGetter().settings
            settings.chatFontSize = NormalizeFontSize(value, settings.chatFontSize)
        end
    )

    controls.retailHeader = CreateSectionHeader(content, "Retail Options", controls.chatFontSize)
    controls.keepRetailVoiceFrame = CreateCheckbox(
        content,
        controls.retailHeader,
        "Keep Retail voice transcription frame",
        "Preserves Blizzard's voice transcription tab when applying layout on Retail.",
        function()
            return dbGetter().settings.keepRetailVoiceFrame
        end,
        function(value)
            dbGetter().settings.keepRetailVoiceFrame = value
        end
    )

    controls.enableRetailServicesTab = CreateCheckbox(
        content,
        controls.keepRetailVoiceFrame,
        "Enable Retail Services tab",
        "Creates a dedicated Services tab and routes the Services channel to it on Retail.",
        function()
            return dbGetter().settings.enableRetailServicesTab
        end,
        function(value)
            dbGetter().settings.enableRetailServicesTab = value
        end
    )

    controls.classicHeader = CreateSectionHeader(content, "Classic Options", controls.enableRetailServicesTab)
    controls.enableClassicLFGTab = CreateCheckbox(
        content,
        controls.classicHeader,
        "Enable Classic LFG tab",
        "Creates and routes a dedicated LFG tab on Classic clients.",
        function()
            return dbGetter().settings.enableClassicLFGTab
        end,
        function(value)
            dbGetter().settings.enableClassicLFGTab = value
        end
    )

    controls.autoJoinClassicLFG = CreateCheckbox(
        content,
        controls.enableClassicLFGTab,
        "Auto-join Classic LFG channels",
        "Joins configured LFG channels when applying on enUS Classic clients.",
        function()
            return dbGetter().tabs.lfg.autoJoin
        end,
        function(value)
            dbGetter().tabs.lfg.autoJoin = value
        end
    )

    controls.classicLfgName = CreateEditBox(
        content,
        controls.autoJoinClassicLFG,
        "Classic LFG channel name",
        "Default: LookingForGroup",
        function()
            return dbGetter().settings.classicChannelNames.lfg
        end,
        function(value)
            dbGetter().settings.classicChannelNames.lfg = Addon.DB.NormalizeText(value, Addon.DEFAULTS.settings.classicChannelNames.lfg)
        end
    )

    controls.classicLayerName = CreateEditBox(
        content,
        controls.classicLfgName,
        "Classic Layer channel name",
        "Default: Layer",
        function()
            return dbGetter().settings.classicChannelNames.layer
        end,
        function(value)
            dbGetter().settings.classicChannelNames.layer = Addon.DB.NormalizeText(value, Addon.DEFAULTS.settings.classicChannelNames.layer)
        end
    )

    controls.tabsHeader = CreateSectionHeader(content, "Tabs and Routing", controls.classicLayerName)
    controls.lootTradeTabName = CreateEditBox(
        content,
        controls.tabsHeader,
        "Loot/Trade tab label",
        "Default: Loot/Trade",
        function()
            return dbGetter().tabs.lootTrade.name
        end,
        function(value)
            dbGetter().tabs.lootTrade.name = Addon.DB.NormalizeText(value, Addon.DEFAULTS.tabs.lootTrade.name)
        end
    )

    controls.servicesTabName = CreateEditBox(
        content,
        controls.lootTradeTabName,
        "Services tab label",
        "Default: Services",
        function()
            return dbGetter().tabs.services.name
        end,
        function(value)
            dbGetter().tabs.services.name = Addon.DB.NormalizeText(value, Addon.DEFAULTS.tabs.services.name)
        end
    )

    controls.lfgTabName = CreateEditBox(
        content,
        controls.servicesTabName,
        "LFG tab label",
        "Default: LFG",
        function()
            return dbGetter().tabs.lfg.name
        end,
        function(value)
            dbGetter().tabs.lfg.name = Addon.DB.NormalizeText(value, Addon.DEFAULTS.tabs.lfg.name)
        end
    )

    controls.divider = CreateDivider(content, controls.lfgTabName)

    controls.applyButton = CreateFrame("Button", nil, content, "UIPanelButtonTemplate")
    controls.applyButton:SetSize(170, 24)
    controls.applyButton:SetPoint("TOPLEFT", controls.lfgTabName, "BOTTOMLEFT", 0, -16)
    controls.applyButton:SetText("Apply Chat Layout")
    controls.applyButton:SetScript("OnClick", function()
        Addon.SetupChat()
    end)

    controls.resetButton = CreateFrame("Button", nil, content, "UIPanelButtonTemplate")
    controls.resetButton:SetSize(190, 24)
    controls.resetButton:SetPoint("LEFT", controls.applyButton, "RIGHT", 10, 0)
    controls.resetButton:SetText("Reset To Calm Defaults")
    controls.resetButton:SetScript("OnClick", function()
        Addon.ApplyDefaults()
        panel.Refresh()
        Addon.SetupChat()
    end)

    panel.Refresh = function()
        for _, control in pairs(panel.controls) do
            if control and control.Refresh then
                control.Refresh()
            end
        end

        ReflowLayout(panel)
    end

    panel:SetScript("OnShow", panel.Refresh)
end

local function RegisterLegacyOptions(panel)
    if type(InterfaceOptions_AddCategory) == "function" then
        panel.name = "CalmChat"
        InterfaceOptions_AddCategory(panel)
    end
end

function SettingsUI.Register()
    if panelFrame then
        return
    end

    panelFrame = CreateFrame("Frame", "CalmChatSettingsPanel")
    panelFrame.name = "CalmChat"
    BuildPanel(panelFrame)

    if HasModernSettings() then
        local category = Settings.RegisterCanvasLayoutCategory(panelFrame, "CalmChat")
        Settings.RegisterAddOnCategory(category)
        categoryID = type(category.GetID) == "function" and category:GetID() or category.ID
    else
        RegisterLegacyOptions(panelFrame)
    end
end

function SettingsUI.Open()
    SettingsUI.Register()

    if categoryID and Settings and Settings.OpenToCategory then
        Settings.OpenToCategory(categoryID)
        return true
    end

    if panelFrame and type(InterfaceOptionsFrame_OpenToCategory) == "function" then
        InterfaceOptionsFrame_OpenToCategory(panelFrame)
        InterfaceOptionsFrame_OpenToCategory(panelFrame)
        return true
    end

    Addon.PrintError("Settings are unavailable on this client.")
    return false
end
