# CalmChat v3 Smoke Test Checklist

Use this checklist to validate the `3.0.0` refactor on live clients.

## 1) Preflight
- Disable other chat-modifying addons for a clean test.
- Keep one backup copy of your `CalmChat.lua` SavedVariables file.
- Install the current addon build and `/reload`.
- Confirm addon loads without Lua errors.

## 2) Common Sanity Checks
Run on each target client (Retail + at least one Classic target):

1. `/calmchat help`
   - Expected: usage message prints.
2. `/calmchat settings`
   - Expected: CalmChat options panel opens.
3. `/calmchat`
    - Expected: `[CalmChat] Chat setup successful.`
4. Addon compartment click
   - Expected: opens settings; if settings cannot open, falls back to apply.

## 3) Retail Smoke Flow (Midnight 12.0.5)

### A. Defaults
1. Set CalmChat options to defaults using **Reset To Calm Defaults**.
2. Click **Apply Chat Layout**.
3. Verify:
   - `General` tab exists and is selected.
   - `Log` tab exists.
   - `Loot/Trade` tab exists.
   - `Services` tab is not created by default.
   - `General` does not show Trade/Services + XP/honor/faction/loot/tradeskill groups.
   - `Loot/Trade` includes Trade and progression/loot/currency/tradeskill groups.

### B. Retail Services Toggle
1. Enable **Enable Retail Services tab**.
2. Click **Apply Chat Layout**.
3. Verify:
   - `Services` tab is created and receives Services channel messages.

### C. Voice Frame Toggle
1. Keep **Keep Retail voice transcription frame** enabled.
2. Apply and verify no voice-frame errors.
3. Disable it, apply again, and verify apply still succeeds.

### D. Setup On Login
1. Enable **Run setup after login or reload**.
2. `/reload`.
3. Verify:
    - Setup auto-runs only when `initializedPresetVersion` is behind the current preset version.
    - When auto-apply runs, chat prints: `[CalmChat] Applied chat setup for this character on login.`
    - When no auto-apply is needed for the current preset version, no login apply message is printed.

## 4) Classic Smoke Flow (Era/SoD/TBC/Wrath/Cata/Mists)

### A. Defaults
1. Reset to defaults.
2. Click **Apply Chat Layout**.
3. Verify:
   - `General`, `Log`, `Loot/Trade`, and `LFG` tabs are present.
   - `General` excludes Trade + noise groups.
   - `Loot/Trade` includes Trade + progression/loot groups.

### B. LFG Tab + Auto Join
1. Ensure **Enable Classic LFG tab** and **Auto-join Classic LFG channels** are enabled.
2. Apply.
3. Verify:
   - LFG tab shows configured channels.
   - On `enUS`, addon attempts to join configured channels.
   - On non-`enUS`, warning appears once and addon still routes configured names.

### C. Custom Channel Names
1. Set custom values for:
   - **Classic LFG channel name**
   - **Classic Layer channel name**
2. Apply.
3. Verify configured names are used in the LFG tab.

## 5) Settings UI Coverage
Verify settings visibility and persistence after `/reload`:

- Controls shown on all clients:
  - Run setup after login or reload
  - Always reset chat windows before apply
  - Chat font size
  - Keep Retail voice transcription frame
  - Enable Retail Services tab
  - Loot/Trade tab label
  - Apply Chat Layout button
  - Reset To Calm Defaults button

- Client-aware visibility:
  - Retail: Classic section controls are hidden; `Services tab label` is shown; `LFG tab label` is hidden.
  - Classic: Classic section controls are shown; `LFG tab label` is shown; `Services tab label` is hidden.

- Classic-only controls (Classic clients):
  - Enable Classic LFG tab
  - Auto-join Classic LFG channels
  - Classic LFG channel name
  - Classic Layer channel name

- Value persistence:
  - Enter values, `/reload`, and confirm the same values are present.

## 6) Legacy Migration Check (v2 -> v3)
Use a test profile/character for this check.

1. Inject old schema in chat:

```lua
/run CalmChatDB={enableServicesTab=true,enableVoiceFrame=false,autoJoinClassicLFG=false,setupOnLogin=true}; print("CalmChat legacy payload injected; /reload now")
```

2. `/reload`
3. Validate migration:

```lua
/run print("version",CalmChatDB.version)
/run print("services",CalmChatDB.settings.enableRetailServicesTab)
/run print("voice",CalmChatDB.settings.keepRetailVoiceFrame)
/run print("classicLFG",CalmChatDB.settings.enableClassicLFGTab)
/run print("autoLogin",CalmChatDB.settings.setupOnLogin)
/run print("legacy keys removed",CalmChatDB.enableServicesTab==nil and CalmChatDB.enableVoiceFrame==nil and CalmChatDB.autoJoinClassicLFG==nil and CalmChatDB.setupOnLogin==nil)
```

Expected:
- `version` is `3`
- migrated values match the legacy payload intent
- legacy top-level keys are `nil`

## 7) Pass Criteria
- No Lua errors during load, settings open, apply, or reload flows.
- Slash commands and addon compartment are operational.
- Default behavior matches CalmChat's original routing intent.
- New settings persist and control behavior correctly.
- Migration from v2 keys to v3 schema works and is non-destructive.
