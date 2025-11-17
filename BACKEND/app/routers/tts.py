"""
Text-to-Speech (TTS) router using Meta MMS-TTS model.

Provides Sanskrit TTS using Meta's MMS model with IPA phonetics.
"""

from fastapi import APIRouter, HTTPException, Response
from pydantic import BaseModel
from transformers import VitsModel, AutoTokenizer
import soundfile as sf
import torch
from io import BytesIO
from typing import Optional
import logging
import sys
from pathlib import Path

# Add BACKEND directory to path
backend_dir = Path(__file__).parent.parent.parent
sys.path.insert(0, str(backend_dir))
from sanskrit_to_ipa import devanagari_to_ipa

logger = logging.getLogger(__name__)
router = APIRouter(prefix="/api/v1/tts", tags=["tts"])

MODEL_NAME = "facebook/mms-tts-eng"
_tokenizer: Optional[object] = None
_model: Optional[object] = None
_model_loaded: bool = False


def get_tts_model():
    """Load and cache MMS-TTS model."""
    global _tokenizer, _model, _model_loaded
    
    if not _model_loaded:
        try:
            logger.info(f"Loading MMS-TTS model: {MODEL_NAME}...")
            _tokenizer = AutoTokenizer.from_pretrained(MODEL_NAME)
            _model = VitsModel.from_pretrained(MODEL_NAME)
            _model.eval()
            _model_loaded = True
            logger.info("✓ MMS-TTS model loaded")
        except Exception as e:
            logger.error(f"✗ Error loading MMS-TTS model: {e}")
            raise HTTPException(
                status_code=500,
                detail=f"Failed to load MMS-TTS model: {str(e)}"
            )
    
    return _tokenizer, _model


class TTSRequest(BaseModel):
    """TTS request model."""
    text: str
    
    class Config:
        json_schema_extra = {"example": {"text": "ॐ नमः शिवाय"}}


@router.post("/generate")
async def generate_speech(request: TTSRequest) -> Response:
    """Generate Sanskrit speech from text (POST)."""
    if not request.text or len(request.text.strip()) == 0:
        raise HTTPException(status_code=400, detail="Text cannot be empty")
    
    try:
        ipa_text = devanagari_to_ipa(request.text)
        logger.info(f"Input: {request.text[:50]}...")
        logger.info(f"IPA: {ipa_text[:50]}...")
        
        tokenizer, model = get_tts_model()
        inputs = tokenizer(text=ipa_text, return_tensors="pt")
        
        with torch.no_grad():
            output = model(**inputs)
            audio = output.waveform.squeeze().cpu().numpy()
        
        buffer = BytesIO()
        sf.write(buffer, audio, samplerate=16000, format="WAV")
        wav_bytes = buffer.getvalue()
        
        logger.info(f"✓ Generated {len(wav_bytes)} bytes")
        
        return Response(
            content=wav_bytes,
            media_type="audio/wav",
            headers={
                "Content-Disposition": "inline; filename=sanskrit_tts.wav",
                "Cache-Control": "no-cache"
            }
        )
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"TTS failed: {str(e)}")
        raise HTTPException(status_code=500, detail=f"TTS failed: {str(e)}")


@router.get("/generate")
async def generate_speech_get(text: str) -> Response:
    """Generate Sanskrit speech from text (GET)."""
    return await generate_speech(TTSRequest(text=text))


@router.get("/health")
async def health_check() -> dict:
    """Check TTS service health."""
    return {
        "status": "healthy",
        "model": "Meta MMS-TTS (facebook/mms-tts-eng)",
        "loaded": _model_loaded,
        "ready": True
    }
