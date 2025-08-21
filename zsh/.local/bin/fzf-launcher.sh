#!/bin/bash

# 1. Find all desktop files
DESKTOP_FILES=$(find /usr/share/applications ~/.local/share/applications -name "*.desktop")

# 2. Make a list: "App Name::Path"
APPS=$(while read -r file; do
    NAME=$(grep -m 1 '^Name=' "$file" | cut -d= -f2)
    [[ -n "$NAME" ]] && echo "$NAME::$file"
done <<< "$DESKTOP_FILES")

# 3. Use fzf to pick an app
CHOSEN=$(echo "$APPS" | fzf --prompt="Launch: " --with-nth=1 --delimiter="::" \
    --preview='grep -E "^Name=|^Exec=" {2}' --preview-window=down:3:wrap)

[[ -z "$CHOSEN" ]] && exit

# 4. Get file path from selection (fixed)
FILE="${CHOSEN#*::}"

# 5. Extract and run the Exec command
EXEC=$(grep -m 1 '^Exec=' "$FILE" | cut -d= -f2 | sed 's/%.//g')

# Optional: remove arguments like --something %U
# Or leave it if you want to preserve them
echo "$EXEC"
