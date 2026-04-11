#!/bin/bash

# ============================================
# ROTAR WALLPAPER EN ORDEN (no aleatorio)
# ============================================
# Este script selecciona el siguiente wallpaper
# de una lista ordenada cada vez que se ejecuta.
# Ideal para ejecutar al inicio con bspwm.
# ============================================

# ---------- CONFIGURACIÓN ----------
# Ruta a tu carpeta de wallpapers (¡cámbiala si es necesario!)
WALLPAPER_DIR="/home/n2o/Wallpaper"

# Archivo donde se guarda el índice del último wallpaper usado
INDEX_FILE="$HOME/.config/bspwm/.wallpaper_index"
# -----------------------------------

# Verificar que la carpeta de wallpapers existe
if [ ! -d "$WALLPAPER_DIR" ]; then
    echo "Error: La carpeta $WALLPAPER_DIR no existe." >&2
    exit 1
fi

# Obtener lista ordenada de imágenes (solo .jpg, .jpeg, .png)
mapfile -t imagenes < <(
    find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | sort
)

# Contar cuántas imágenes hay
num_imagenes=${#imagenes[@]}

if [ "$num_imagenes" -eq 0 ]; then
    echo "Error: No se encontraron imágenes en $WALLPAPER_DIR" >&2
    exit 1
fi

# Leer el índice actual (si el archivo no existe, empezamos con 0)
if [ -f "$INDEX_FILE" ]; then
    index=$(cat "$INDEX_FILE")
    # Asegurar que sea un número (si está corrupto, reiniciar)
    if ! [[ "$index" =~ ^[0-9]+$ ]]; then
        index=0
    fi
else
    index=0
fi

# Calcular qué imagen toca hoy (módulo para que nunca exceda el total)
idx=$(( index % num_imagenes ))

# Establecer el wallpaper con feh
feh --bg-fill "${imagenes[$idx]}"

# Incrementar el índice para la próxima vez
echo $(( index + 1 )) > "$INDEX_FILE"

# Fin
exit 0
