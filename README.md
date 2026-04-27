# My-config

## Antes de ejecutar el setup.sh modificar el nombre de la carpeta rofi

## Abrir la carpeta rofi y crear una nueva carpeta con el nomre de scripts y meter hay todos los launcher y los powermenu.

# Metodologia de instalacion:

git clone https://github.com/Gax-n2o/My-config.git
cd My-config
mv rofi.n2o rofi
cd rofi
mkdir scripts
mv launcher_* scripts
mv powermenu_* scripts
cd ..
chmod +x setup.sh
./setup.sh
