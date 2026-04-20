#!/bin/bash

# Este script usa Zenity para interface gráfica, normalmente vem instalado em distros com gnome.
# Se não tiver instalado, instale com o comando: 
# debian/ubuntu: sudo apt install zenity
# fedora: sudo dnf install zenity
# arch: sudo pacman -S zenity

# verificação ou instalação do java

# rodar no terminal
run_in_terminal() {
    local CMD="$1"
    local TITLE="$2"

    if command -v gnome-terminal &> /dev/null; then
        gnome-terminal --title="$TITLE" -- bash -c "$CMD; echo; echo '>>> Pressione Enter para fechar...'; read"
    elif command -v xterm &> /dev/null; then
        xterm -title "$TITLE" -e bash -c "$CMD; echo; echo '>>> Pressione Enter para fechar...'; read"
    elif command -v konsole &> /dev/null; then
        konsole --title "$TITLE" -e bash -c "$CMD; echo; echo '>>> Pressione Enter para fechar...'; read"
    elif command -v xfce4-terminal &> /dev/null; then
        xfce4-terminal --title="$TITLE" -e "bash -c \"$CMD; echo; echo '>>> Pressione Enter para fechar...'; read\""
    else
        bash -c "$CMD"
    fi
    wait
}

if ! command -v java &> /dev/null;
then
    PASSWORD=$(zenity --password --title="Autenticação")

    if [ -z "$PASSWORD" ]; then
        zenity --error --text="Senha não fornecida. Operação cancelada."
        exit 1
    fi

    zenity --info --text="A instalação do Java será iniciada.\nAcompanhe o progresso no terminal que será aberto."

    # instalar o java dependente da distribuição
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [ "$ID_LIKE" = "debian" ]; then
            run_in_terminal "echo '$PASSWORD' | sudo -S apt update -y && echo '$PASSWORD' | sudo -S apt install default-jdk -y" "Instalando Java (Debian/Ubuntu)"
        elif [ "$ID_LIKE" = "fedora" ]; then
            run_in_terminal "echo '$PASSWORD' | sudo -S dnf install java-latest-openjdk -y && echo '$PASSWORD' | sudo -S dnf update -y" "Instalando Java (Fedora)"
        elif [ "$ID_LIKE" = "arch" ]; then
            run_in_terminal "echo '$PASSWORD' | sudo -S pacman -Syu --noconfirm jdk-openjdk" "Instalando Java (Arch)"
        fi
    fi

    if command -v java &> /dev/null; then
        zenity --info --text="Java instalado com sucesso!"
    else
        zenity --error --text="Erro ao instalar o Java. Tente instalar manualmente."
        exit 1
    fi
    
else
    zenity --info --text="Java já está instalado!"
fi

# instalação do brmodelo

if [ -f ./brModelo.jar ];
then
    zenity --info --text="BRmodelo já está instalado!"
else
    zenity --info --text="O BRmodelo será baixado.\nAcompanhe o progresso no terminal que será aberto."
    run_in_terminal "wget https://www.sis4.com/brModelo/brModelo.jar" "Baixando BRmodelo"
    if [ -f ./brModelo.jar ]; then
        zenity --info --text="BRmodelo instalado com sucesso!"
    else
        zenity --error --text="Erro ao baixar o BRmodelo. Verifique sua conexão."
        exit 1
    fi
fi