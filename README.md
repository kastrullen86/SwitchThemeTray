# SwitchThemeTray

SwitchThemeTray är ett litet Windows-verktyg som låter dig växla mellan ljus och mörk Windows-tema direkt från systemfältet (system tray).

Applikationen är byggd i PowerShell och kan köras som:

- färdig **EXE** (rekommenderat)
- **BAT**
- **PS1** (för avancerade användare)

---

## ✨ Funktioner

- Växla mellan Light / Dark theme
- Körs diskret i system tray
- Stöd för **tyst körning**
- Ingen installation krävs
- Kan användas som EXE, BAT eller PS1

---

## 🚀 Rekommenderat sätt att använda

För de flesta användare:

➡ **Ladda ner färdig `.exe` från GitHub Releases**  
➡ Dubbelklicka och kör

Ingen PowerShell-konfiguration krävs.

---

## 🔇 Tyst körning

Applikationen kan köras utan synliga fönster.

- **EXE:** körs alltid tyst
- **BAT:** körs tyst
- **PS1:** kan köras både synligt och tyst beroende på hur den startas

> För tyst körning – använd **BAT eller EXE**

---

## 🧑‍💻 Avancerade användare

Detta är för dig som vill:
- köra scriptet manuellt
- anpassa funktionalitet
- bygga egen EXE
- integrera i egna workflows

Du kan då använda:
- `SwitchThemeTray.ps1`
- `SwitchThemeTray.bat`

EXE-filen är **endast ett paketerat lager ovanpå PowerShell-scriptet**.

---

## 🧰 Förutsättningar (endast för utvecklare)

Du behöver detta **endast** om du vill bygga EXE-filen själv.

### Krav
- Windows
- PowerShell 5.1 eller senare
- Git
- PowerShell-modulen **ps2exe**

### Installera ps2exe
```powershell
Install-Module ps2exe -Scope CurrentUser

Vanliga användare kan ignorera detta och använda färdig .exe från Releases.

🏗 Bygg EXE själv

När ps2exe är installerat kan EXE byggas via projektets build-script:

.\build.ps1


Detta:

paketerar PowerShell-scriptet

inkluderar ikon

skapar en fristående .exe

🧩 Projektstruktur (översikt)
/
├─ SwitchThemeTray.ps1      # Huvudlogik
├─ SwitchThemeTray.bat      # Tyst start / wrapper
├─ build.ps1                # Bygger EXE
├─ assets/
│  └─ switchtheme-icon.ico  # Applikationsikon
└─ README.md

🎨 Ikon

Applikationsikonen (assets/switchtheme-icon.ico) är skapad av projektets upphovsman.

© Henrik Jansson

Fri att använda tillsammans med detta projekt

Får inte återanvändas separat utan tillstånd

🔐 Säkerhet & Trust

BAT och PS1 kan kräva justerad Execution Policy i PowerShell

EXE-versionen undviker detta och är därför att föredra för slutanvändare

Inga nätverksanrop eller externa beroenden används vid körning.

📦 Licens

Projektets källkod är fri att använda och modifiera enligt licensen i detta repository.

Ikonen omfattas inte automatiskt av samma rättigheter – se avsnittet Ikon ovan.

💬 Notering

EXE-filen innehåller samma funktionalitet som BAT/PS1 – inget mer, inget mindre.
Skillnaden är paketering och användarvänlighet, inte logik.

🧠 Tips

Vill du automatisera? Använd PS1

Vill du ha tyst autostart? Använd BAT

Vill du ha enkel användning? Använd EXE