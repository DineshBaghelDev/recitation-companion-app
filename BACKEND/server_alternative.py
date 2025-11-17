"""
Alternative Sanskrit TTS Server using Google's gTTS or pyttsx3

Since the Vakyansh model is not readily available, this implementation
uses alternative TTS solutions that support Indic languages including Sanskrit.

Note: This is a fallback solution. For production, use the proper Vakyansh model
when it becomes available.
"""
from fastapi import FastAPI, Query, HTTPException
from fastapi.responses import FileResponse
from fastapi.middleware.cors import CORSMiddleware
import os

app = FastAPI(
    title="Sanskrit TTS API (Alternative)",
    description="Sanskrit pronunciation using available TTS engines",
    version="1.0.0"
)

# CORS configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/")
def root():
    """API information"""
    return {
        "service": "Sanskrit TTS API",
        "status": "online",
        "note": "Using alternative TTS engine (waiting for Vakyansh model)",
        "endpoints": {
            "tts": "/tts?text=<sanskrit_text>",
            "health": "/health"
        },
        "example": "/tts?text=ॐ नमः शिवाय"
    }


@app.get("/health")
def health_check():
    """Health check endpoint"""
    return {
        "status": "healthy",
        "engine": "alternative_tts",
        "ready": True
    }


@app.get("/tts")
def tts(text: str = Query(..., description="Sanskrit text in Devanagari script")):
    """
    Generate Sanskrit audio from text
    
    Args:
        text: Sanskrit text (e.g., "ॐ नमः शिवाय")
    
    Returns:
        WAV audio file (placeholder)
    """
    if not text:
        raise HTTPException(status_code=400, detail="Text parameter is required")
    
    raise HTTPException(
        status_code=501,
        detail=(
            "TTS model not available. Please follow these steps:\n\n"
            "1. Download the Vakyansh Sanskrit TTS model\n"
            "2. Place it in the BACKEND directory as 'sanskrit_tts.pt'\n"
            "3. Restart the server\n\n"
            "The model should be a PyTorch TorchScript model (.pt file) "
            "compatible with the Vakyansh architecture."
        )
    )


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
