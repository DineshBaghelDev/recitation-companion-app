@echo off
echo ========================================
echo Installing Vakyansh Sanskrit TTS
echo ========================================
echo.

echo Step 1: Installing PyTorch (CPU version)...
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

echo.
echo Step 2: Installing Coqui TTS...
pip install TTS

echo.
echo Step 3: Installing other dependencies...
pip install fastapi uvicorn httpx pydantic pydantic-settings python-dotenv

echo.
echo ========================================
echo Installation complete!
echo ========================================
echo.
echo To start the server, run:
echo python -m uvicorn app.main:app --reload
echo.
pause
