#!/bin/bash

# Este script executa o BRmodelo.
# O script usa Zenity para interface gráfica, normalmente vem instalado em distros com gnome.
# Se não tiver instalado, instale com o comando: 
# debian/ubuntu: sudo apt install zenity
# fedora: sudo dnf install zenity
# arch: sudo pacman -S zenity

# execução do programa

PASSWORD=$(zenity --password --title="Autenticação brModelo")

if [ -z "$PASSWORD" ]; then
    zenity --error --text="Senha não fornecida. Operação cancelada."
    exit 1
fi

echo "$PASSWORD" | sudo -S java -jar ./brModelo.jar