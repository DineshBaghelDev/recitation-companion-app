"""
Text-to-Speech API router.

Provides Sanskrit/Devanagari text-to-speech synthesis using Google TTS
with Hindi language and Indian accent for authentic pronunciation.
"""

from fastapi import APIRouter, HTTPException, Response
from pydantic import BaseModel
from gtts import gTTS
from io import BytesIO
import logging

logger = logging.getLogger(__name__)
router = APIRouter(prefix="/api/v1/tts", tags=["Text-to-Speech"])


class TTSRequest(BaseModel):
    """TTS request model."""
    text: str
    
    class Config:
        json_schema_extra = {"example": {"text": "ॐ नमः शिवाय"}}


@router.post("/generate")
async def generate_speech(request: TTSRequest) -> Response:
    """Generate Sanskrit speech from Devanagari text using Google TTS."""
    if not request.text or len(request.text.strip()) == 0:
        raise HTTPException(status_code=400, detail="Text cannot be empty")
    
    try:
        logger.info(f"TTS request: {request.text[:50]}...")
        
        # Generate speech using Google TTS (Hindi with Indian accent)
        tts = gTTS(text=request.text, lang='hi', slow=False, tld='co.in')
        
        buffer = BytesIO()
        tts.write_to_fp(buffer)
        buffer.seek(0)
        audio_bytes = buffer.getvalue()
        
        logger.info(f"Generated {len(audio_bytes):,} bytes")
        
        return Response(
            content=audio_bytes,
            media_type="audio/mp3",
            headers={
                "Content-Disposition": "inline; filename=tts_output.mp3",
                "Cache-Control": "no-cache"
            }
        )
    except Exception as e:
        logger.error(f"TTS failed: {str(e)}")
        raise HTTPException(status_code=500, detail=f"TTS failed: {str(e)}")


@router.get("/generate")
async def generate_speech_get(text: str) -> Response:
    """Generate Sanskrit speech from text (GET)."""
    return await generate_speech(TTSRequest(text=text))


@router.get("/health")
async def health_check() -> dict:
    """Check TTS service health and configuration."""
    return {
        "status": "healthy",
        "service": "Google Text-to-Speech",
        "language": "Hindi (hi)",
        "accent": "Indian (co.in)",
        "format": "MP3"
    }

