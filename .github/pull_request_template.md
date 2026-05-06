## Summary

Describe what changed and why.

## Validation

- [ ] I ran `bash scripts/check-static.sh` locally.
- [ ] I verified CI checks relevant to this PR are green.

## Workflow Checklist

- [ ] Branch name follows `<type>/<short-kebab-summary>`.
- [ ] PR title matches Conventional Commits:
      `^(feat|fix|refactor|perf|docs|chore|ci|test|build)(\([a-z0-9._/-]+\))?(!)?: .+`
- [ ] Commit subjects in this PR match the same Conventional Commit format.
- [ ] This PR is focused on one logical change.

## Release and Changelog Checklist

- [ ] I did not hand-edit `CHANGELOG.md` for normal development changes.
- [ ] If release metadata was touched, I kept these in sync:
      `VERSION`, `.release-please-manifest.json`, `CalmChat*.toc` `## Version`, and the README version marker block.

## SemVer Intent

- [ ] `feat` implies a minor release.
- [ ] `fix` implies a patch release.
- [ ] Breaking changes use `!` in the subject and include a `BREAKING CHANGE:` footer.
