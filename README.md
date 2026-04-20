# brModelo-linux

Este repositório contém scripts para auxiliar na instalação e execução do brModelo no Linux.

brmodelo é um software livre desenvolvido para auxiliar no ensino e desenvolvimento de banco de dados relacionais. Desenvolvido por Ronaldo dos Santos Mello. mais informações em: https://www.sis4.com/brModelo/

> Este projeto é apenas uma ferramenta de auxilio e não tem vinculos com os desenvolvedores do brModelo.

## Observações

- Zenity: Normalmente já vem instalado em distros com gnome, caso contrário instale com o comando: debian/ubuntu: ``sudo apt install zenity``; fedora: ``sudo dnf install zenity``; arch: ``sudo pacman -S zenity``

- o script verifica se o java está instalado, caso não esteja ele instala a ultima versão do java dependendo da sua distribuição. o mesmo vale para o brModelo.

## Scripts

[instalar_java_brmodelo.sh](instalar_java_brmodelo.sh): Instala o Java e o brModelo
[execulte_brmodelo.sh](execulte_brmodelo.sh): Executa o brModelo

## Como usar

1. Clone o repositório ou baixe:
```bash
git clone https://github.com/radiante-dev/brmodelo-linux.git
```

2. Dê permissão de execução aos scripts caso seja necessário:
```bash
chmod +x *.sh
```

3. Execute os scripts:

Para instalar o Java e o brModelo:
```bash
./instalar_java_brmodelo.sh
```

Para executar o brModelo:
```bash
./execulte_brmodelo.sh
```


