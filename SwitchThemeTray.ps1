# SwitchThemeTray.ps1
# Ren tray-app – PS1 / BAT / EXE-kompatibel

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- Tema ---
$RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"

function Get-Theme {
    (Get-ItemPropertyValue -Path $RegPath -Name AppsUseLightTheme)
}

function Switch-Theme {
    $new = if ((Get-Theme) -eq 1) { 0 } else { 1 }
    [void](Set-ItemProperty -Path $RegPath -Name AppsUseLightTheme -Value $new) 
}

# --- Ikon-fabrik (PERSISTENT, EXE-safe) ---
function New-ThemeIcon($type) {
    $bmp = New-Object System.Drawing.Bitmap 32,32
    $g   = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = 'AntiAlias'
    $g.Clear([System.Drawing.Color]::Transparent)

    if ($type -eq 'sun') {
        $g.FillEllipse([System.Drawing.Brushes]::Yellow,2,2,28,28)
        $g.DrawEllipse([System.Drawing.Pens]::Orange,1,1,30,30)
    } else {
        $g.FillEllipse([System.Drawing.Brushes]::White,2,2,28,28)
        $g.FillEllipse([System.Drawing.Brushes]::Black,14,0,18,32)
    }

    $icon = [System.Drawing.Icon]::FromHandle($bmp.GetHicon())
    return @{ Bitmap = $bmp; Icon = $icon }
}

$IconLight = New-ThemeIcon "sun"
$IconDark  = New-ThemeIcon "moon"

# --- Tray ---
$notify = New-Object System.Windows.Forms.NotifyIcon
$notify.Visible = $true

function Update-Icon {
    if ((Get-Theme) -eq 1) {
        $notify.Icon = $IconLight.Icon
        $notify.Text = "Tema: Ljust – klicka för mörkt"
    } else {
        $notify.Icon = $IconDark.Icon
        $notify.Text = "Tema: Mörkt – klicka för ljust"
    }
}

Update-Icon

# --- Klicklogik ---
$notify.Add_MouseUp({
    param($s,$e)
    if ($e.Button -eq [System.Windows.Forms.MouseButtons]::Left) {
        Switch-Theme
        Update-Icon
    }
})

# --- Autostart Logik ---
$AppName = "SwitchThemeTray"
$RegRunPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
# Gets the exact path of the running .exe (or .ps1)
$CurrentAppPath = [System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName

function Get-Autostart {
    $val = Get-ItemProperty -Path $RegRunPath -Name $AppName -ErrorAction SilentlyContinue
    return ($null -ne $val.$AppName)
}

function Toggle-Autostart {
    if (Get-Autostart) {
        Remove-ItemProperty -Path $RegRunPath -Name $AppName -ErrorAction SilentlyContinue
    } else {
        # Quotes added around the path to ensure spaces in folders don't break execution
        Set-ItemProperty -Path $RegRunPath -Name $AppName -Value "`"$CurrentAppPath`"" -PropertyType String
    }
    $autostartItem.Checked = (Get-Autostart)
}

# --- Högerklick → meny ---
$menu = New-Object System.Windows.Forms.ContextMenu

# Skapa Autostart-menyvalet
$autostartItem = New-Object System.Windows.Forms.MenuItem "Starta med Windows"
$autostartItem.Checked = (Get-Autostart)
$autostartItem.Add_Click({ Toggle-Autostart })
$menu.MenuItems.Add($autostartItem)

# Skapa Avsluta-menyvalet
$exitItem = New-Object System.Windows.Forms.MenuItem "Avsluta"
$exitItem.Add_Click({
    $notify.Visible = $false
    $notify.Dispose()
    [System.Windows.Forms.Application]::ExitThread()
})
$menu.MenuItems.Add($exitItem)

$notify.ContextMenu = $menu

# --- Message loop ---
[System.Windows.Forms.Application]::Run() | Out-Null
exit 0

# ==========================================
# Build SwitchThemeTray.exe
# ==========================================

$src  = "SwitchThemeTray.ps1"
$out  = "dist\SwitchThemeTray.exe"
$icon = "assets\switchtheme-icon.ico"
$version = "1.0.0"

Write-Host "▶ Bygger SwitchThemeTray v$version"

if (-not (Test-Path $src)) {
    Write-Error "Källfil saknas: $src"
    exit 1
}

if (-not (Get-Command Invoke-ps2exe -ErrorAction SilentlyContinue)) {
    Write-Error "ps2exe är inte installerat. Kör: Install-Module ps2exe"
    exit 1
}

if (-not (Test-Path "dist")) {
    New-Item -ItemType Directory -Path "dist" | Out-Null
}

Invoke-ps2exe `
    -inputFile  $src `
    -outputFile $out `
    -iconFile   $icon `
    -noConsole `
    -noOutput `
    -version    $version

if (-not (Test-Path $out)) {
    Write-Error "❌ EXE skapades inte"
    exit 1
}

# --- Kodsignering (valfri, tyst) ---
$cert = Get-ChildItem Cert:\CurrentUser\My -CodeSigningCert |
        Where-Object { $_.Subject -like "*SwitchThemeTray*" } |
        Select-Object -First 1

if ($cert) {
    Set-AuthenticodeSignature -FilePath $out -Certificate $cert | Out-Null
    Write-Host "✔ EXE signerad"
} else {
    Write-Host "ℹ Ingen kodsignering (cert saknas)"
}

Write-Host "✔ SwitchThemeTray v$version byggd: $out"

@echo off
REM --- Kör tray-appen tyst ---
powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File "%~dp0SwitchThemeTray.ps1"
exit