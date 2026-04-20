#!/bin/bash

# verificação ou instalação do java

# arquivo temporário para a senha
PASS_FILE=$(mktemp)
chmod 600 "$PASS_FILE"
trap 'rm -f "$PASS_FILE"' EXIT

# Terminal para comandos
run_in_terminal() {
    local TITLE="$1"
    local CMD_STR="$2"

    if command -v gnome-terminal &> /dev/null; then
        gnome-terminal --title="$TITLE" -- bash -c "$CMD_STR; echo; echo '>>> Pressione Enter para fechar...'; read"
    elif command -v xterm &> /dev/null; then
        xterm -title "$TITLE" -e bash -c "$CMD_STR; echo; echo '>>> Pressione Enter para fechar...'; read"
    elif command -v konsole &> /dev/null; then
        konsole --title "$TITLE" -e bash -c "$CMD_STR; echo; echo '>>> Pressione Enter para fechar...'; read"
    elif command -v xfce4-terminal &> /dev/null; then
        xfce4-terminal --title="$TITLE" -e "bash -c \"$CMD_STR; echo; echo '>>> Pressione Enter para fechar...'; read\""
    else
        bash -c "$CMD_STR"
    fi
    wait
}

# Instalação do Java
if ! command -v java &> /dev/null; then

    PASSWORD=$(zenity --password --title="Autenticação")

    if [ -z "$PASSWORD" ]; then
        zenity --error --text="Senha não fornecida. Operação cancelada."
        exit 1
    fi

    printf '%s\n' "$PASSWORD" > "$PASS_FILE"
    unset PASSWORD

    if ! sudo -S -k < "$PASS_FILE" true 2>/dev/null; then
        zenity --error --text="Senha incorreta. Operação cancelada."
        exit 1
    fi

    zenity --info --text="A instalação do Java será iniciada.\nAcompanhe o progresso no terminal que será aberto."

    # instalar o java dependente da distribuição
    if [ -f /etc/os-release ]; then
        . /etc/os-release

        if [ "$ID_LIKE" = "debian" ]; then
            run_in_terminal "Instalando Java (Debian/Ubuntu)" \
                "sudo -S -k < '$PASS_FILE' apt update -y && sudo -S -k < '$PASS_FILE' apt install default-jdk -y"

        elif [ "$ID_LIKE" = "fedora" ]; then
            run_in_terminal "Instalando Java (Fedora)" \
                "sudo -S -k < '$PASS_FILE' dnf install java-latest-openjdk -y && sudo -S -k < '$PASS_FILE' dnf update -y"

        elif [ "$ID_LIKE" = "arch" ]; then
            run_in_terminal "Instalando Java (Arch)" \
                "sudo -S -k < '$PASS_FILE' pacman -Syu --noconfirm jdk-openjdk"
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

# Instalação do BRmodelo
BRMODELO_URL="https://www.sis4.com/brModelo/brModelo.jar"
BRMODELO_JAR="./brModelo.jar"

if [ -f "$BRMODELO_JAR" ]; then
    zenity --info --text="BRmodelo já está instalado!"
else
    zenity --info --text="O BRmodelo será baixado.\nAcompanhe o progresso no terminal que será aberto."

    # Baixa com verificação
    run_in_terminal "Baixando BRmodelo" \
        "wget --show-progress -O '$BRMODELO_JAR' '$BRMODELO_URL'"

    if [ -f "$BRMODELO_JAR" ]; then
        if file "$BRMODELO_JAR" | grep -q "Zip\|Java"; then
            zenity --info --text="BRmodelo instalado com sucesso!"
        else
            rm -f "$BRMODELO_JAR"
            zenity --error --text="Erro ao baixar o BRmodelo. Tente novamente."
            exit 1
        fi
    else
        zenity --error --text="Erro ao baixar o BRmodelo. Verifique sua conexão."
        exit 1
    fi
fi