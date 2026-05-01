# Changelog

All notable changes to this project are documented in this file.

## [2.3.0](https://github.com/calmcacil/CalmChat/compare/v2.2.1...v2.3.0) (2026-05-01)


### Features

* add calmchat help command ([5648fe0](https://github.com/calmcacil/CalmChat/commit/5648fe06d64df4e2a19dda99825ffa6cd30ef0fd))


### CI

* automate semver, release, and branch protections ([22698d3](https://github.com/calmcacil/CalmChat/commit/22698d37fb1e356dc59fba20801496be616cb70c))
* detect release commits from merge message body ([e84dfd6](https://github.com/calmcacil/CalmChat/commit/e84dfd6916e1368eab98986dfd012386f350d284))
* fix release packaging trigger ([d57be3b](https://github.com/calmcacil/CalmChat/commit/d57be3b891b0dff2a0d7ccdce92a05369765fadf))
* gate release-please behind dedicated token ([9dccac3](https://github.com/calmcacil/CalmChat/commit/9dccac31aa0c1828ca9d89bddd1fd7b85edd4d13))
* grant auto-tag workflow permission to relabel release PRs ([b349a67](https://github.com/calmcacil/CalmChat/commit/b349a6785ac88eae4ee8b2823032577f68af8e5d))
* harden release automation guards ([de05f82](https://github.com/calmcacil/CalmChat/commit/de05f82e6c9d4c6ebb92bc44d4b8363341004814))
* mark release PRs tagged after auto-tag ([61a0b59](https://github.com/calmcacil/CalmChat/commit/61a0b59021762d4a3aed91c9970bd89d17d349dd))
* upload dry-run package artifacts ([4d716aa](https://github.com/calmcacil/CalmChat/commit/4d716aa7baeb895d95c6b4916f434ba683aff0f6))

## [2.2.1](https://github.com/calmcacil/CalmChat/compare/v2.2.0...v2.2.1) (2026-05-01)


### CI

* detect release commits from merge message body ([e84dfd6](https://github.com/calmcacil/CalmChat/commit/e84dfd6916e1368eab98986dfd012386f350d284))

## [2.2.0](https://github.com/calmcacil/CalmChat/compare/v2.1.2...v2.2.0) (2026-05-01)


### Features

* add calmchat help command ([5648fe0](https://github.com/calmcacil/CalmChat/commit/5648fe06d64df4e2a19dda99825ffa6cd30ef0fd))


### CI

* fix release packaging trigger ([d57be3b](https://github.com/calmcacil/CalmChat/commit/d57be3b891b0dff2a0d7ccdce92a05369765fadf))
* grant auto-tag workflow permission to relabel release PRs ([b349a67](https://github.com/calmcacil/CalmChat/commit/b349a6785ac88eae4ee8b2823032577f68af8e5d))
* mark release PRs tagged after auto-tag ([61a0b59](https://github.com/calmcacil/CalmChat/commit/61a0b59021762d4a3aed91c9970bd89d17d349dd))
* upload dry-run package artifacts ([4d716aa](https://github.com/calmcacil/CalmChat/commit/4d716aa7baeb895d95c6b4916f434ba683aff0f6))

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
