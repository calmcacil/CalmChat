#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

fail() {
    printf 'error: %s\n' "$1" >&2
    exit 1
}

read_toc_field() {
    local toc=$1
    local field=$2
    awk -F: -v field="$field" '$0 ~ "^## " field ":" { value = $2; sub(/^[[:space:]]+/, "", value); sub(/[[:space:]]+$/, "", value); print value; exit }' "$toc"
}

check_toc() {
    local toc=$1
    local expected_interface=$2
    local expected_version=$3

    [[ -f "$toc" ]] || fail "$toc is missing"

    local interface version
    interface=$(read_toc_field "$toc" Interface)
    version=$(read_toc_field "$toc" Version)

    [[ "$interface" == "$expected_interface" ]] || fail "$toc has Interface '$interface', expected '$expected_interface'"
    [[ "$version" == "$expected_version" ]] || fail "$toc has Version '$version', expected '$expected_version'"
    grep -qx 'CalmChat.lua' "$toc" || fail "$toc does not load CalmChat.lua"
    grep -Eq '^## SavedVariables:[[:space:]]*CalmChatDB[[:space:]]*$' "$toc" || fail "$toc is missing CalmChatDB SavedVariables"
    grep -Eq '^## AddonCompartmentFunc:[[:space:]]*CalmChat_OnAddonCompartmentClick[[:space:]]*$' "$toc" || fail "$toc is missing AddonCompartmentFunc"
}

expected_version=2.1.1
check_toc CalmChat.toc 120005 "$expected_version"
check_toc CalmChat_Mists.toc 50503 "$expected_version"
check_toc CalmChat_Cata.toc 40402 "$expected_version"
check_toc CalmChat_Wrath.toc 38001 "$expected_version"
check_toc CalmChat_TBC.toc 20505 "$expected_version"
check_toc CalmChat_Vanilla.toc 11508 "$expected_version"

grep -q 'Settings.RegisterVerticalLayoutCategory(ADDON_NAME)' CalmChat.lua || fail 'Settings category registration is missing'
grep -q 'Settings.RegisterAddOnSetting(category, variable, key, CalmChatDB, Settings.VarType.Boolean' CalmChat.lua || fail 'SavedVariable-backed settings registration is missing'
grep -q 'Settings.CreateCheckbox(category, setting, tooltip)' CalmChat.lua || fail 'Settings checkbox creation is missing'
grep -q 'Settings.OpenToCategory(settingsCategoryID)' CalmChat.lua || fail 'Settings open handler is missing'
grep -q 'type(category.GetID) == "function" and category:GetID() or category.ID' CalmChat.lua || fail 'Settings category ID fallback is missing'
grep -q 'SLASH_CALMCHAT1 = "/csetupchat"' CalmChat.lua || fail '/csetupchat slash alias is missing'
grep -q 'SLASH_CALMCHAT2 = "/calmchat"' CalmChat.lua || fail '/calmchat slash alias is missing'
grep -q 'function CalmChat_OnAddonCompartmentClick()' CalmChat.lua || fail 'Addon compartment click handler is missing'

for key in enableServicesTab enableVoiceFrame autoJoinClassicLFG setupOnLogin; do
    grep -q "$key" CalmChat.lua || fail "default setting '$key' is missing"
done

if command -v luac5.1 >/dev/null 2>&1; then
    luac5.1 -p CalmChat.lua
elif command -v luac >/dev/null 2>&1; then
    luac -p CalmChat.lua
else
    fail 'luac is not installed'
fi

printf 'Static checks passed.\n'
