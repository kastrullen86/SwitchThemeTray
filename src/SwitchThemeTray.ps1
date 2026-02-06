# --- Tyst start om körs via dubbelklick ---
if ($Host.Name -ne 'ConsoleHost') {
    Start-Process powershell.exe -ArgumentList "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -WindowStyle Hidden
    exit
}

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- Startup: kopiera .bat till startup om inte redan finns ---
$batFile = Join-Path $PSScriptRoot "StartSwitchThemeTray.bat"
$startupBat = Join-Path $env:APPDATA "Microsoft\Windows\Start Menu\Programs\Startup\StartSwitchThemeTray.bat"
if (-not (Test-Path $startupBat)) {
    Copy-Item $batFile $startupBat
}

# --- Tema-funktioner ---
function Get-Theme {
    $RegistryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
    return Get-ItemPropertyValue -Path $RegistryPath -Name "AppsUseLightTheme"
}

function Toggle-Theme {
    $RegistryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
    $new = if ((Get-Theme) -eq 1) {0} else {1}
    Set-ItemProperty -Path $RegistryPath -Name "AppsUseLightTheme" -Value $new
}

# --- Skapa ikoner ---
function Create-Icon([string]$type) {
    $size = 32
    $bmp = New-Object System.Drawing.Bitmap $size,$size
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.Clear([System.Drawing.Color]::Transparent)

    if ($type -eq "sun") {
        $g.FillEllipse([System.Drawing.Brushes]::Yellow,2,2,$size-4,$size-4)
        $pen = New-Object System.Drawing.Pen([System.Drawing.Color]::Orange,2)
        $g.DrawEllipse($pen,1,1,$size-2,$size-2)
        $pen.Dispose()
    } else {
        $g.FillEllipse([System.Drawing.Brushes]::White,2,2,$size-4,$size-4)
        $g.FillEllipse([System.Drawing.Brushes]::Black,12,0,19,32)
    }
    return [System.Drawing.Icon]::FromHandle($bmp.GetHicon())
}

$iconLight = Create-Icon "sun"
$iconDark  = Create-Icon "moon"

# --- Trayikon ---
$notify = New-Object System.Windows.Forms.NotifyIcon
$notify.Visible = $true

function Update-Icon {
    if ((Get-Theme) -eq 1) {
        $notify.Icon = $iconLight
        $notify.Text = "Tema: Ljust - Klicka för att växla till Mörkt"
    } else {
        $notify.Icon = $iconDark
        $notify.Text = "Tema: Mörkt - Klicka för att växla till Ljust"
    }
}

Update-Icon

# --- MouseClick: vänster = toggle, höger = bara meny ---
$notify.Add_MouseUp({
    param($sender,$e)
    if ($e.Button -eq [System.Windows.Forms.MouseButtons]::Left) {
        # Glow-animation
        for ($i=0; $i -le 50; $i+=10) {
            if ((Get-Theme) -eq 1) { $notify.Icon = Create-Icon "sun" }
            else { $notify.Icon = Create-Icon "moon" }
            Start-Sleep -Milliseconds 20
        }
        Toggle-Theme
        Update-Icon
    }
})

# --- Högerklick → Avsluta ---
$contextMenu = New-Object System.Windows.Forms.ContextMenu
$exitMenu = New-Object System.Windows.Forms.MenuItem "Avsluta"
$exitMenu.Add_Click({
    $notify.Visible = $false
    [System.Windows.Forms.Application]::Exit()
})
$contextMenu.MenuItems.Add($exitMenu)
$notify.ContextMenu = $contextMenu

# --- Starta GUI-tråd ---
[System.Windows.Forms.Application]::Run()
