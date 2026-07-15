# Changelog

All notable changes to this project are documented in this file.

## [3.1.1](https://github.com/calmcacil/CalmChat/compare/v3.1.0...v3.1.1) (2026-07-15)


### Bug Fixes

* **release:** harden package publication ([d3e7927](https://github.com/calmcacil/CalmChat/commit/d3e79270e3b502a77780ed5ee6e2aaf1b044c20d))


### Documentation

* **contributing:** add agent rules and pr checklist template ([#11](https://github.com/calmcacil/CalmChat/issues/11)) ([0a70f02](https://github.com/calmcacil/CalmChat/commit/0a70f021170d7d44b7313514ebd4177ae2a989a4))


### CI

* simplify github actions workflows ([#12](https://github.com/calmcacil/CalmChat/issues/12)) ([5ad837e](https://github.com/calmcacil/CalmChat/commit/5ad837ea32ec3b5bc2eaa94a9863aa88cfb936d8))
* tolerate empty dry-run package artifacts ([#10](https://github.com/calmcacil/CalmChat/issues/10)) ([2ca381c](https://github.com/calmcacil/CalmChat/commit/2ca381cf02a823663f2b47a9a176adf4fea45817))

## [3.1.0](https://github.com/calmcacil/CalmChat/compare/v3.0.0...v3.1.0) (2026-05-06)


### Features

* add calmchat help command ([5648fe0](https://github.com/calmcacil/CalmChat/commit/5648fe06d64df4e2a19dda99825ffa6cd30ef0fd))
* **chat:** deliver calmchat v3 modular setup and settings controls ([#8](https://github.com/calmcacil/CalmChat/issues/8)) ([0a40ffe](https://github.com/calmcacil/CalmChat/commit/0a40ffeb690ed3c65ab8bc79f87e599d3785afae))


### CI

* automate semver, release, and branch protections ([22698d3](https://github.com/calmcacil/CalmChat/commit/22698d37fb1e356dc59fba20801496be616cb70c))
* detect release commits from merge message body ([e84dfd6](https://github.com/calmcacil/CalmChat/commit/e84dfd6916e1368eab98986dfd012386f350d284))
* fix release packaging trigger ([d57be3b](https://github.com/calmcacil/CalmChat/commit/d57be3b891b0dff2a0d7ccdce92a05369765fadf))
* gate release-please behind dedicated token ([9dccac3](https://github.com/calmcacil/CalmChat/commit/9dccac31aa0c1828ca9d89bddd1fd7b85edd4d13))
* grant auto-tag workflow permission to relabel release PRs ([b349a67](https://github.com/calmcacil/CalmChat/commit/b349a6785ac88eae4ee8b2823032577f68af8e5d))
* harden release automation guards ([de05f82](https://github.com/calmcacil/CalmChat/commit/de05f82e6c9d4c6ebb92bc44d4b8363341004814))
* mark release PRs tagged after auto-tag ([61a0b59](https://github.com/calmcacil/CalmChat/commit/61a0b59021762d4a3aed91c9970bd89d17d349dd))
* **release:** gate release-please to code-changing commits ([#7](https://github.com/calmcacil/CalmChat/issues/7)) ([7c59766](https://github.com/calmcacil/CalmChat/commit/7c59766e8e839ed18bb89af3fb95ae85346cde5c))
* upload dry-run package artifacts ([4d716aa](https://github.com/calmcacil/CalmChat/commit/4d716aa7baeb895d95c6b4916f434ba683aff0f6))
* **workflows:** harden and consolidate github actions pipelines ([#5](https://github.com/calmcacil/CalmChat/issues/5)) ([151fea6](https://github.com/calmcacil/CalmChat/commit/151fea6377ab68ee3fe2624fec7ee623f455d589))

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
