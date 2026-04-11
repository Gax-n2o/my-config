#!/usr/bin/env sh

## Add this to your wm startup file.

# Terminate already running bar instances
killall -q polybar

## Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Lista de barras a lanzar en cada monitor (sin el nombre del monitor)
# Ajusta los nombres si son diferentes en tus archivos .ini
BARS_LEFT="log secondary terciary quaternary quinary updates files prices"
BARS_RIGHT="top primary poweroff"
BARS_CENTER="primary"  # la de workspace.ini

# Archivos de configuración
CONF_CURRENT="$HOME/.config/polybar/current.ini"
CONF_WORKSPACE="$HOME/.config/polybar/workspace.ini"

# Obtener monitores activos
for m in $(polybar --list-monitors | cut -d: -f1); do
    # Lanzar barras izquierdas y derechas con current.ini
    for bar in $BARS_LEFT $BARS_RIGHT; do
        MONITOR=$m polybar $bar -c "$CONF_CURRENT" &
    done

    # Lanzar barra central con workspace.ini
    for bar in $BARS_CENTER; do
        MONITOR=$m polybar $bar -c "$CONF_WORKSPACE" &
    done
done

## Launch

## Left bar
#polybar log -c ~/.config/polybar/current.ini &
#polybar secondary -c ~/.config/polybar/current.ini &
#polybar terciary -c ~/.config/polybar/current.ini &
#polybar quaternary -c ~/.config/polybar/current.ini &
#polybar quinary -c ~/.config/polybar/current.ini &

## Right bar
#polybar top -c ~/.config/polybar/current.ini &
#polybar primary -c ~/.config/polybar/current.ini &

## Center bar
#polybar primary -c ~/.config/polybar/workspace.ini &
