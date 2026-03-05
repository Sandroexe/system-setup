#!/bin/bash

# --- FARBEN FÜR DAS TERMINAL ---
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${CYAN}=======================================${NC}"
echo -e "${CYAN}  🚀 Sandro's Universal Bootstrapper  ${NC}"
echo -e "${CYAN}=======================================${NC}\n"

# --- AUSWAHLMENÜ ---
echo -e "${YELLOW}Was möchtest du auf diesem System installieren?${NC}"
echo -e "  [1] Basis-Pakete (git, curl, fish, htop, fastfetch, python3)"
echo -e "  [2] Sandro's Dotfiles & Fish als Standard-Shell"
echo -e "  [3] Network Scanner Tool"
echo -e "  [A] Alles installieren (Standard)"
echo -e ""
read -p "Deine Wahl (z.B. '1 3' oder einfach Enter für Alles): " choices

# Standardmäßig erstmal alles auf "Falsch" setzen
INSTALL_BASE=false
INSTALL_DOTFILES=false
INSTALL_SCANNER=false

# Logik: Wenn die Eingabe leer ist (-z) oder ein 'A' / 'a' enthält, installiere ALLES
if [[ -z "$choices" || "$choices" =~ [Aa] ]]; then
    INSTALL_BASE=true
    INSTALL_DOTFILES=true
    INSTALL_SCANNER=true
    echo -e "\n${GREEN}[+] ALLES ausgewählt! Das volle Setup startet...${NC}\n"
else
    # Prüfen, welche Zahlen eingetippt wurden
    if [[ "$choices" == *"1"* ]]; then INSTALL_BASE=true; fi
    if [[ "$choices" == *"2"* ]]; then INSTALL_DOTFILES=true; fi
    if [[ "$choices" == *"3"* ]]; then INSTALL_SCANNER=true; fi
    echo -e "\n${GREEN}[+] Individuelle Auswahl gespeichert. Setup startet...${NC}\n"
fi

# --- 1. BETRIEBSSYSTEM ERKENNEN (Wird immer gemacht) ---
echo -e "${YELLOW}[*] Analysiere Systemumgebung...${NC}"
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    echo -e "${RED}[!] OS konnte nicht erkannt werden. Abbruch.${NC}"
    exit 1
fi
echo -e "${GREEN}[+] Betriebssystem erkannt: ${OS}${NC}\n"

# --- 2. PAKETE INSTALLIEREN ---
if [ "$INSTALL_BASE" = true ]; then
    echo -e "${YELLOW}[*] Installiere Basis-Pakete...${NC}"
    PACKAGES="git curl wget htop fastfetch fish python3"

    if [[ "$OS" == "arch" || "$OS" == "cachyos" || "$OS" == "manjaro" ]]; then
        sudo pacman -Syu --noconfirm
        sudo pacman -S --noconfirm $PACKAGES
    elif [[ "$OS" == "debian" || "$OS" == "ubuntu" || "$OS" == "linuxmint" ]]; then
        sudo apt update && sudo apt upgrade -y
        sudo apt install -y $PACKAGES python3-venv
    else
        echo -e "${RED}[!] OS nicht unterstützt für automatische Installation.${NC}"
    fi
    echo -e "${GREEN}[+] Pakete erfolgreich installiert!${NC}\n"
fi

# --- 3. & 4. DOTFILES & SHELL ---
if [ "$INSTALL_DOTFILES" = true ]; then
    echo -e "${YELLOW}[*] Richte Dotfiles ein...${NC}"
    DOTFILES_DIR="$HOME/dotfiles"

    if [ ! -d "$DOTFILES_DIR" ]; then
        git clone https://github.com/Sandroexe/dotfiles.git "$DOTFILES_DIR"
        echo -e "${GREEN}[+] Dotfiles erfolgreich heruntergeladen.${NC}"
    else
        echo -e "${CYAN}[*] Dotfiles-Ordner existiert bereits. Ziehe Updates...${NC}"
        cd "$DOTFILES_DIR" && git pull origin main && cd - > /dev/null
    fi

    echo -e "${YELLOW}[*] Erstelle Symlinks für Konfigurationen...${NC}"
    mkdir -p ~/.config/fish
    mkdir -p ~/.config/fastfetch
    # ln -sf $DOTFILES_DIR/config.fish ~/.config/fish/config.fish
    echo -e "${GREEN}[+] Konfigurationen verlinkt!${NC}\n"

    echo -e "${YELLOW}[*] Setze Fish als Standard-Shell...${NC}"
    CURRENT_SHELL=$(basename "$SHELL")
    if [ "$CURRENT_SHELL" != "fish" ]; then
        chsh -s $(which fish)
        echo -e "${GREEN}[+] Shell geändert! (Wird nach dem nächsten Login aktiv)${NC}\n"
    else
        echo -e "${CYAN}[*] Fish ist bereits die Standard-Shell.${NC}\n"
    fi
fi

# --- 5. NETWORK SCANNER ---
if [ "$INSTALL_SCANNER" = true ]; then
    echo -e "${YELLOW}[*] Installiere Sandro's Network Scanner...${NC}"
    SCANNER_DIR="$HOME/projects/network-scanner"

    if [ ! -d "$SCANNER_DIR" ]; then
        mkdir -p ~/projects
        git clone https://github.com/Sandroexe/network-scanner.git "$SCANNER_DIR"
        cd "$SCANNER_DIR"
        chmod +x install.sh
        echo -e "${CYAN}[*] Führe Installer für den Network Scanner aus...${NC}"
        sudo ./install.sh
        cd - > /dev/null
        echo -e "${GREEN}[+] Network Scanner erfolgreich installiert!${NC}\n"
    else
        echo -e "${CYAN}[*] Network Scanner ist bereits vorhanden. Überspringe Klonen...${NC}\n"
    fi
fi

echo -e "${GREEN}=======================================${NC}"
echo -e "${GREEN} 🎉 System-Setup erfolgreich beendet!  ${NC}"
echo -e "${GREEN}=======================================${NC}"
