@echo off
echo ========================================
echo Recitation Companion Backend Server
echo ========================================
echo.

cd /d "%~dp0"

REM Check Python installation
python --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python is not installed or not in PATH
    pause
    exit /b 1
)

REM Check required packages
echo Checking dependencies...
pip show fastapi >nul 2>&1
if errorlevel 1 (
    echo ERROR: FastAPI not installed
    echo Please run: pip install -r requirements.txt
    pause
    exit /b 1
)

echo.
echo Starting FastAPI server...
echo Server: http://localhost:8000
echo API Docs: http://localhost:8000/docs
echo.
echo Press Ctrl+C to stop the server
echo ========================================
echo.

python -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
