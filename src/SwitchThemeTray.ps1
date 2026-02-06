# SwitchThemeTray.ps1 - Full version

if (\System.Management.Automation.Internal.Host.InternalHost.Name -ne 'ConsoleHost') {
    Start-Process powershell.exe -ArgumentList '-WindowStyle Hidden -ExecutionPolicy Bypass -File "C:\Users\zkviz\source\repos\SwitchThemeTray\SwitchThemeTray\SwitchThemeTray_Full_Setup.ps1"' -WindowStyle Hidden
    exit
}

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ===========================
# Tema Registry
function Get-Theme { (Get-ItemPropertyValue -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'AppsUseLightTheme') }
function Toggle-Theme { 
    \ = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize'
    \ = if ((Get-Theme) -eq 1) { 0 } else { 1 }
    Set-ItemProperty -Path \ -Name 'AppsUseLightTheme' -Value \
}

# ===========================
# Tray Ikoner
function Create-Icon([string]\) {
    \ = 32
    \ = New-Object System.Drawing.Bitmap \,\
    \ = [System.Drawing.Graphics]::FromImage(\)
    \.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    \.Clear([System.Drawing.Color]::Transparent)

    if (\ -eq 'sun') {
        \.FillEllipse([System.Drawing.Brushes]::Yellow,2,2,\-4,\-4)
        \ = New-Object System.Drawing.Pen([System.Drawing.Color]::Orange,2)
        \.DrawEllipse(\,1,1,\-2,\-2)
        \.Dispose()
    } else {
        \.FillEllipse([System.Drawing.Brushes]::White,2,2,\-4,\-4)
        \.FillEllipse([System.Drawing.Brushes]::Black,12,0,19,32)
    }

    return [System.Drawing.Icon]::FromHandle(\.GetHicon())
}

\ = Create-Icon 'sun'
\  = Create-Icon 'moon'

# ===========================
# Trayikon
\ = New-Object System.Windows.Forms.NotifyIcon
\.Visible = \True

function Update-Icon {
    if ((Get-Theme) -eq 1) {
        \.Icon = \
        \.Text = 'Tema: Ljust – Klicka för att växla till Mörkt'
    } else {
        \.Icon = \
        \.Text = 'Tema: Mörkt – Klicka för att växla till Ljust'
    }
}

Update-Icon

# ===========================
# Klickhantering
\.Add_MouseUp({
    param(\,\)
    if (\.Button -eq [System.Windows.Forms.MouseButtons]::Left) {
        Toggle-Theme
        Update-Icon
    }
})

# ===========================
# Högerklick-meny
\ = New-Object System.Windows.Forms.ContextMenu
\ = New-Object System.Windows.Forms.MenuItem 'Avsluta'
\.Add_Click({
    \.Visible = \False
    [System.Windows.Forms.Application]::Exit()
})
\.MenuItems.Add(\)
\.ContextMenu = \

[System.Windows.Forms.Application]::Run()
