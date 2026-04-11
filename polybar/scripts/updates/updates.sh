#!/bin/bash
COUNT_FILE="$HOME/.config/bin/updates-count.txt"

if [[ -f "$COUNT_FILE" ]]; then
    count=$(cat "$COUNT_FILE")
    if [[ "$count" -gt 0 ]]; then
        echo "%{F#50c878}󰚯 %{F#ffffff}$count%{F-}"
    else
        echo "%{F#50c878}󰚯 %{F#ffffff}0"
    fi
else
    echo "?"
fi
