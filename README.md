# CalmChat

A lightweight World of Warcraft addon that configures your chat frames with sensible defaults.

## Features

- Manual chat frame configuration via `/calmchat` or `/csetupchat`
- Smart message routing - moves XP, loot, currency, tradeskills, and Trade away from General chat
- Trade channel on a dedicated tab, with optional Retail Services tab
- Retail & Classic support - adjusts for your WoW version
- Error-safe - skips unavailable client-specific APIs gracefully

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
| `/calmchat` | Manually configure all chat frames |
| `/csetupchat` | Backward-compatible setup alias |

You can also run setup from the addon compartment button on clients that support it.

### Chat Layout

| Tab | Purpose |
|-----|---------|
| General | Main chat (Say, Guild, Party, Raid) |
| Log | Combat log |
| Voice | Voice transcription (Retail only) |
| Loot/Trade | Loot, currency, tradeskills, Trade channel |
| Services/LFG | Services channel (Retail, if enabled) or LFG (Classic) |

**Default Behavior**
- General: No Trade/Services, no XP/honor/loot spam
- Loot/Trade: Shows XP, honor, loot, currency, tradeskills, Trade channel
- Services/LFG: Shows Services channel on Retail when enabled, or LFG/Layer on English Classic clients

## Configuration

Edit `CalmChat.lua` to customize defaults:

```lua
-- Services tab (disabled by default)
local ENABLE_SERVICES_TAB = false

-- Voice frame (enabled by default)
local ENABLE_VOICE_FRAME = true
```

After changing these values, run `/csetupchat` to apply.

## Compatibility

**v2.0.1** supports **WoW Midnight 12.0.5** (current Retail)

| Version | Status |
|---------|--------|
| Retail (Midnight 12.0.5) | Compatible (`120005`) |
| Mists Classic | Compatible (`50503`) |
| Cataclysm Classic | Compatible (`40402`) |
| Titan Reforged/Wrath Classic | Compatible (`38001`) |
| Burning Crusade Classic | Compatible (`20505`) |
| Season of Discovery | Compatible (`11508`) |
| Classic Era | Compatible (`11508`, use CalmChat_Vanilla.toc) |

## Packaged TOCs

| File | Client |
|------|--------|
| `CalmChat.toc` | Retail Midnight |
| `CalmChat_Mists.toc` | Mists Classic |
| `CalmChat_Cata.toc` | Cataclysm Classic |
| `CalmChat_Wrath.toc` | Titan Reforged |
| `CalmChat_TBC.toc` | Burning Crusade Classic |
| `CalmChat_Vanilla.toc` | Classic Era/Season of Discovery |

## Troubleshooting

**Chat frames not showing expected channels?**
- Make sure you are joined to the channel first; CalmChat assigns visible channels but cannot create unavailable regional channels
- Non-English Classic clients do not auto-join `LookingForGroup` or `Layer` because those channel names are locale/community dependent
- Workaround: Manually add channels through the UI if needed

**Getting errors?**
- Disable conflicting chat addons temporarily
- Report the full error message

## Credits

**Author:** Calmcacil
Created to replace chat configuration after WeakAuras removed support.
License: Free to use and modify.
