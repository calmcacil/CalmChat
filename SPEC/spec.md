# CalmChat Technical Specification

## Document Status
- Status: Draft
- Product: CalmChat
- Date: 2026-05-06

## 1) Goals
- Preserve current CalmChat behavior as the default preset.
- Keep account-wide settings (`CalmChatDB`) as requested.
- Keep preset auto-initialization account-wide per preset version.
- Keep full chat reset as the default apply behavior.
- Expand Blizzard Settings integration so non-technical users can configure tabs and routing.
- Refactor into maintainable modules with minimal global exposure.
- Maintain compatibility across supported Retail and Classic clients.

## 2) Non-Goals (First Refactor Pass)
- Per-character profile system.
- External dependency migration (Ace3/LDB) unless needed later.
- Replacing reset mode with non-destructive reconcile as default.
- Full localization framework for all UI strings and channel-name resolution.

## 3) Current Architecture (As-Is)

### 3.1 File/Load Map
- `CalmChat.toc` (Retail) and `CalmChat_*.toc` variants for Classic branches.
- All TOCs load one implementation file: `CalmChat.lua`.
- No XML files and no declared library dependencies.
- Saved variable: `CalmChatDB`.

### 3.2 Runtime Flow
1. `ADDON_LOADED` for `CalmChat`
   - Initializes `CalmChatDB` via `EnsureSettings()`.
   - Registers Blizzard settings category when API exists.
2. `PLAYER_LOGIN`
   - Reads `CalmChatDB.setupOnLogin`.
   - Optionally delays one second, then runs `SetupChat()`.
3. User command or UI action
   - `/calmchat` runs `SetupChat()`.
   - `/calmchat settings|config|options` opens settings.
   - Addon compartment click opens settings, falls back to `SetupChat()`.

### 3.3 Event Map
- `ADDON_LOADED`
- `PLAYER_LOGIN`
- No `OnUpdate` script.

### 3.4 Command/Entry Points
- Slash globals:
  - `SLASH_CALMCHAT1 = "/csetupchat"`
  - `SLASH_CALMCHAT2 = "/calmchat"`
  - `SlashCmdList.CALMCHAT`
- Addon compartment global:
  - `CalmChat_OnAddonCompartmentClick`
- Public setup function currently global:
  - `SetupChat`

### 3.5 Current SavedVariables Schema
```lua
CalmChatDB = {
  enableServicesTab = false,
  enableVoiceFrame = true,
  autoJoinClassicLFG = true,
  setupOnLogin = false,
}
```

### 3.6 Current Apply Pipeline
1. Set chat CVars.
2. `FCF_ResetChatWindows()`.
3. Create `Loot/Trade` and optional `Services` or `LFG` frame.
4. Rename/configure tabs by frame ID and references.
5. Remove noisy groups/channels from `General`.
6. Route loot/progression/trade into `Loot/Trade`.
7. Route Retail Services or Classic LFG/Layer into dedicated tab.
8. Select `General` chat tab.

## 4) Technical Debt and Risks
- **Monolithic file**: lifecycle, UI settings, event handling, and chat business logic are tightly coupled.
- **Global leakage**: `SetupChat` is global when only controlled entry points are needed.
- **Hardcoded routing logic**: message groups/channels are embedded in logic, not data-driven.
- **Static assumptions**: frame IDs and fallback frames can be fragile over time.
- **Limited settings UX**: only four booleans; users cannot configure tab names/routes.
- **Classic LFG locale limitation**: auto-join supports `enUS` channel names only.
- **No schema versioning**: DB evolution/migration is implicit and less safe.

## 5) Next-Gen Architecture (To-Be)

### 5.1 Design Principles
- Data-driven presets over hardcoded routing branches.
- Strict separation of concerns.
- Event-driven execution only.
- Capability checks over branch assumptions when possible.
- Keep addon lightweight and dependency-free.

### 5.2 Proposed Module Layout
- `CalmChat.lua` (bootstrap only)
- `Core.lua` (addon namespace, orchestration)
- `Defaults.lua` (default profile and preset definitions)
- `DB.lua` (init, migration, reset helpers)
- `Client.lua` (capability detection: Retail/Classic/features)
- `PresetBuilder.lua` (compute effective layout from config + capabilities)
- `ChatApply.lua` (reset/create/route/apply operations)
- `SettingsUI.lua` (Blizzard settings registration and controls)
- `Commands.lua` (slash command routing)
- `Events.lua` (event registration and dispatch)

Note: TOC load order should be explicit and deterministic once split.

### 5.3 Namespace Strategy
- Introduce local addon table:
  - `local Addon = {}`
- Keep only required global exports:
  - `CalmChatDB` (SavedVariables)
  - slash command globals (Blizzard requirement)
  - `CalmChat_OnAddonCompartmentClick` (TOC requirement)
- Keep apply internals private (local functions / namespaced methods).

## 6) Data Model v3 (Account-Wide)

### 6.1 Schema
```lua
CalmChatDB = {
  version = 3,
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
    general = { enabled = true, name = "General" },
    log = { enabled = true, name = "Log" },
    lootTrade = {
      enabled = true,
      name = "Loot/Trade",
      channels = { "Trade" },
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
      channels = { "Services" },
      retailOnly = true,
    },
    lfg = {
      enabled = true,
      name = "LFG",
      channels = { "LookingForGroup", "Layer" },
      classicOnly = true,
      autoJoin = true,
    },
  },
}
```

### 6.2 Preset Initialization Gate (Account Scope)
- `initializedPresetVersion` tracks the latest preset version auto-applied for the account.
- On login, when `settings.setupOnLogin` is enabled, CalmChat applies only when:
  - `initializedPresetVersion < Addon.PRESET_VERSION`
- After a successful apply, CalmChat sets `initializedPresetVersion = Addon.PRESET_VERSION`.
- Manual apply (`/calmchat` or settings Apply button) always runs and also updates `initializedPresetVersion`.
- This behavior is intentionally account-wide (not per character) to avoid repeated auto-apply on every character for the same preset version.

### 6.3 Migration Strategy
- Add `DB:Initialize()` and `DB:Migrate(fromVersion)`.
- Map legacy booleans to v3 keys on first run.
- Preserve user intent:
  - `enableServicesTab` -> `enableRetailServicesTab`
  - `enableVoiceFrame` -> `keepRetailVoiceFrame`
  - `autoJoinClassicLFG` -> `enableClassicLFGTab` + `tabs.lfg.autoJoin`
  - `setupOnLogin` -> unchanged

## 7) Blizzard Settings UI Blueprint

### 7.1 Category Structure
- Category: `CalmChat`
- Sections:
  - Apply Behavior
  - Retail Options
  - Classic Options
  - Tabs and Routing

### 7.2 Controls (First Pass)
- Checkbox: Run setup after login/reload.
- Checkbox: Always reset chat windows before apply (default true).
- Edit box: Chat font size (numeric, clamped to configured min/max).
- Checkbox: Keep Retail voice transcription frame.
- Checkbox: Enable Retail Services tab.
- Checkbox: Enable Classic LFG tab.
- Edit box: Classic LFG channel name.
- Edit box: Classic Layer channel name.
- Edit box: `Loot/Trade` tab label.
- Edit box: `Services` tab label.
- Edit box: `LFG` tab label.
- Button: Apply Chat Layout.
- Button: Reset to Calm Defaults.

### 7.3 UX Behavior
- Changing controls updates DB values only.
- Layout changes take effect on Apply button or `/calmchat`.
- Control visibility is client-aware:
  - Retail hides Classic-only controls.
  - Classic hides the Retail Services tab label field.
- Success and error messages remain concise and actionable.

## 8) Apply Engine Blueprint

### 8.1 Steps
1. Load effective config from DB.
2. Resolve client capabilities.
3. Build active tab plan from preset + toggles.
4. Validate required Blizzard APIs.
5. If `resetBeforeApply` then call `FCF_ResetChatWindows()`.
6. Create required tabs/windows in deterministic order.
7. Apply names/channels/message groups.
8. Apply client-specific extras (voice/services/lfg auto-join).
9. Select General tab.
10. Emit one success/failure status.

### 8.2 Determinism Rules
- Stable tab creation order.
- Always clear destination tabs before assigning groups/channels.
- Never rely solely on implicit frame numbers if direct references are available.

### 8.3 Error Handling
- Guard every client-specific API call.
- Continue partial apply where safe; fail fast only for critical missing APIs.
- Provide user-friendly warnings (for example unsupported locale auto-join).

## 9) Performance and Safety
- Keep event-only execution; do not add `OnUpdate` loops.
- Register only required events.
- Unregister one-time events after use.
- Use local upvalues for repeated globals where beneficial.
- Preserve defensive wrappers (`CallGlobal`, `CallFrame`) or equivalent namespaced utility layer.

## 10) Compatibility Plan
- Maintain all packaged TOCs and interface numbers currently shipped.
- Avoid APIs unavailable on Classic branches by capability checking.
- Keep Settings UI registration conditional for clients lacking modern Settings API.
- Retain slash command fallback path when settings cannot open.

## 11) Validation Plan

### 11.1 Functional Checks
- `/calmchat` applies default layout on each supported client branch.
- `/calmchat settings` opens panel where available.
- Addon compartment click opens settings or falls back safely.
- `setupOnLogin` applies only when `initializedPresetVersion` is behind `Addon.PRESET_VERSION`.
- Login auto-apply emits a dedicated message only when an apply occurred.
- Retail Services tab behavior matches toggle.
- Classic LFG auto-join obeys toggle and channel names.

### 11.2 Regression Checks
- No Lua errors during load/login/apply cycles.
- Existing users migrate from legacy DB fields without data loss.
- Chat routing remains equivalent to current defaults unless user changed settings.

## 12) Delivery Phases
1. Refactor scaffolding and module split with no behavior change.
2. Introduce v3 DB schema and migration layer.
3. Implement data-driven preset builder and apply engine.
4. Expand Blizzard Settings UI controls and apply/reset actions.
5. Validate across Retail + Classic TOC targets.

## 13) Definition of Done
- Specs implemented with account-wide DB and reset-by-default behavior.
- Default output remains faithful to current CalmChat experience.
- Users can configure practical chat-tab behavior in Blizzard Settings.
- Codebase is modular, easier to test, and safer to extend.
