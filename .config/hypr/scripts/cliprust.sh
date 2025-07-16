#!/bin/bash

# echo $CLIPBOARD_STATE

tmpfile=$(mktemp /dev/shm/cliprust.XXXXXX)
chmod 600 "$tmpfile"
trap 'shred -u "$tmpfile" 2>/dev/null' EXIT
cat >"$tmpfile"
if ! wl-paste --list-types | rg -q "x-kde-passwordManagerHint"; then
    cliprust store <"$tmpfile"
fi
