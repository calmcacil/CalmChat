# Security

Report suspected vulnerabilities privately through GitHub's security advisory
interface. Do not include credentials, private account data, or exploit details in
a public issue.

If a token or private key may have been exposed, revoke or rotate it immediately and
then assess affected workflow runs and releases. Removing a secret from a later
commit does not invalidate a leaked credential.

CalmChat is a dependency-free Lua addon. GitHub CodeQL does not support Lua, and
dependency review has no package manifest to analyze, so those optional workflows
are not enabled. CI instead validates the addon metadata and package structure,
checks shell scripts and workflow syntax, and builds the release format on every PR.
