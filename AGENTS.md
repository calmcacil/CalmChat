# CalmChat Agent Instructions

This file defines how coding agents should work in this repository.

## Branching Workflow

- Never commit directly to `main`.
- Create a short-lived branch for each change: `<type>/<short-kebab-summary>`.
- Use one of these branch prefixes: `feat`, `fix`, `refactor`, `perf`, `docs`, `chore`, `ci`, `test`, `build`.
- Keep each branch focused on one logical change and open a PR back to `main`.

## Conventional Commits (Required)

- PR titles and every commit subject must match:
  `^(feat|fix|refactor|perf|docs|chore|ci|test|build)(\([a-z0-9._/-]+\))?(!)?: .+`
- Use lowercase, imperative subjects.
- Use scopes when helpful, for example: `fix(chat-routing): preserve trade tab filters`.
- For breaking changes, use `!` and include a `BREAKING CHANGE:` footer in the commit body.

## Changelog Hygiene

- `CHANGELOG.md` is managed by release automation. Do not hand-edit it for normal development changes.
- Pick commit types intentionally to keep changelog sections clean:
  - `feat`, `fix`, `perf`, `refactor`, `docs`, `build`, `ci` appear in changelog sections.
  - `chore` and `test` are hidden and should be used for internal maintenance when appropriate.
- Avoid noisy commit history (`wip`, `tmp`, or vague subjects) in branches that will be merged.

## SemVer and Release Process

- Use Semantic Versioning: `MAJOR.MINOR.PATCH`.
- Tags must be `vX.Y.Z` and match `VERSION` exactly.
- Release automation (`release-please`) is the source of truth for version bumps and changelog generation.
- Keep release-related files in sync when touching release metadata:
  - `VERSION`
  - `.release-please-manifest.json`
  - `CHANGELOG.md`
  - `CalmChat*.toc` version markers
  - README version marker block
- SemVer intent for commit authors:
  - `feat` -> minor release intent
  - `fix` -> patch release intent
  - `!` or `BREAKING CHANGE:` -> major release intent

## Required Validation

- Run local checks before finalizing a change when possible:
  - `bash scripts/check-static.sh`
- Ensure `.toc` files still include required release markers and correct `## Version`.
- Ensure README compatibility version text remains aligned with `VERSION`.

## Safety and Change Scope

- Do not revert or overwrite unrelated local changes.
- Do not force-push protected/shared branches.
- Keep changes minimal, explicit, and consistent with the existing code and workflow style.
