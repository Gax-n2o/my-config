#!/bin/bash

# Colores más vivos (usando tput)
reset=$(tput sgr0)
bold=$(tput bold)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)

# Íconos de Nerd Fonts (asumiendo que usas una como JetBrainsMono Nerd Font)
icon_pkg=""          # paquete
icon_update="󰏔"       # actualización
icon_check=""       # verificar
icon_done=""        # hecho
icon_wait=""        # espera

# Archivo de número para polybar
NUM_FILE="$HOME/.config/bln/updates.txt"

# Función para refrescar lista con spinner
refresh_list() {
    CACHE_FILE="/tmp/apt-update-timestamp"
    CACHE_TIME=3600		# Buscar Actualizaciones cada hora

    if [[ ! -f "$CACHE_FILE" ]] || [[ $(($(date +%s) - $(cat "$CACHE_FILE"))) -gt $CACHE_TIME ]]; then
        echo -ne "${cyan}${icon_wait} Actualizando lista de paquetes... ${reset}"
        sudo apt update > /dev/null 2>&1 &
        pid=$!
        spin='-\|/'
        i=0
        while kill -0 $pid 2>/dev/null; do
            i=$(( (i+1) %4 ))
            printf "\r${cyan}${icon_wait} Actualizando lista de paquetes... ${spin:$i:1} ${reset}"
            sleep 0.2
        done
        printf "\r${green}${icon_done} Lista actualizada.         \n"
        date +%s > "$CACHE_FILE"
    fi
}

# Refrescar antes de mostrar
refresh_list

# Obtener paquetes actualizables
pkgs=$(apt list --upgradable 2>/dev/null)
total=$(echo "$pkgs" | grep -c upgradable)

# Guardar total para polybar
echo "$total" > "$NUM_FILE"

clear

# Cabecera
if [[ $total -eq 0 ]]; then
    echo -e "${green}${icon_check} No hay actualizaciones disponibles.${reset}"
    echo -e "\n${bold}${white}Presiona cualquier tecla para salir...${reset}"
    read -n1
    exit 0
fi

echo -e "${bold}${yellow}${icon_update} Hay ${total} $( [[ $total -eq 1 ]] && echo "actualización" || echo "actualizaciones" ) disponibles ${reset}"
echo -e "${blue}─────────────────────────────────────────${reset}\n"

# Mostrar lista con íconos y colores
echo "$pkgs" | while IFS= read -r line; do
    pkg_name=$(echo "$line" | awk -F'/' '{print $1}')
    new_ver=$(echo "$line" | awk '{print $2}')
    old_ver=$(echo "$line" | grep -oP '(?<=\[)(.*?)(?=\])' | sed 's/.*: //')
    printf "${icon_pkg} ${bold}${white}%-20s${reset} ${green}%s${reset} ${yellow}→${reset} ${cyan}%s${reset}\n" "$pkg_name" "$old_ver" "$new_ver"
done

echo -e "\n${bold}${white}Presiona cualquier tecla para salir...${reset}"
read -n1
echo
