# 🚀 Sandro's Universal System Bootstrapper

![Bash](https://img.shields.io/badge/Script-Bash-4EAA25?style=flat-square&logo=gnu-bash&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Arch%20%7C%20Debian-lightgrey?style=flat-square&logo=linux)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)

> **"From zero to hero in one command."** ⚡

Ein vollautomatisches Provisioning-Skript, das einen frischen, nackten Linux-Rechner auf Knopfdruck in mein persönliches Workspace-Setup verwandelt. Geschrieben für maximale Portabilität zwischen Arch- und Debian-basierten Systemen.

## ✨ Features

* **🧠 Smart OS Detection:** Erkennt dynamisch, ob das System `pacman` (Arch/CachyOS) oder `apt` (Debian/Ubuntu) nutzt, und passt die Installation an.
* **📦 Core Packages:** Installiert automatisch essenzielle Tools wie `git`, `curl`, `htop`, `fastfetch`, `python3` und `fish`.
* **🔗 Dotfiles Integration:** Lädt mein [Dotfiles-Repository](https://github.com/Sandroexe/dotfiles) herunter und verknüpft die Konfigurationen nahtlos.
* **🐚 Shell Switch:** Richtet `fish` vollautomatisch als neue Standard-Shell für den Benutzer ein.

---

## 🚀 Installation & Ausführung

⚠️ **Disclaimer:** Dieses Skript ist exakt auf meinen Workflow zugeschnitten. Bitte lies dir die `setup.sh` durch, bevor du sie auf deinem eigenen System ausführst!

Führe diese Befehle auf einem frischen System aus, um den Setup-Prozess zu starten:

```bash
# 1. Repo klonen
git clone [https://github.com/Sandroexe/system-setup.git](https://github.com/Sandroexe/system-setup.git)
cd system-setup

# 2. Ausführbar machen und starten
chmod +x setup.sh
./setup.sh
```
*(Hinweis: Das Skript wird dich während der Paketinstallation nach deinem `sudo`-Passwort fragen).*

---

## 📸 Preview

*(Ziehe hier später einen Screenshot rein, wie das Skript im Terminal durchläuft, oder einen Screenshot von deinem fertigen Desktop/Fastfetch!)*

## 🛠️ Geplante Updates
- [ ] Modulare Installation (Abfrage: "Möchtest du auch Python-Tools installieren? Y/N")
- [ ] SSH-Keys automatisch generieren
- [x] Installation meines Custom Network-Scanners integrieren
