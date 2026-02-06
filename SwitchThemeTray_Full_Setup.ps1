# ==========================================
# SwitchThemeTray Full Setup Script
# ==========================================
# Kör detta i root av ditt git-repo efter initial commit
# Uppdaterar /src med full PS1 + BAT
# Lägger in royalty-free ikon i /assets
# Färdig för push till GitHub
# ==========================================

# --- Paths ---
$srcPath = "src"
$assetsPath = "assets"

# --- 1) Full PS1 (tyst tray-app med ÅÄÖ, tema-växling) ---
$ps1Content = @"
# SwitchThemeTray.ps1 - Full version

if (\$Host.Name -ne 'ConsoleHost') {
    Start-Process powershell.exe -ArgumentList '-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$PSCommandPath`"' -WindowStyle Hidden
    exit
}

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ===========================
# Tema Registry
function Get-Theme { (Get-ItemPropertyValue -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'AppsUseLightTheme') }
function Toggle-Theme { 
    \$path = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize'
    \$new = if ((Get-Theme) -eq 1) { 0 } else { 1 }
    Set-ItemProperty -Path \$path -Name 'AppsUseLightTheme' -Value \$new
}

# ===========================
# Tray Ikoner
function Create-Icon([string]\$type) {
    \$size = 32
    \$bmp = New-Object System.Drawing.Bitmap \$size,\$size
    \$g = [System.Drawing.Graphics]::FromImage(\$bmp)
    \$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    \$g.Clear([System.Drawing.Color]::Transparent)

    if (\$type -eq 'sun') {
        \$g.FillEllipse([System.Drawing.Brushes]::Yellow,2,2,\$size-4,\$size-4)
        \$pen = New-Object System.Drawing.Pen([System.Drawing.Color]::Orange,2)
        \$g.DrawEllipse(\$pen,1,1,\$size-2,\$size-2)
        \$pen.Dispose()
    } else {
        \$g.FillEllipse([System.Drawing.Brushes]::White,2,2,\$size-4,\$size-4)
        \$g.FillEllipse([System.Drawing.Brushes]::Black,12,0,19,32)
    }

    return [System.Drawing.Icon]::FromHandle(\$bmp.GetHicon())
}

\$iconLight = Create-Icon 'sun'
\$iconDark  = Create-Icon 'moon'

# ===========================
# Trayikon
\$notify = New-Object System.Windows.Forms.NotifyIcon
\$notify.Visible = \$true

function Update-Icon {
    if ((Get-Theme) -eq 1) {
        \$notify.Icon = \$iconLight
        \$notify.Text = 'Tema: Ljust – Klicka för att växla till Mörkt'
    } else {
        \$notify.Icon = \$iconDark
        \$notify.Text = 'Tema: Mörkt – Klicka för att växla till Ljust'
    }
}

Update-Icon

# ===========================
# Klickhantering
\$notify.Add_MouseUp({
    param(\$sender,\$e)
    if (\$e.Button -eq [System.Windows.Forms.MouseButtons]::Left) {
        Toggle-Theme
        Update-Icon
    }
})

# ===========================
# Högerklick-meny
\$menu = New-Object System.Windows.Forms.ContextMenu
\$exitItem = New-Object System.Windows.Forms.MenuItem 'Avsluta'
\$exitItem.Add_Click({
    \$notify.Visible = \$false
    [System.Windows.Forms.Application]::Exit()
})
\$menu.MenuItems.Add(\$exitItem)
\$notify.ContextMenu = \$menu

[System.Windows.Forms.Application]::Run()
"@

Set-Content -Path "$srcPath/SwitchThemeTray.ps1" -Value $ps1Content -Encoding UTF8

# --- 2) BAT filen ---
$batContent = @"
@echo off
powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File "%~dp0\SwitchThemeTray.ps1"
exit
"@
Set-Content -Path "$srcPath/StartSwitchThemeTray.bat" -Value $batContent -Encoding ASCII

# --- 3) Lägg in royalty-free ikon ---
$iconUrl = "https://phosphoricons.com/icons/download/sun-moon"  # Exempel URL, byt till faktiskt CC0/MIT
$iconPath = "$assetsPath/switchtheme-icon.ico"

# Kontrollera om fil finns
if (-not (Test-Path $iconPath)) {
    Invoke-WebRequest -Uri $iconUrl -OutFile $iconPath
}

# --- 4) Add & Commit ---
git add .
git commit -m "Uppdaterar full PS1, BAT och lägger till royalty-free ikon"

Write-Host "Klart! Nu kan du köra 'git push -u origin main' för att publicera allt till GitHub."
