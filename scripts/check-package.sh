#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

expected_archive=${1:-}
expected_version=${2:-$(tr -d '\r\n' < VERSION)}

if [[ -n "$expected_archive" ]]; then
    archives=("$expected_archive")
else
    shopt -s nullglob
    archives=(.release/CalmChat-*.zip)
    shopt -u nullglob
fi

if [[ ${#archives[@]} -ne 1 || ! -f "${archives[0]}" ]]; then
    printf 'error: expected exactly one CalmChat package, found %d\n' "${#archives[@]}" >&2
    exit 1
fi

archive=${archives[0]}
mapfile -t entries < <(unzip -Z1 "$archive")

if [[ ${#entries[@]} -eq 0 ]]; then
    printf 'error: %s is empty\n' "$archive" >&2
    exit 1
fi

for entry in "${entries[@]}"; do
    if [[ "$entry" != CalmChat && "$entry" != CalmChat/* ]]; then
        printf 'error: package entry is outside the CalmChat directory: %s\n' "$entry" >&2
        exit 1
    fi
done

declare -A interfaces=(
    [CalmChat.toc]=120005
    [CalmChat_Mists.toc]=50503
    [CalmChat_Cata.toc]=40402
    [CalmChat_Wrath.toc]=38001
    [CalmChat_TBC.toc]=20505
    [CalmChat_Vanilla.toc]=11508
)

for toc in "${!interfaces[@]}"; do
    contents=$(unzip -p "$archive" "CalmChat/$toc")
    grep -Eq "^## Interface:[[:space:]]*${interfaces[$toc]}[[:space:]]*$" <<< "$contents" || {
        printf 'error: %s has the wrong interface in %s\n' "$toc" "$archive" >&2
        exit 1
    }
    grep -Eq "^## Version:[[:space:]]*${expected_version}[[:space:]]*$" <<< "$contents" || {
        printf 'error: %s does not contain version %s in %s\n' "$toc" "$expected_version" "$archive" >&2
        exit 1
    }
done

for file in CalmChat.lua Defaults.lua Client.lua DB.lua PresetBuilder.lua ChatApply.lua Core.lua SettingsUI.lua Commands.lua Events.lua; do
    if [[ ! " ${entries[*]} " =~ [[:space:]]CalmChat/${file}[[:space:]] ]]; then
        printf 'error: package is missing CalmChat/%s\n' "$file" >&2
        exit 1
    fi
done

printf 'verified %s for CalmChat %s across all six client TOCs\n' "$archive" "$expected_version"
