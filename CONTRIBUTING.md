# Contributing

Create a short-lived `<type>/<short-kebab-summary>` branch from `main` and open a
pull request. Use a Conventional Commit PR title such as
`fix(chat-routing): preserve trade tab filters`; the squash title determines the
next semantic release.

Run the local CI equivalent before submitting changes:

```bash
bash scripts/check.sh
```

This checks version and compatibility metadata, project invariants, shell scripts,
and GitHub Actions syntax. CI also builds a BigWigs dry-run archive and verifies all
six supported TOCs and required Lua modules. See [CI and releases](docs/CI_RELEASES.md)
for the exact release contract and recovery procedure.

Do not hand-edit `CHANGELOG.md` for normal changes. Release Please owns version and
changelog updates. When intentionally changing compatibility metadata, keep
`VERSION`, `.release-please-manifest.json`, every `CalmChat*.toc`, and the README
version marker aligned.
