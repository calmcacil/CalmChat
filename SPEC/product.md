# CalmChat Product Specification

## Document Status
- Status: Draft
- Product: CalmChat
- Date: 2026-05-06

## Product Summary
CalmChat is a lightweight World of Warcraft addon that applies a curated chat-window layout with sensible defaults. It exists to remove repetitive chat setup work after fresh installs, UI resets, patch updates, and alt creation.

The next iteration keeps the author's layout as the default experience while making it configurable through Blizzard's Settings UI so a broader set of players can adapt it to their own workflows.

## Problem Statement
Players regularly lose time rebuilding chat tabs, channels, and message filters. Blizzard's default chat setup is functional but not optimized for many playstyles:

- General chat becomes noisy with loot, XP, currency, and tradeskill spam.
- Trade/Services/LFG visibility is inconsistent between game variants.
- Re-creating tabs and filters by hand is repetitive across reinstalls and alts.

## Target Personas
1. Solo progression player
   - Wants low-noise General chat and a dedicated loot/progression feed.
2. Group and economy player
   - Needs clear separation for Trade/Services/LFG and social channels.
3. Alt-heavy player
   - Wants account-wide defaults and one-click reapplication.
4. UI-focused player
   - Wants a preset as a starting point, then easy in-game customization.

## Core Value Proposition
- Fast setup: one command or login automation applies a full chat preset.
- Better signal-to-noise: relevant content is routed to the right tabs.
- Cross-client compatibility: Retail and Classic variants are handled intentionally.
- Configurable without code edits: users can tailor behavior in Blizzard Settings.

## Product Principles
- Author-first defaults, user-friendly customization.
- Event-driven behavior, no unnecessary `OnUpdate` processing.
- Predictable outcomes: applying the preset should be consistent every run.
- Minimal dependencies and low overhead.

## vNext Scope
### In Scope
- Keep account-wide `CalmChatDB` model.
- Keep full chat reset as the default apply behavior.
- Expand Blizzard Settings integration from basic toggles to practical chat configuration.
- Make tab configuration user-editable while preserving current defaults.
- Keep slash commands for power users.

### Out of Scope (for first refactor pass)
- Per-character profiles.
- Cloud sync/import from external sources.
- Non-destructive reconcile mode as default behavior.
- Full localization of every channel name and UI string.

## Default Experience (Author Preferences)
The out-of-box preset remains aligned with current CalmChat behavior:

- `General`: social/system chat with common spam removed.
- `Log`: combat log.
- `Loot/Trade`: loot, currency, progression, tradeskill, Trade channel.
- `Services` (Retail, optional): Services channel.
- `LFG` (Classic): LookingForGroup/Layer routing when configured.
- Login auto-apply remains optional and disabled by default.

## User Experience Goals
- A new user can install and run `/calmchat` to get a polished layout immediately.
- A customizer can open Blizzard Settings and modify key behavior without touching Lua.
- A returning user can confidently re-apply layout after UI changes with deterministic results.

## Primary User Flows
1. First-run quick apply
   - Install addon -> run `/calmchat` -> preset applied -> success feedback.
2. Settings customization
   - Open `/calmchat settings` -> change tab/channel options -> click Apply.
3. Routine maintenance
   - Enable "run on login" -> addon applies preset shortly after `PLAYER_LOGIN`.

## Success Criteria
- Players can configure tab behavior in Blizzard Settings without editing addon files.
- Default setup still matches current CalmChat visual and routing preferences.
- No `OnUpdate` loop is introduced for core behavior.
- Retail and supported Classic branches remain compatible.
- Reapplying setup is reliable and low error across reload/login cycles.
