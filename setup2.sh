#!/bin/bash

# Colores para output
R='\033[0;31m'
G='\033[0;32m'
Y='\033[1;33m'
NC='\033[0m'

# Configuración
MY_CONFIGS="https://github.com/Gax-n2o/My-config.git"
ruta=$(pwd)"
FOLDER2=($HOME/My-config)

mkdir -p ~/github

# Script
sudo cp -av $ruta/scripts/autonmap ~/.local/bin

# instalar snap y flatpak
sudo apt install snapd
sudo apt install flatpak -y
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Instalando xautolock, betterlock y tmux

cd ~/github
wget http://ftp.debian.org/debian/pool/main/x/xautolock/xautolock_2.2-8_amd64.deb
sudo dpkg -i xautolock_2.2-8_amd64.deb

#tmux
cd ~/github
git clone --single-branch https://github.com/gpakosz/.tmux.git
ln -s -f .tmux/.tmux.conf
cp .tmux/.tmux.conf.local .

#betterlockscreen
git clone https://github.com/betterlockscreen/betterlockscreen 
cd betterlockscreen 
sudo ./install.sh

# Instalar i3lock imagemagick
sudo apt install i3lock imagemagick bc feh

# Instalar Obsidian thunderbird y thunar

sudo snap install obsidian --classic

sudo apt install thunderbird -y

sudo apt install thunar -y

# Install freetube
flatpak install flathub io.freetubeapp.FreeTube 
sudo flatpak repair

# Instalando de mas apt

sudo apt install arandr
sudo apt install blueman bluez bluez-tools pulseaudio-module-bluetooth -y

#Instalando xclip
sudo apt install xclip

#Crontab para la actualizacion automatica de updates
sudo crontab -l > /tmp/micron 2>/dev/null
echo "*/30 * * * * /usr/bin/apt update >/dev/null 2>&1 && /usr/bin/apt list --upgradable 2>/dev/null | /bin/grep -E '^[^[:space:]]+[[:space:]]+' | /usr/bin/tee /home/n2o/.config/bin/updates-full.txt | /usr/bin/wc -l > /home/n2o/.config/bin/updates-count.txt" >> /tmp/micron
# Cargar el archivo
sudo crontab /tmp/micron
rm /tmp/micron

# Clonar tus configuraciones personales
echo -e "${G}📥 Descargando tus configuraciones personales...${NC}"
cd
git clone "$MY_CONFIGS" "$FOLDER2"

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
    ["nanorc"]="$HOME/.nanorc"
)

for dir in "${!config_map[@]}"; do
    if [ -d "$dir" ]; then
        # Eliminar configuración existente si la hay
        rm -rf "${config_map[$dir]}"
        # Copiar nueva configuración
        cp -r "$ruta" "${config_map[$dir]}"
        echo -e "${GREEN}✅ $dir configurado${NC}"
    else
        echo -e "${YELLOW}⚠️  No se encontró configuración para $dir en tu repo${NC}"
    fi
done

for file in "${!home_file[@]}"; do
    if [ -f "$file" ]; then
        # Eliminar configuración existente si la hay
        rm -rf "${home_file[$file]}"
        # Copiar nueva configuración
        cp -r "$ruta" "${home_file[$file]}"
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

# restaurando el entorno virtual, si se hace desce el entorno virtual.
xrandr --output Virtual1 --mode 1920x1080

# Eliminar
rm -rf "$ruta"
rm -rf "~/github"

echo -e "${GREEN}✨ Setup completado!${NC}"
echo -e "${YELLOW}💡 Puedes cerrar sesion y entrar a bspwm${NC}"
