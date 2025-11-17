"""
Simplified Sanskrit TTS Server using IndicTTS

This server provides a minimal API for Sanskrit text-to-speech synthesis.
Uses the Vakyansh model architecture with TorchScript for fast inference.

Endpoints:
    GET /tts?text=<sanskrit_text> - Generate Sanskrit audio

Note: The model file (sanskrit_tts.pt) must be present in the same directory.
"""
from fastapi import FastAPI, Query, HTTPException
from fastapi.responses import FileResponse
from fastapi.middleware.cors import CORSMiddleware
import torch
import soundfile as sf
import numpy as np
import os

app = FastAPI(
    title="Sanskrit TTS API",
    description="Authentic Sanskrit pronunciation using Vakyansh TTS model",
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

# Global model instance
model = None
device = "cpu"
MODEL_PATH = "sanskrit_tts.pt"


def load_model():
    """Load the TorchScript TTS model"""
    global model
    if model is None:
        if not os.path.exists(MODEL_PATH):
            raise FileNotFoundError(
                f"Model file '{MODEL_PATH}' not found. "
                f"Please download it from: "
                f"https://storage.googleapis.com/vakyansh-open-models/synthesis/indic-tts-sanskrit/vakyansh-sanskrit-tts.pt"
            )
        
        print(f"Loading Sanskrit TTS model from {MODEL_PATH}...")
        model = torch.jit.load(MODEL_PATH, map_location=device)
        model.eval()
        print("✓ Model loaded successfully")
    return model


def synthesize(text: str, file_path: str):
    """
    Synthesize Sanskrit audio from text
    
    Args:
        text: Sanskrit text in Devanagari script
        file_path: Output WAV file path
    """
    m = load_model()
    
    with torch.no_grad():
        # Forward pass through the model
        audio = m(text)[0].cpu().numpy()
        
        # Normalize audio to prevent clipping
        audio = audio / np.max(np.abs(audio))
        
        # Save as 22kHz WAV file
        sf.write(file_path, audio, 22050)


@app.get("/")
def root():
    """API information"""
    return {
        "service": "Sanskrit TTS API",
        "model": "Vakyansh Sanskrit TTS",
        "status": "online",
        "endpoints": {
            "tts": "/tts?text=<sanskrit_text>",
            "health": "/health"
        },
        "example": "/tts?text=ॐ नमः शिवाय"
    }


@app.get("/health")
def health_check():
    """Health check endpoint"""
    model_exists = os.path.exists(MODEL_PATH)
    model_loaded = model is not None
    
    return {
        "status": "healthy" if model_exists else "model_missing",
        "model_file": MODEL_PATH,
        "model_exists": model_exists,
        "model_loaded": model_loaded,
        "device": device
    }


@app.get("/tts")
def tts(text: str = Query(..., description="Sanskrit text in Devanagari script")):
    """
    Generate Sanskrit audio from text
    
    Args:
        text: Sanskrit text (e.g., "ॐ नमः शिवाय")
    
    Returns:
        WAV audio file
    
    Example:
        GET /tts?text=ॐ नमः शिवाय
    """
    if not text:
        raise HTTPException(status_code=400, detail="Text parameter is required")
    
    try:
        out_file = "out.wav"
        synthesize(text, out_file)
        return FileResponse(
            out_file, 
            media_type="audio/wav",
            headers={
                "Content-Disposition": f'attachment; filename="sanskrit_{hash(text)}.wav"'
            }
        )
    except FileNotFoundError as e:
        raise HTTPException(status_code=500, detail=str(e))
    except Exception as e:
        raise HTTPException(
            status_code=500, 
            detail=f"Audio generation failed: {str(e)}"
        )


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
