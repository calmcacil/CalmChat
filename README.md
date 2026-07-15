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
| `/calmchat config` | Open CalmChat in Blizzard's settings menu |

You can also open settings from the addon compartment button on clients that support it.

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

Open **Options > AddOns > CalmChat** or run `/calmchat config`.

| Setting | Default | Behavior |
|---------|---------|----------|
| Run setup after login or reload | Off | Applies the preset shortly after `PLAYER_LOGIN` |
| Always reset chat windows before apply | On | Keeps deterministic full-reset behavior before routing |
| Chat font size | 14 | Sets all chat window font sizes during setup (range 8-24) |
| Keep Retail voice transcription frame | On | Preserves Blizzard's Retail voice transcription tab during setup |
| Enable Retail Services tab | Off | Adds a dedicated Services tab when setup runs on Retail |
| Enable Classic LFG tab | On | Creates and routes a dedicated Classic LFG tab |
| Auto-join Classic LFG channels | On | Joins configured LFG channels on English Classic clients |
| Classic LFG/Layer channel names | LookingForGroup/Layer | Lets you configure channel names used by Classic LFG routing |
| Loot/Trade, Services, LFG tab labels | Loot/Trade, Services, LFG | Lets you customize tab names without editing Lua |

Use **Apply Chat Layout** in settings (or run `/calmchat`) to apply changes immediately.

## Compatibility

<!-- x-release-please-start-version -->
**v3.1.0** supports **WoW Midnight 12.0.5** (current Retail)
<!-- x-release-please-end -->

| Version | Status |
|---------|--------|
| Retail (Midnight 12.0.5) | Compatible (`120005`) |
| Mists Classic | Compatible (`50503`) |
| Cataclysm Classic | Compatible (`40402`) |
| Titan Reforged | Compatible (`38001`) |
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

## Contributing (Quick Start)

- Read `AGENTS.md` before changing code, CI, or release files.
- Create a branch from `main` using `<type>/<short-kebab-summary>`.
- Use Conventional Commits for every commit and PR title, for example `fix(chat-routing): preserve trade tab filters`.
- Keep each branch focused on one logical change to keep history and changelog clean.
- Run `bash scripts/check.sh` before opening or updating a PR.
- Do not hand-edit `CHANGELOG.md`; release automation manages changelog entries and version bumps.
- For release metadata updates, keep `VERSION`, `.release-please-manifest.json`, `CalmChat*.toc`, and the README version marker block in sync.
- See [CI and releases](docs/CI_RELEASES.md) for the package contract, release setup, recovery, and rollback.

## Troubleshooting

**Chat frames not showing expected channels?**
- Make sure you are joined to the channel first; CalmChat assigns visible channels but cannot create unavailable regional channels
- Non-English Classic clients do not auto-join `LookingForGroup` or `Layer` because those channel names are locale/community dependent
- Workaround: Manually add channels through the UI if needed

**Getting errors?**
- Disable conflicting chat addons temporarily
- Report the full error message

**Where are settings saved?**
- Settings are account-wide in `CalmChatDB`.

## Credits

**Author:** Calmcacil
Created to replace chat configuration after WeakAuras removed support.
License: Free to use and modify.
