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
