@echo off
echo Starting Recitation Companion API Server...
echo.
cd /d "%~dp0"
python -m app.main
pause
