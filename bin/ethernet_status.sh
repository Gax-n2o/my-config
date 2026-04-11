#!/bin/sh


#!/bin/sh

# Función para obtener IP y tipo de interfaz
get_info() {
    # Lista interfaces con estado UP (sin espacios)
    for iface in $(ip -o link show | awk -F': ' '/state UP/ {print $2}' | tr -d ' '); do
        ip_addr=$(ip -4 -o addr show "$iface" 2>/dev/null | awk '{print $4}' | cut -d/ -f1)
        [ -z "$ip_addr" ] && continue

        # Determinar tipo de interfaz
        case "$iface" in
            eth*|enp*|ens*|eno*|emp*|ether*) tipo="eth" ;;
            wlan*|wlp*|wl*|wlfi*)            tipo="wifi" ;;
            *)                               tipo="unknown" ;;
        esac

        # Devolver IP y tipo separados por dos puntos
        echo "$ip_addr:$tipo"
        return 0
    done
    return 1
}

# Obtener información
info=$(get_info)

if [ -n "$info" ]; then
    # Extraer IP y tipo (recortando espacios)
    ip=$(echo "$info" | cut -d: -f1)
    tipo=$(echo "$info" | cut -d: -f2)

    # Eliminar espacios o saltos de línea residuales
    ip=$(echo "$ip" | tr -d ' \n\r')
    tipo=$(echo "$tipo" | tr -d ' \n\r')

    # Asignar icono según tipo
    if [ "$tipo" = "eth" ]; then
        icon="󰈀 "
    else
        icon=" "
    fi

    # Salida con formato (ajusta los colores según tu barra)
    echo "%{F#2495e7}$icon%{F#ffffff} $ip%{u-}"
else
    echo "%{F#ff3333} %{F#ffffff}desconectado%{u-}"
fi
