@echo off
echo ============================================================
echo  Recitation Companion Backend Server (with MMS-TTS)
echo ============================================================
echo.
cd /d "%~dp0"
python -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
pause
