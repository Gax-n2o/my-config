# My-config

Antes de ejecutar el setup.sh modificar el nombre de la carpeta rofi

Abrir la carpeta rofi y crear una nueva carpeta con el nomre de scripts y meter hay todos los launcher y los powermenu.

# Metodologia de instalacion:

```bash
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
```
Solo faltaria descargar eww desde su repositorio en Github junto con todas sus dependencias, eso varia de entorno y queda agusto personal de la persona, y solo se utiliza para sacar el calendario, no es una configuracion importante o trascendental, Asi que solo lo dejaria gusto personal.
