#!/bin/bash
set -uo pipefail

# ============================================================================
# update-checker - Actualiza caché APT, cuenta actualizaciones y guarda lista
# Ejecutado automáticamente por cron cada 30 minutos.
# ============================================================================

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

CONFIG_DIR="$HOME/.config/bin"
mkdir -p "$CONFIG_DIR"

TMP_COUNT=$(mktemp)
TMP_FULL=$(mktemp)
trap 'rm -f "$TMP_COUNT" "$TMP_FULL"' EXIT

# Actualizar caché (requiere NOPASSWD en sudoers)
#if ! sudo apt update >/dev/null 2>&1; then
#    echo "ERROR: apt update failed at $(date)" > "$CONFIG_DIR/updates-error.log"
#    exit 1
#fi

# Obtener lista de actualizables
pkgs=$(apt list --upgradable 2>/dev/null | grep -E '^[^[:space:]]+[[:space:]]+' || true)

if [[ -z "$pkgs" ]]; then
    total=0
    echo "No hay actualizaciones disponibles" > "$TMP_FULL"
else
    total=$(printf "%s\n" "$pkgs" | wc -l)
    printf "%s\n" "$pkgs" > "$TMP_FULL"
fi

echo "$total" > "$TMP_COUNT"
mv "$TMP_COUNT" "$CONFIG_DIR/updates-count.txt"
mv "$TMP_FULL" "$CONFIG_DIR/updates-full.txt"

# Limpiar log de error si todo fue bien
rm -f "$CONFIG_DIR/updates-error.log"

exit 0
