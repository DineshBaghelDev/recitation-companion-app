@echo off
echo Starting Sanskrit TTS Server (Meta MMS-TTS)...
echo.
cd /d "%~dp0"
python mms_server.py
pause
