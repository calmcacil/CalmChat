#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

bash scripts/check-static.sh
shellcheck scripts/*.sh

if command -v actionlint >/dev/null 2>&1; then
    actionlint
elif command -v go >/dev/null 2>&1; then
    go run github.com/rhysd/actionlint/cmd/actionlint@v1.7.12
else
    printf 'error: actionlint or Go is required to validate workflows\n' >&2
    exit 1
fi
