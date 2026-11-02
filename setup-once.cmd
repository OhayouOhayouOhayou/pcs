@echo off
rem One-time setup: publishes the fixed-link repo on GitHub and starts both staging systems at logon.
title Staging links - one-time setup
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0setup-once.ps1"
pause
