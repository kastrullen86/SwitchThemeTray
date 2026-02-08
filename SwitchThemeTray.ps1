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
# --- Högerklick → meny ---
$menu = New-Object System.Windows.Forms.ContextMenu
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