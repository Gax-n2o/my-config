#!/bin/bash

# Colores para output
R='\033[0;31m'
G='\033[0;32m'
Y='\033[1;33m'
NC='\033[0m'

if [ "$(whoami)" == "root" ]; then
    exit 1
fi

ruta=$(pwd)

# Actualizando el sistema

sudo apt update

sudo apt upgrade -y

# Instalando dependencias de Entorno

sudo apt install -y build-essential git vim xcb libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-xinerama0-dev libasound2-dev libxcb-xtest0-dev libxcb-shape0-dev

# Instalando Requerimientos para la polybar

sudo apt install -y cmake cmake-data pkg-config python3-sphinx libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python3-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev libjsoncpp-dev libmpdclient-dev libuv1-dev libnl-genl-3-dev

# Dependencias de Picom

sudo apt install -y meson libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev libxcb-glx0-dev libpcre3 libpcre3-dev

# Instalamos paquetes adionales

sudo apt install -y feh flameshot scrub zsh rofi xclip bat locate wmname acpi bspwm sxhkd imagemagick ranger

# Creando carpeta de Reposistorios

mkdir ~/github

# Descargar Repositorios Necesarios

cd ~/github
git clone --recursive https://github.com/polybar/polybar
git clone https://github.com/ibhagwan/picom.git

# Instalando Polybar

cd ~/github/polybar
mkdir build
cd build
cmake ..
make -j$(nproc)
sudo make install

# Instalando Picom

cd ~/github/picom
git submodule update --init --recursive
meson --buildtype=release . build
ninja -C build
sudo ninja -C build install

# Instalando p10k

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k
echo 'source ~/.powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc

# Instalando p10k root

sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/.powerlevel10k

# Instando lsd

sudo dpkg -i $ruta/lsd.deb

# Instalamos las HackNerdFonts

sudo cp -v $ruta/fonts/HNF/* /usr/local/share/fonts/

# Instalando Fuentes de Polybar

sudo cp -v $ruta/Config/polybar/fonts/* /usr/share/fonts/truetype/

# Copia de configuracion de .p10k.zsh y .zshrc

rm -rf ~/.zshrc
cp -v $ruta/.zshrc ~/.zshrc

cp -v $ruta/.p10k.zsh ~/.p10k.zsh
sudo cp -v $ruta/.p10k.zsh-root /root/.p10k.zsh

# Script

sudo cp -v $ruta/scripts/whichSystem.py /usr/local/bin/
sudo cp -v $ruta/scripts/autonmap ~/.local/bin

# Plugins ZSH

sudo apt install -y zsh-syntax-highlighting zsh-autosuggestions zsh-autocomplete
sudo mkdir /usr/share/zsh-sudo
cd /usr/share/zsh-sudo
sudo wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh

# Cambiando de SHELL a zsh

chsh -s /usr/bin/zsh
sudo usermod --shell /usr/bin/zsh root
sudo ln -s -fv ~/.zshrc /root/.zshrc

# instalar snap y flatpak
sudo apt install flatpak -y
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
# Snap
cd ~/github
wget https://deb.parrot.sh/pool/main/s/snapd/snapd_2.66.1-1_amd64.deb
sudo dpkg -i snapd_2.66.1-1_amd64.deb

# instslando lsd
sudo dpkg -i $ruta/lsd1.2.0.deb

# Instalando bat
sudo dpkg -i $ruta/bat0.26.1.deb

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

# Reemplazar configuraciones
echo -e "${G}🔄 Aplicando tus configuraciones...${NC}"

# Asegurar estructura de directorios
if [ ! -d $HOME/.config ]; then
  echo -e "${Y}Creando Direnctorio config${NC}"
  mkdir -p $HOME/.config
else 
  echo -e "${G}El Directorio config ya esta creado${NC}"
fi

# Moviendo la config de rofi
rm $ruta/rofi.n2o/config.rasi
mv $ruta/config.rasi $ruta/rofi.n2o/

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
)  
    
# Archivos que van directamente al home
echo -e "${G}🔄 Ajustando tus Configuraciones de archivos"
declare -A home_file=(
    ["zshr"]="$HOME/.zshrc"
    ["nanorc"]="$HOME/.config/nanorc"
)

for dir in "${!config_map[@]}"; do
    if [ -d "$ruta/$dir" ]; then
        # Eliminar configuración existente si la hay
        rm -rf "${config_map[$dir]}"
        # Copiar nueva configuración
        cp -r "$ruta/$dir" "${config_map[$dir]}"
        echo -e "${GREEN}✅ $dir configurado${NC}"
    else
        echo -e "${YELLOW}⚠️  No se encontró configuración para $dir en tu repo${NC}"
    fi
done

for file in "${!home_file[@]}"; do
    if [ -f "$ruta/$file" ]; then
        # Eliminar configuración existente si la hay
        rm -rf "${home_file[$file]}"
        # Copiar nueva configuración
        cp -r "$ruta/$file" "${home_file[$file]}"
        echo -e "${GREEN}✅ $file configurado${NC}"
    else
        echo -e "${YELLOW}⚠️  No se encontró configuración para $file en tu repo${NC}"
    fi
done

# Ajustes al rofi
echo -e "${Y}Ajustando el rofi${NC}"
if [ -d $HOME/.config/rofi ]; then
# Cambiarle el nombre a rofin2o por rofi
  mv rofi.n2o rofi
  echo -e "${G}✅ Ajustes  de rofi Cambiados exitosamente${NC}"
else
  echo -e "${R}⚠️ Ajustes del rofi.n2o no Encontrados${NC}"
fi

  
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

echo -e "${G}🔑 Permisos Establecidos Exitosamente${NC}"

# Instalando Wallpaper de S4vitar

mkdir ~/Wallpaper
cp -v $ruta/Wallpaper/*.jpg ~/Wallpaper/
mkdir ~/Wall-lock
cp $ruta/Wallpaper/*.jpg ~/Wall-lock/

# Limpiar

rm -rf ~/github
rm -rf $ruta

# Mensaje de Instalado
echo -e "${G}✨ Setup completado!${NC}"
echo -e "${Y}💡 Puedes cerrar sesion y entrar a bspwm${NC}"
