#!/usr/bin/env bash

NUM_FILE="$HOME/.config/bin/updates.txt"
CACHE_FILE="/tmp/apt-update-timestamp"
CACHE_TIME=3600		# Cada hora busca actualizaciones

# Actualizar lista si ha pasado el tiempo
if [[ ! -f "$CACHE_FILE" ]] || [[ $(($(date +%s) - $(cat "$CACHE_FILE"))) -gt $CACHE_TIME ]]; then
    apt update > /dev/null 2>&1
    date +%s > "$CACHE_FILE"
fi

# Contar actualizaciones
total=$(apt list --upgradable 2>/dev/null | grep -c upgradable)
echo "$total" > "$NUM_FILE"

# Mostrar en polybar con formato
echo "%{F#ffffff}$total"
