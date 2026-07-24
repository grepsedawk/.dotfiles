#!/bin/bash

set -euo pipefail

STATUSLINE="${BASH_SOURCE[0]%/*}/../.config/i3wm-osx/statusline"
# shellcheck disable=SC1090
source "$STATUSLINE"

assert_delta() {
  local expected=$1 used=$2 now=$3
  local reset=1700604800 actual
  actual=$(codex_weekly_delta "$used" 604800 "$reset" "$now")
  [[ $actual == "$expected" ]] || {
    printf 'expected %s, got %s\n' "$expected" "$actual" >&2
    return 1
  }
}

assert_no_delta() {
  if codex_weekly_delta "$@" >/dev/null; then
    printf 'expected no delta for: %s\n' "$*" >&2
    return 1
  fi
}

window_start=1700000000

assert_delta "-4" 10 "$window_start"
assert_delta "+6" 20 "$window_start"
assert_delta "-29" 14 "$(( window_start + 2 * 86400 ))"
assert_delta "0" 29 "$(( window_start + 86400 ))"
assert_delta "-15" 14 "$(( window_start + 2 * 86400 - 1 ))"
assert_delta "-15" 85 "$(( window_start + 6 * 86400 ))"

assert_no_delta 10 604800 invalid "$window_start"
assert_no_delta 10 604800 1700604800 "$(( window_start - 1 ))"
assert_no_delta 10 604800 1700604800 1700604800
assert_no_delta 10 18000 1700604800 "$window_start"

[[ $(codex_delta_color "+1") == "$C_ALERT" ]]
[[ $(codex_delta_color "-1") == "$C_OK" ]]
[[ $(codex_delta_color "0") == "$C_FG" ]]

rendered=$(codex_usage_block "✨" 604800 13 1700604800 "$window_start")
[[ $(printf '[%s]\n' "$rendered" | jq 'length') == 2 ]]
[[ $(printf '[%s]\n' "$rendered" | jq -r '.[0].full_text') == "✨7d 13%" ]]
[[ $(printf '[%s]\n' "$rendered" | jq -r '.[0].color') == "$C_OK" ]]
[[ $(printf '[%s]\n' "$rendered" | jq -r '.[1].full_text') == "-1%" ]]
[[ $(printf '[%s]\n' "$rendered" | jq -r '.[1].color') == "$C_OK" ]]
