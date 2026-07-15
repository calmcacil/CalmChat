# CI and releases

## Local and pull-request checks

Run `bash scripts/check.sh` locally. Pull requests and pushes to `main` run the same
static, shell, workflow, and version checks, then build a BigWigs snapshot archive.
The package check verifies the required Lua modules and these compatibility targets:

| TOC | Client | Interface |
| --- | --- | --- |
| `CalmChat.toc` | Retail | `120005` |
| `CalmChat_Mists.toc` | Mists Classic | `50503` |
| `CalmChat_Cata.toc` | Cataclysm Classic | `40402` |
| `CalmChat_Wrath.toc` | Titan Reforged | `38001` |
| `CalmChat_TBC.toc` | Burning Crusade Classic | `20505` |
| `CalmChat_Vanilla.toc` | Classic Era and Season of Discovery | `11508` |

The snapshot checkout intentionally has shallow history and no tags. This prevents a
release tag created concurrently on `main` from making BigWigs skip the CI package as
a future-tag safety measure; release publication uses the full immutable tag history.

CI runs for every change; there are no path filters. The stable aggregate check to
require on `main` is `Required` from the `CI` workflow. Do not change the ruleset
until that exact check has reported successfully on a real pull request.

CodeQL is unavailable for Lua, and the addon has no package dependencies,
containers, or infrastructure definitions. Dependency review, CodeQL, container
scanning, and IaC scanning are therefore not applicable. Secret scanning and push
protection should remain enabled in GitHub.

## Release flow

1. Normal Conventional Commit pull requests are squash-merged to `main`.
2. `Release` uses a short-lived GitHub App installation token to create or update a
   reviewable Release Please PR.
3. A maintainer reviews and squash-merges that PR. Release Please updates `VERSION`,
   the manifest, changelog, README marker, and all TOC versions, then creates an
   immutable `vX.Y.Z` tag and GitHub Release.
4. The App-authored `release.published` event starts `Publish release`. The publisher
   checks out the exact tag, verifies it is contained in `main`, reruns checks, and
   invokes BigWigs Packager v2.5.1.
5. The release contains `CalmChat-vX.Y.Z.zip`, a BigWigs-compatible `release.json`, and
   `checksums.txt`. The ZIP has one `CalmChat/` root and all six client TOCs.

`.pkgmeta` keeps migration-only documentation and validation helpers out of the
installable archive, preserving the existing BigWigs package contents.

The publisher is separate from the `main` coordinator deliberately. BigWigs refuses
to package a tag found during a push-to-branch event, even when that tag is checked
out, to protect against a future-tag race. The GitHub App token ensures the published
release event is not suppressed like an event created with the default workflow
token can be.

### Required GitHub App and secrets

Install the shared release App only on this repository with:

- Contents: read and write
- Pull requests: read and write
- Metadata: read (implicit)

Configure repository Actions secrets named `RELEASE_APP_ID` and
`RELEASE_APP_PRIVATE_KEY`. The default Actions token must remain read-only; only the
publisher job receives `contents: write` for release assets.

## First release and recovery

Before the first migrated release, confirm CI produces one snapshot ZIP and inspect
its root, TOCs, and version fields. Merge a normal releasable change, verify the App
opens a release PR with the expected SemVer, then merge it and confirm the tag points
to that reviewed `main` commit. Download all three release assets, run
`sha256sum --check checksums.txt` beside the ZIP and `release.json`, and inspect the
ZIP with `bash scripts/check-package.sh CalmChat-vX.Y.Z.zip X.Y.Z`.

If publication fails after the tag and GitHub Release exist, fix the workflow on a
normal PR and manually dispatch `Publish release` with the existing tag. Never move
or recreate the tag. A recovery rerun downloads and verifies any existing assets and
uploads only missing ones; it never replaces a successful asset. If published source
is wrong, issue a new patch release instead of silently replacing it.

Rollback is installation-based: download the prior known-good
`CalmChat-vX.Y.Z.zip`, verify it against that release's recorded SHA-256 digest, and
replace the installed `CalmChat` addon directory. No release branch is used.
