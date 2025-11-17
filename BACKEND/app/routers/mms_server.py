"""
Sanskrit TTS Server using Meta MMS-TTS

A minimal, fast, offline Sanskrit text-to-speech service using Meta's
Massively Multilingual Speech (MMS) model with IPA phonetic input.

Features:
- Offline operation (no API keys needed)
- Accurate Sanskrit pronunciation via IPA conversion
- Fast generation (~1-2 seconds)
- Clean WAV audio output
- Simple REST API

Model: facebook/mms-tts-eng (best vocoder for IPA input)
"""
from fastapi import FastAPI, Query
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import Response
from transformers import VitsModel, AutoTokenizer
import soundfile as sf
import torch
from io import BytesIO
import logging

from sanskrit_to_ipa import devanagari_to_ipa

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Model configuration
MODEL_NAME = "facebook/mms-tts-eng"

# Initialize FastAPI app
app = FastAPI(
    title="Sanskrit TTS API",
    description="Meta MMS-TTS powered Sanskrit text-to-speech with IPA phonetics",
    version="2.0.0",
    docs_url="/docs",
    redoc_url="/redoc"
)

# CORS configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Global model instances
tokenizer = None
model = None


def load_model():
    """
    Lazy load the MMS-TTS model.
    Downloads model on first use (~300MB), then caches locally.
    """
    global tokenizer, model
    
    if model is None:
        logger.info(f"Loading MMS-TTS model: {MODEL_NAME}...")
        logger.info("First run will download ~300MB model (one-time only)")
        
        tokenizer = AutoTokenizer.from_pretrained(MODEL_NAME)
        model = VitsModel.from_pretrained(MODEL_NAME)
        model.eval()
        
        logger.info("✓ MMS-TTS model loaded successfully")
    
    return tokenizer, model


@app.on_event("startup")
async def startup_event():
    """Preload model on server startup"""
    logger.info("Starting Sanskrit TTS Server...")
    logger.info("Model will be loaded on first request")


@app.get("/")
def root():
    """API information and endpoints"""
    return {
        "service": "Sanskrit TTS API",
        "model": "Meta MMS-TTS (facebook/mms-tts-eng)",
        "version": "2.0.0",
        "status": "online",
        "features": [
            "Offline operation",
            "IPA-based accurate pronunciation",
            "Fast generation",
            "No API keys required"
        ],
        "endpoints": {
            "tts": "/tts?text=<sanskrit_text>",
            "health": "/health",
            "test_ipa": "/test-ipa?text=<sanskrit_text>"
        },
        "examples": [
            "/tts?text=ॐ नमः शिवाय",
            "/tts?text=नमस्ते",
            "/test-ipa?text=ॐ नमः शिवाय"
        ]
    }


@app.get("/health")
def health_check():
    """Health check endpoint"""
    model_loaded = model is not None
    
    return {
        "status": "healthy",
        "model": MODEL_NAME,
        "model_loaded": model_loaded,
        "device": "cpu",
        "ready": True
    }


@app.get("/test-ipa")
def test_ipa(text: str = Query(..., description="Sanskrit text in Devanagari")):
    """
    Test IPA conversion without generating audio.
    Useful for debugging pronunciation mapping.
    
    Args:
        text: Sanskrit text (e.g., "ॐ नमः शिवाय")
        
    Returns:
        Original text and IPA representation
    """
    ipa = devanagari_to_ipa(text)
    
    return {
        "original": text,
        "ipa": ipa,
        "length": len(ipa)
    }


@app.get("/tts")
def generate_tts(text: str = Query(..., description="Sanskrit text in Devanagari script")):
    """
    Generate Sanskrit speech audio from text.
    
    Process:
    1. Convert Devanagari to IPA phonetics
    2. Generate audio using MMS-TTS model
    3. Return WAV audio file
    
    Args:
        text: Sanskrit text (e.g., "ॐ नमः शिवाय")
        
    Returns:
        WAV audio file (16kHz, mono)
        
    Example:
        GET /tts?text=ॐ नमः शिवाय
    """
    try:
        # Convert to IPA
        ipa_text = devanagari_to_ipa(text)
        logger.info(f"Input: {text}")
        logger.info(f"IPA: {ipa_text}")
        
        # Load model (lazy initialization)
        tok, mdl = load_model()
        
        # Tokenize IPA text
        inputs = tok(text=ipa_text, return_tensors="pt")
        
        # Generate audio
        with torch.no_grad():
            output = mdl(**inputs)
            audio = output.waveform.squeeze().cpu().numpy()
        
        # Convert to WAV bytes
        buffer = BytesIO()
        sf.write(buffer, audio, samplerate=16000, format="WAV")
        wav_bytes = buffer.getvalue()
        
        logger.info(f"✓ Generated {len(wav_bytes)} bytes of audio")
        
        return Response(
            content=wav_bytes,
            media_type="audio/wav",
            headers={
                "Content-Disposition": f'inline; filename="sanskrit_{hash(text)}.wav"'
            }
        )
        
    except Exception as e:
        logger.error(f"TTS generation failed: {str(e)}")
        return Response(
            content=f"Error: {str(e)}",
            status_code=500,
            media_type="text/plain"
        )


if __name__ == "__main__":
    import uvicorn
    
    print("=" * 60)
    print("Sanskrit TTS Server - Meta MMS-TTS")
    print("=" * 60)
    print(f"Model: {MODEL_NAME}")
    print("Starting server on http://0.0.0.0:8000")
    print("Test: http://localhost:8000/tts?text=ॐ नमः शिवाय")
    print("=" * 60)
    
    uvicorn.run(
        app,
        host="0.0.0.0",
        port=8000,
        log_level="info"
    )
