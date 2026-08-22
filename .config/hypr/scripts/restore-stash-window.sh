#!/usr/bin/env bash

set -euo pipefail

selection=$(hyprctl clients -j | jq -r '
    .[]
    | select(.workspace.name == "special:stash")
    | [.address, .class, .title]
    | @tsv
' | wofi -I -d -Dimage_size=256 -s "$HOME/.config/wofi/themes/tokyonight-night.css" -k /dev/null -p 'Restore stashed window') || exit 0

address=${selection%%$'\t'*}
[ -n "$address" ] || exit 0

hyprctl dispatch "(function() local dst=hl.get_active_workspace(); for _,w in ipairs(hl.get_workspace_windows(\"special:stash\")) do if w.address == \"$address\" then return hl.dsp.window.move({workspace=dst,window=w,follow=false}) end end; return hl.dsp.no_op() end)()"
