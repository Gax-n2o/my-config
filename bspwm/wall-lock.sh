#!/bin/bash

# Directorios
WALLPAPER_DIR="$HOME/Wall-lock"
SCALED_DIR="$WALLPAPER_DIR/scaled"
LAST_FILE="$HOME/.cache/last_wallpaper"

# Resolución de la pantalla (puedes cambiarla manualmente o usar xrandr)
# Si quieres obtenerla automáticamente, descomenta la siguiente línea:
# RESOLUTION=$(xrandr | grep '*' | head -n1 | awk '{print $1}')
# Si prefieres fijarla, ponla aquí:
RESOLUTION="1920x1080"

# Crear carpeta escalada si no existe
mkdir -p "$SCALED_DIR"

# Función para convertir una imagen a PNG escalado
convert_image() {
    local input="$1"
    local output="$SCALED_DIR/$(basename "${input%.*}.png")"

    # Si la imagen original es más reciente que la PNG o la PNG no existe, la convertimos
    if [[ ! -f "$output" ]] || [[ "$input" -nt "$output" ]]; then
        convert "$input" -resize "${RESOLUTION}!" "$output"
        # Si la conversión tuvo éxito, y el original es .jpg o .jpeg, lo eliminamos
        if [[ $? -eq 0 ]] && [[ "$input" =~ \.(jpg|jpeg)$ ]]; then
            rm "$input"
        fi
    fi
}

# Procesar todas las imágenes en la carpeta principal
find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | while read -r img; do
    convert_image "$img"
done

# Lista de imágenes PNG disponibles en la carpeta escalada
IMAGES=("$SCALED_DIR"/*.png)

# Si no hay imágenes, salir
if [ ${#IMAGES[@]} -eq 0 ]; then
    echo "No hay imágenes en $SCALED_DIR"
    exit 1
fi

# Leer última imagen usada
LAST_IMG=""
[ -f "$LAST_FILE" ] && LAST_IMG=$(cat "$LAST_FILE")

# Seleccionar aleatoriamente
RANDOM_IMG="${IMAGES[$RANDOM % ${#IMAGES[@]}]}"

# Evitar repetir la última si hay más de una imagen
if [ ${#IMAGES[@]} -gt 1 ] && [ "$RANDOM_IMG" = "$LAST_IMG" ]; then
    RANDOM_IMG="${IMAGES[$RANDOM % ${#IMAGES[@]}]}"
    while [ "$RANDOM_IMG" = "$LAST_IMG" ]; do
        RANDOM_IMG="${IMAGES[$RANDOM % ${#IMAGES[@]}]}"
    done
fi

# Guardar la imagen elegida para la próxima
echo "$RANDOM_IMG" > "$LAST_FILE"

# Bloquear la pantalla
i3lock -i "$RANDOM_IMG" -u 
