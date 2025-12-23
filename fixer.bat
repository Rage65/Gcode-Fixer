@echo off
setlocal enabledelayedexpansion
echo By: Daniel Branch 
timeout /t 1 /nobreak > nul
set "ext=%~x1"
set "ext=!ext:~1!"
set "ext=!ext:.=!"
set "file=%~1"
powershell -NoProfile -ExecutionPolicy Bypass -Command "& '%USERPROFILE%\Documents\fixer.ps1' -file '%~1'"
