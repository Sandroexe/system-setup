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

# --- 1. BETRIEBSSYSTEM ERKENNEN ---
echo -e "${YELLOW}[*] Analysiere Systemumgebung...${NC}"
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    echo -e "${RED}[!] OS konnte nicht erkannt werden. Abbruch.${NC}"
    exit 1
fi
echo -e "${GREEN}[+] Betriebssystem erkannt: ${OS}${NC}\n"

# --- 2. PAKETE INSTALLIEREN (UNIVERSAL) ---
echo -e "${YELLOW}[*] Installiere Basis-Pakete...${NC}"

# Pakete, die auf Arch und Debian gleich heißen
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

# --- 3. DOTFILES VON GITHUB KLONEN ---
echo -e "${YELLOW}[*] Richte Dotfiles ein...${NC}"
DOTFILES_DIR="$HOME/dotfiles"

if [ ! -d "$DOTFILES_DIR" ]; then
    git clone https://github.com/Sandroexe/dotfiles.git "$DOTFILES_DIR"
    echo -e "${GREEN}[+] Dotfiles erfolgreich heruntergeladen.${NC}"
else
    echo -e "${CYAN}[*] Dotfiles-Ordner existiert bereits. Ziehe Updates...${NC}"
    cd "$DOTFILES_DIR" && git pull origin main && cd - > /dev/null
fi

# --- 4. KONFIGURATIONEN VERLINKEN (SYMLINKS) ---
# Hier verknüpfen wir die Dateien aus deinem Repo mit dem System
# (Passe die Pfade an, falls dein Repo intern anders strukturiert ist!)
echo -e "${YELLOW}[*] Erstelle Symlinks für Konfigurationen...${NC}"

mkdir -p ~/.config/fish
mkdir -p ~/.config/fastfetch

# Beispiel: Verlinkt die config.fish aus deinem Repo ins System
# ln -sf $DOTFILES_DIR/config.fish ~/.config/fish/config.fish

echo -e "${GREEN}[+] Konfigurationen verlinkt!${NC}\n"

# --- 5. STANDARD-SHELL ÄNDERN ---
echo -e "${YELLOW}[*] Setze Fish als Standard-Shell...${NC}"
CURRENT_SHELL=$(basename "$SHELL")
if [ "$CURRENT_SHELL" != "fish" ]; then
    chsh -s $(which fish)
    echo -e "${GREEN}[+] Shell geändert! (Wird nach dem nächsten Login aktiv)${NC}\n"
else
    echo -e "${CYAN}[*] Fish ist bereits die Standard-Shell.${NC}\n"
fi

# --- 6. CUSTOM TOOLS INSTALLIEREN (NETWORK-SCANNER) ---
echo -e "${YELLOW}[*] Installiere Sandro's Network Scanner...${NC}"
SCANNER_DIR="$HOME/projects/network-scanner"

# Prüfen, ob der Ordner schon existiert, um Fehler bei doppeltem Ausführen zu vermeiden
if [ ! -d "$SCANNER_DIR" ]; then
    mkdir -p ~/projects
    git clone https://github.com/Sandroexe/network-scanner.git "$SCANNER_DIR"
    
    # In den Ordner wechseln und die Installation starten
    cd "$SCANNER_DIR"
    chmod +x install.sh
    echo -e "${CYAN}[*] Führe Installer für den Network Scanner aus...${NC}"
    sudo ./install.sh
    cd - > /dev/null # Geht leise zurück ins vorherige Verzeichnis
    
    echo -e "${GREEN}[+] Network Scanner erfolgreich installiert!${NC}\n"
else
    echo -e "${CYAN}[*] Network Scanner ist bereits vorhanden. Überspringe Klonen...${NC}\n"
fi

echo -e "${GREEN}=======================================${NC}"
echo -e "${GREEN} 🎉 System-Setup erfolgreich beendet!  ${NC}"
echo -e "${GREEN}=======================================${NC}"
