#!/bin/bash
# Muestra la lista de actualizaciones guardada por update-checker
# (no ejecuta apt update, es instantáneo)

# Colores condicionales
if [ -t 1 ]; then
    yellow=$'\e[1;33m'
    blue=$'\e[1;34m'
    green=$'\e[1;32m'
    white=$'\e[1;37m'
    red=$'\e[1;31m'
    end=$'\e[0m'
else
    yellow=""; blue=""; green=""; white=""; red=""; end=""
fi

#iconos
ICON_ERROR=" "
ICON_EXIT="󰩈 "
ICON_ACT="󰮭 "
ICON_UP="󰏕 "
ICON_IGNORATE=" "
ICON_LIST="󱃕 "
ICON_TIME="󱫌 "

# Limpiar pantalla solo si es terminal interactiva
if [ -t 1 ] && [ -t 0 ]; then
    clear
fi

CONFIG_DIR="$HOME/.config/bin"
COUNT_FILE="$CONFIG_DIR/updates-count.txt"
FULL_FILE="$CONFIG_DIR/updates-full.txt"
ERROR_FILE="$CONFIG_DIR/updates-error.log"

# Verificar errores previos
if [[ -f "$ERROR_FILE" ]]; then
    printf "\n%s${ICON_ERROR} Error en la última verificación de actualizaciones:%s\n" "$red" "$end"
    cat "$ERROR_FILE"
    printf "\n%s${ICON_EXIT} Presiona cualquier tecla para salir.%s" "$green" "$end"
    read -n1 key
    exit 1
fi

if [[ ! -f "$COUNT_FILE" ]]; then
    printf "\n%s${ICON_ERROR} No hay información de actualizaciones. Ejecuta update-checker manualmente.%s\n" "$red" "$end"
    exit 1
fi

total=$(cat "$COUNT_FILE")

if [[ "$total" -eq 0 ]]; then
    printf "\n%s${ICON_ACT} No hay actualizaciones disponibles.%s\n" "$blue" "$end"
    if [ -t 0 ]; then
        printf "\n%s${ICON_EXIT} Presiona cualquier tecla para salir.%s" "$green" "$end"
        read -n1 key
    else
        sleep 3
    fi
    exit 0
fi

# Mostrar cabecera
[[ "$total" -eq 1 ]] && word="actualización" || word="actualizaciones"
printf "\n%s${ICON_UP} Hay %d %s disponibles:%s\n\n" "$yellow" "$total" "$word" "$end"
printf "%s ${ICON_LIST}Lista de %s:%s\n\n" "$blue" "$word" "$end"

# Mostrar la lista guardada
if [[ -f "$FULL_FILE" ]]; then
    awk -v white="$white" -v green="$green" -v end="$end" '
    {
        pkg_name = $1
        gsub(/:$/, "", pkg_name)
        newver = $2
        if (match($0, /\[[^]]*\]/)) {
            old = substr($0, RSTART+1, RLENGTH-2)
            sub(/^[^:]*: /, "", old)
        } else {
            old = "?"
        }
        printf "%s%s%s %s >> %s%s\n", white, pkg_name, green, old, newver, end
    }' "$FULL_FILE"
else
    printf "%s${ICON_IGNORATE} No se encontró la lista detallada.%s\n" "$red" "$end"
fi

printf "\n"

if [ -t 0 ]; then
    printf "%s${ICON_EXIT} Presiona cualquier tecla para salir.%s" "$green" "$end"
    read -n1 key
    printf "\n"
else
    printf "%s${ICON_TIME} La ventana se cerrará en 5 segundos...%s" "$green" "$end"
    sleep 5
fi

exit 0
