# ==========================================
# Build SwitchThemeTray.exe
# ==========================================

$src  = "SwitchThemeTray.ps1"
$out  = "dist\SwitchThemeTray.exe"
$icon = "assets\switchtheme-icon.ico"

$version = "1.0.0"

if (-not (Test-Path $src)) {
    Write-Error "Källfil saknas: $src"
    exit 1
}

if (-not (Get-Command Invoke-ps2exe -ErrorAction SilentlyContinue)) {
    Write-Error "ps2exe är inte installerat. Kör: Install-Module ps2exe"
    exit 1
}

Invoke-ps2exe `
    -inputFile  $src `
    -outputFile $out `
    -iconFile   $icon `
    -noConsole `
    -noOutput `
    -version   $version `

if (-not (Test-Path $out)) {
    Write-Error "❌ EXE skapades inte"
    exit 1
}

Write-Host "✔ SwitchThemeTray v$version byggd: $out"