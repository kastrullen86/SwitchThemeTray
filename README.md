# SwitchThemeTray

> En modern Windows tray-app för att växla mellan ljust och mörkt systemtema.

## Funktioner

- 🔄 **Vänsterklick:** Växla mellan ljust / mörkt tema  
- ☰ **Högerklick:** Visar meny (Avsluta) – tema ändras **inte**  
- 🖥️ **Tyst körning:** Ingen PowerShell-ruta visas  
- 🔤 **ÅÄÖ:** Tooltips och meny visar svenska tecken korrekt  
- 📌 **Autostart:** Startar automatiskt med Windows utan dubbletter  
- 💡 **EXE-kompatibel:** Kan kompileras till `.exe` för enkel distribution  
- 🛠️ **Open Source:** MIT-licens

## Installation

### PowerShell / Script-läge
1. Kör `src/StartSwitchThemeTray.bat`
2. Appen startar tyst och visas i system tray

### EXE-läge (rekommenderat)
- Bygg `.exe` via PS2EXE (se `build/`)
- Kör exe – fungerar som vanlig Windows-app

## Projektstruktur

```text
SwitchThemeTray/
├── src/        # PS1 + BAT
├── assets/     # Ikoner
├── build/      # Build / PS2EXE
├── dist/       # Färdig exe
├── README.md
├── LICENSE
├── .gitignore