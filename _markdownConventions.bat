@echo off
setlocal
if "%~1"=="" (
  echo Usage: %~nx0 path\to\file.md
  exit /b 1
)
where ruby >nul 2>&1 || (echo Ruby not found. Install from https://rubyinstaller.org/ & exit /b 1)
set "SCRIPT=%~dp0_markdownConventions.rb"
if not exist "%SCRIPT%" (echo Missing: %SCRIPT% & exit /b 1)
ruby "%SCRIPT%" "%~1"
endlocal
