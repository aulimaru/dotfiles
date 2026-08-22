#!/bin/bash

tmp=$(mktemp --suffix=.png)

wl-paste --type image/png > "$tmp" || exit 1

tesseract "$tmp" stdout -l chi_sim+eng --oem 1 --psm 6 \
| perl -CSD -pe 's/(?<=\p{Han})\s+(?=\p{Han})//g'

rm "$tmp"
