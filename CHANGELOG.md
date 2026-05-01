# Changelog

All notable changes to this project are documented in this file.

## [2.1.2](https://github.com/calmcacil/CalmChat/compare/v2.1.1...v2.1.2) (2026-05-01)


### CI

* automate semver, release, and branch protections ([22698d3](https://github.com/calmcacil/CalmChat/commit/22698d37fb1e356dc59fba20801496be616cb70c))
* gate release-please behind dedicated token ([9dccac3](https://github.com/calmcacil/CalmChat/commit/9dccac31aa0c1828ca9d89bddd1fd7b85edd4d13))
* harden release automation guards ([de05f82](https://github.com/calmcacil/CalmChat/commit/de05f82e6c9d4c6ebb92bc44d4b8363341004814))

## [2.1.1] - 2026-05-01

### Added

- Blizzard Settings integration with SavedVariables-backed options and addon compartment settings entry.
- Static validation workflow and package dry-run workflow in GitHub Actions.

### Changed

- Refactored chat setup logic into focused helper functions.
- Hardened cross-client behavior around optional WoW APIs.
- Updated compatibility metadata for Retail Midnight 12.0.5 and Classic TOC variants.
