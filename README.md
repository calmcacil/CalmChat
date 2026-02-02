# CalmChat

A lightweight World of Warcraft addon that configures your chat frames with sensible defaults.

## Features

- Manual chat frame configuration via `/csetupchat` command
- Smart message filtering - removes spam from General chat
- Trade & Services channels on dedicated tabs
- Retail & Classic support - adjusts for your WoW version
- Error-safe - handles API failures gracefully

## Installation

Extract `CalmChat` folder to your WoW AddOns directory:

- **Retail**: `World of Warcraft\_retail_\Interface\AddOns\`
- **Wrath Classic**: `World of Warcraft\_wrath-classic_\Interface\AddOns\`
- **Classic Era**: `World of Warcraft\_classic_era_\Interface\AddOns\`
- **Season of Discovery**: `World of Warcraft\_classic_\Interface\AddOns\`

Log in or `/reload` to load the addon.

## Usage

### Command

| Command | Action |
|---------|--------|
| `/csetupchat` | Manually configure all chat frames |

### Chat Frame Layout

| Frame | Name | Purpose |
|-------|------|----------|
| 1 | General | Main chat (Say, Guild, Party, Raid) |
| 2 | Log | Combat log |
| 3 | Voice | Voice transcription (Retail) |
| 4 | Loot/Trade | Loot, currency, tradeskills, Trade channel |
| 5 | Services/LFG | Services channel (Retail) or LFG (Classic) |

**Default Behavior**
- General: No Trade/Services, no XP/honor/loot spam
- Loot/Trade: Shows XP, honor, loot, currency, tradeskills, Trade channel
- Services: Shows Services channel (Retail) or LFG (Classic)

## Configuration

Edit `CalmChat.lua` to customize defaults:

```lua
-- Line 1: Services tab (disabled by default)
local ENABLE_SERVICES_TAB = false

-- Line 2: Voice frame (enabled by default)
local ENABLE_VOICE_FRAME = true
```

After changing these values, run `/csetupchat` to apply.

## Compatibility

**v2.0** supports **WoW Midnight 12.0** (current Retail)

| Version | Status |
|---------|--------|
| Retail (Midnight 12.0+) | ✅ Compatible |
| Cataclysm Classic | ✅ Compatible |
| Season of Discovery | ✅ Compatible |
| Classic Era | ✅ Compatible (use CalmChat_Vanilla.toc) |
| WotLK Classic | ✅ Compatible |
| Burning Crusade Classic | ✅ Compatible |

## Troubleshooting

**Chat frames not showing expected channels?**
- This is a known limitation in WoW 12.0 - channel assignment API changed
- Workaround: Manually add channels through the UI if needed

**Getting errors?**
- Disable conflicting chat addons temporarily
- Report the full error message

## Credits

**Author:** Calmcacil
Created to replace chat configuration after WeakAuras removed support.
License: Free to use and modify.
