# CalmChat

A lightweight World of Warcraft addon that automatically configures your chat frames with sensible defaults.

## Features

- **Auto-Setup** - Detects and configures missing chat tabs on login
- **Smart Configuration** - 5 organized chat windows with filtered messages
- **Retail & Classic Support** - Automatically adjusts for your WoW version
- **Error Handling** - Robust protection against API failures
- **Fully Configurable** - Toggle automation or customize settings

## Installation

Extract the `CalmChat` folder to your WoW addons directory:
- **Retail**: `World of Warcraft\_retail_\Interface\AddOns\`
- **Classic/SoD**: `World of Warcraft\_classic_\Interface\AddOns\`
- **Vanilla**: `World of Warcraft\_classic_era_\Interface\AddOns\`
### or

- **Alternatively**: Use Install URL feature of wowup.io addon manager.

Then `/reload` in-game.



## Chat Frame Layout

| Frame | Name | Contains |
|-------|------|----------|
| 1 | General | Say, Guild, Party, Raid, etc. |
| 2 | Log | Combat log |
| 3 | Voice | Voice transcription (Retail) |
| 4 | Loot/Trade | XP, Loot, Currency, Trade channel |
| 5 | Services/LFG | Services (Retail) or LFG (Classic) |

**What's Filtered:**
- XP, honor, loot, and tradeskill messages moved to Loot/Trade frame
- Trade/Services channels removed from General
- Class-colored names enabled
- Classic chat style applied

## Commands

| Command | Action |
|---------|--------|
| `/csetupchat` or `/calmchat` | Manually configure chat |
| `/csetupauto on/off` | Toggle automatic setup |
| `/csetupauto` | Check auto-setup status |

## How It Works

1. On first login, CalmChat waits 2 seconds for chat to load
2. Checks if custom tabs exist (Loot/Trade, Services/LFG)
3. If missing, automatically creates and configures all frames
4. You see: `[CalmChat] Chat setup completed successfully!`

**To disable auto-setup:**
```
/csetupauto off
```

## Customization

Edit `CalmChat.lua` to change defaults:

```lua
-- Line 8: Toggle auto-setup
local AUTO_SETUP_ENABLED = true

-- Lines 14-16: Adjust appearance
FONT_SIZE = 14,
FRAME_OFFSET_X = 1,
FRAME_OFFSET_Y = 3,

-- Lines 19-25: Rename frames
FRAME_NAMES = {
    [1] = "General",
    [2] = "Log",
    [4] = "Loot/Trade",
}
```

## Compatibility

**Supported versions:** Retail (11.0.2+), Cataclysm Classic, Season of Discovery, Classic Era

## Troubleshooting

**Auto-setup not working?**
- Wait 3 seconds after login
- Check status: `/csetupauto`
- Manual trigger: `/csetupchat`

**Settings not saving?**
- Disable conflicting chat addons
- Check WTF folder isn't read-only

**Getting errors?**
- Update to latest version
- Disable other chat addons temporarily
- Report with full error message from BugSack

## Contributing

Issues and pull requests welcome! Please test thoroughly in-game before submitting.

## Changelog

**v1.0** - Automatic setup, error handling, Retail/Classic support, bug fixes
**v0.5** - Initial release (manual setup only)

## Credits

**Author:** Calmcacil
Created after WeakAuras removed chat configuration support.

---

**License:** Free to use and modify. Credit original author if redistributing.
