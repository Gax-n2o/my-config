#!/bin/bash

# Colores para output
R='\033[0;31m'
G='\033[0;32m'
Y='\033[1;33m'
NC='\033[0m'

# Configuración
MY_CONFIGS="https://github.com/Gax-n2o/My-config.git"
FOLDER2="$HOME/myconfig"

# Clonar tus configuraciones personales
echo -e "${G}📥 Descargando tus configuraciones personales...${NC}"
cd
git clone "$MY_CONFIGS" "$FOLDER2"

if [ ! -d "$FOLDER2/My-config" ]; then
  echo -e "si existe la carpeta vamos a modificar la carpeta del rofi"
  cd My-config
  mv rofi.n2o rofi
  cd rofi
  mkdir scripts
  mv launcher_* scripts
  mv powermenu_* scripts
else 
 echo -e "La carpeta no fue encontrada"
fi 
exit 1

# Reemplazar configuraciones
echo -e "${G}🔄 Aplicando tus configuraciones...${NC}"

# Asegurar estructura de directorios
if [ ! -d $HOME/.config ]; then
  echo -e "${Y}Creando Direnctorio config${NC}"
  mkdir -p $HOME/.config
  else 
  echo -e "${G}El Directorio config ya esta creado${NC}"
fi

# Copiar configuraciones específicas
echo -e "${G}🔄 Ajustando tus Configuraciones de directorios"
declare -A config_map=(
    ["bspwm"]="$HOME/.config/bspwm"
    ["sxhkd"]="$HOME/.config/sxhkd"
    ["polybar"]="$HOME/.config/polybar"
    ["rofi"]="$HOME/.config/rofi"
    ["eww"]="$HOME/.config/eww"
    ["bin"]="$HOME/.config/bin"
    ["kitty"]="$HOME/.config/kitty"
    ["picom"]="$HOME/.config/picom"
    ["mpv"]="$HOME/.config/mpv"
    ["Wallpaper"]="$HOME/Wallpaper"
)  
    
# Archivos que van directamente al home
echo -e "${G}🔄 Ajustando tus Configuraciones de archivos"
declare -A home_file=(
    ["zshr"]="$HOME/.zshrc"
    ["nanorc"]="$HOME/.config/nanorc"
)

for dir in "${!config_map[@]}"; do
    if [ -d "$FOLDER2/$dir" ]; then
        # Eliminar configuración existente si la hay
        rm -rf "${config_map[$dir]}"
        # Copiar nueva configuración
        cp -r "$FOLDER2/$dir" "${config_map[$dir]}"
        echo -e "${GREEN}✅ $dir configurado${NC}"
    else
        echo -e "${YELLOW}⚠️  No se encontró configuración para $dir en tu repo${NC}"
    fi
done

for file in "${!home_file[@]}"; do
    if [ -f "$FOLDER2/$file" ]; then
        # Eliminar configuración existente si la hay
        rm -rf "${home_file[$file]}"
        # Copiar nueva configuración
        cp -r "$FOLDER2/$file" "${home_file[$file]}"
        echo -e "${GREEN}✅ $file configurado${NC}"
    else
        echo -e "${YELLOW}⚠️  No se encontró configuración para $file en tu repo${NC}"
    fi
done

# Establecer permisos correctos
echo -e "${GREEN}🔑 Estableciendo permisos...${NC}"
chmod +x $HOME/.config/bspwm/bspwmrc 2>/dev/null
chmod +x $HOME/.config/polybar/launch.sh 2>/dev/null
chmod +x $HOME/.config/bin/*.sh 2>/dev/null
chmod +x $HOME/.config/bspwm/*.sh 2>/dev/null
chmod +x $HOME/.config/bspwm/scripts/*.sh 2>/dev/null
chmod +x $HOME/.config/bspwm/scripts/Bspwm-ScratchPad 2>/dev/null
chmod +x $HOME/.config/bspwm/scripts/bspwm_resize 2>/dev/null
chmod +x $HOME/.config/kitty/kitty.conf 2>/dev/null
chmod +x $HOME/.config/polybar/config.sh 2>/dev/null
chmod +x $HOME/.config/polybar/scripts/*.sh 2>/dev/null
chmod +x $HOME/.config/polybar/scripts/updates/* 2>/dev/null
chmod +x $HOME/.config/rofi/applets/bin/*sh 2>/dev/null
chmod +x $HOME/.config/rofi/applets/shared/theme.bash 2>/dev/null
chmod +x $HOME/.config/rofi/launchers/type-7/launcher.sh 2>/dev/null
chmod +x $HOME/.config/rofi/launchers/type-6/launcher.sh 2>/dev/null
chmod +x $HOME/.config/rofi/launchers/type-5/launcher.sh 2>/dev/null
chmod +x $HOME/.config/rofi/launchers/type-4/launcher.sh 2>/dev/null
chmod +x $HOME/.config/rofi/launchers/type-3/launcher.sh 2>/dev/null
chmod +x $HOME/.config/rofi/launchers/type-2/launcher.sh 2>/dev/null
chmod +x $HOME/.config/rofi/launchers/type-1/launcher.sh 2>/dev/null
chmod +x $HOME/.config/rofi/powermenu/type-6/powermenu.sh 2>/dev/null
chmod +x $HOME/.config/rofi/powermenu/type-5/powermenu.sh 2>/dev/null
chmod +x $HOME/.config/rofi/powermenu/type-4/powermenu.sh 2>/dev/null
chmod +x $HOME/.config/rofi/powermenu/type-3/powermenu.sh 2>/dev/null
chmod +x $HOME/.config/rofi/powermenu/type-2/powermenu.sh 2>/dev/null
chmod +x $HOME/.config/rofi/powermenu/type-1/powermenu.sh 2>/dev/null
echo -e "${GREEN}🔑 Permisos Establecidos Exitosamente${NC}"

# Limpiar
rm -rf "$FOLDER2"

echo -e "${GREEN}✨ Setup completado!${NC}"
echo -e "${YELLOW}💡 Puedes cerrar sesion y entrar a bspwm${NC}"
