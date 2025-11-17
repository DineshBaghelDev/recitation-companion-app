from typing import List, Optional, Dict
from pydantic import BaseModel


class Translation(BaseModel):
    """Translation model for verse translations."""
    author: str
    text: str


class Verse(BaseModel):
    """Verse model representing a shloka."""
    chapter: int
    verse: int
    slok: str
    transliteration: str
    hindi_translation: Optional[str] = None
    english_translation: Optional[str] = None
    
    class Config:
        json_schema_extra = {
            "example": {
                "chapter": 1,
                "verse": 1,
                "slok": "धृतराष्ट्र उवाच",
                "transliteration": "dhṛtarāṣṭra uvāca",
                "hindi_translation": "धृतराष्ट्र ने कहा...",
                "english_translation": "Dhritarashtra said..."
            }
        }


class ChapterSummary(BaseModel):
    """Summary information about a chapter."""
    chapter_number: int
    name: str
    translation: str
    verses_count: int
    summary: Optional[Dict[str, str]] = None
    
    class Config:
        json_schema_extra = {
            "example": {
                "chapter_number": 1,
                "name": "अर्जुन विषाद योग",
                "translation": "Arjuna's Dilemma",
                "verses_count": 47,
                "summary": {
                    "en": "Chapter 1 describes the scene...",
                    "hi": "अध्याय 1 में दृश्य का वर्णन..."
                }
            }
        }


class ChapterDetail(BaseModel):
    """Detailed information about a chapter including all verses."""
    chapter_number: int
    name: str
    translation: str
    verses_count: int
    summary: Optional[Dict[str, str]] = None
    verses: List[Verse] = []
    
    class Config:
        json_schema_extra = {
            "example": {
                "chapter_number": 1,
                "name": "अर्जुन विषाद योग",
                "translation": "Arjuna's Dilemma",
                "verses_count": 47,
                "summary": {},
                "verses": []
            }
        }


class ErrorResponse(BaseModel):
    """Error response model."""
    detail: str
    status_code: int
    
    class Config:
        json_schema_extra = {
            "example": {
                "detail": "Verse not found",
                "status_code": 404
            }
        }
