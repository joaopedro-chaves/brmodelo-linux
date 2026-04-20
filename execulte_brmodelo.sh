#!/bin/bash

# execução do programa

# Arquivo temporário para a senha
PASS_FILE=$(mktemp)
chmod 600 "$PASS_FILE"
trap 'rm -f "$PASS_FILE"' EXIT

PASSWORD=$(zenity --password --title="Autenticação brModelo")

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

# checa se o brModelo está instalado

if [ ! -f ./brModelo.jar ]; then
    zenity --error --text="Arquivo brModelo.jar não encontrado.\nExecute primeiro o script de instalação."
    exit 1
fi

#Executa o BRmodelo
sudo -S -k < "$PASS_FILE" java -jar ./brModelo.jar