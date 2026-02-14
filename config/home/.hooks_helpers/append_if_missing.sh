#!/bin/sh
# Append line to file if not already present
file="$1"
line="$2"
[ -f "$file" ] || touch "$file"
grep -Fxq "$line" "$file" || echo "$line" >> "$file"
