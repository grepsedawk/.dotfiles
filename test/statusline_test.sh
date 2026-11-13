#!/bin/bash

set -euo pipefail

STATUSLINE="${BASH_SOURCE[0]%/*}/../.config/i3wm-osx/statusline"
# shellcheck disable=SC1090
source "$STATUSLINE"

assert_delta() {
  local expected=$1 used=$2 now=$3
  local reset=1700604800 actual
  actual=$(usage_weekly_delta "$used" 604800 "$reset" "$now")
  [[ $actual == "$expected" ]] || {
    printf 'expected %s, got %s\n' "$expected" "$actual" >&2
    return 1
  }
}

assert_no_delta() {
  if usage_weekly_delta "$@" >/dev/null; then
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

[[ $(usage_delta_color "+1") == "$C_ALERT" ]]
[[ $(usage_delta_color "-1") == "$C_OK" ]]
[[ $(usage_delta_color "0") == "$C_FG" ]]

rendered=$(printf '604800\t13\t1700604800\n' | usage_blocks "✨" "$window_start")
[[ $(printf '[%s]\n' "$rendered" | jq -r '[.[].full_text] | join("|")') == "✨|13%|▼1%|07:00:00" ]]
[[ $(printf '[%s]\n' "$rendered" | jq -r '.[1].color') == "$C_OK" ]]
[[ $(printf '[%s]\n' "$rendered" | jq -r '.[2].color') == "$C_OK" ]]
[[ $(printf '[%s]\n' "$rendered" | jq -c '[.[].separator]') == '[false,false,false,null]' ]]

rendered=$(printf '604800\t30\t1700604800\n' | usage_blocks "✨" "$window_start")
[[ $(printf '[%s]\n' "$rendered" | jq -r '.[2] | .full_text + " " + .color') == "▲16% $C_ALERT" ]]

[[ -z $(printf '' | usage_blocks "✨" "$window_start") ]]

[[ $(format_countdown 1700604800 "$(( 1700604800 - 2 * 86400 - 3 * 3600 - 4 * 60 - 59 ))") == "02:03:04" ]]
[[ $(format_countdown 1700604800 1700604900) == "00:00:00" ]]
[[ $(format_countdown "2023-11-21T22:13:20.845087+00:00" 1700604800) == "00:00:00" ]]
[[ $(format_countdown "2023-11-21T22:13:20+00:00" 1700518400) == "01:00:00" ]]

rendered=$(printf '18000\t42\t1700010000\n' | usage_blocks "🤖" 1700000000)
[[ $(printf '[%s]\n' "$rendered" | jq -r '[.[].full_text] | join("|")') == "🤖|5h|42%|00:02:46" ]]
