@echo off
REM --- Kör tray-appen tyst ---
powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File "%~dp0SwitchThemeTray.ps1"
exit
