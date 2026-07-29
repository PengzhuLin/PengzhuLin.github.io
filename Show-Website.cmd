@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\Set-WebsiteVisibility.ps1" -Mode public -Deploy
pause
