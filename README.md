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
- Ingen bakgrundsprocess utöver tray-appen
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

---

### Installera ps2exe

```Powershell
Install-Module ps2exe -Scope CurrentUser
```

---

Vanliga användare kan ignorera detta och använda färdig .exe från Releases.

🏗 Bygg EXE själv
När ps2exe är installerat kan EXE byggas via:

.\build.ps1
Detta:

paketerar PowerShell-scriptet

inkluderar ikon

signerar EXE (om cert finns)

skapar en fristående .exe

---

```markdown
🧩 Projektstruktur
/
├─ SwitchThemeTray.ps1      # Huvudlogik
├─ SwitchThemeTray.bat      # Tyst start / wrapper
├─ build.ps1                # Bygger + signerar EXE
├─ assets/
│  └─ switchtheme-icon.ico  # Applikationsikon
├─ dist/                    # Genereras vid build (ingår ej i Git)
│  └─ SwitchThemeTray.exe   # Färdig EXE (genereras)
└─ README.md
```

---

🎨 Ikon
Applikationsikonen (assets/switchtheme-icon.ico) är skapad av projektets upphovsman.

© Henrik Jansson

Fri att använda endast tillsammans med detta projekt

Får ej återanvändas separat utan tillstånd

🔐 Säkerhet & Signering
BAT och PS1 kan kräva justerad Execution Policy

EXE-versionen undviker detta och är därför att föredra

EXE:n kan vara självsignerad vid byggnation

Självsignering påverkar inte funktionalitet, endast hur Windows verifierar filen.

📦 Licens
Projektets källkod är fri att använda och modifiera enligt licensen i detta repository.

Ikonen omfattas inte automatiskt av samma rättigheter – se avsnittet Ikon ovan.

💬 Notering
EXE-filen innehåller exakt samma logik som BAT/PS1.
Skillnaden är endast paketering och användarvänlighet.

---

🧠 Tips
Vill du automatisera? → använd PS1

Vill du ha tyst autostart? → använd BAT

Vill du ha enkel användning? → använd EXE

## ✅ 2. CERTIFIERING – VAR & HUR (EN GÅNG)

## Skapa cert (körs **manuellt**, inte i build)
>
> Detta görs en gång per utvecklarmaskin.

---

```powershell
New-SelfSignedCertificate `
  -Type CodeSigning `
  -Subject "CN=SwitchThemeTray" `
  -CertStoreLocation "Cert:\CurrentUser\My"
Detta skapar certifikatet lokalt för din användare.
```
