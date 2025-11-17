from fastapi import APIRouter, HTTPException, Path
from typing import List

from ..models.schemas import Verse, ChapterSummary, ChapterDetail
from ..services.vedic_service import vedic_service

router = APIRouter(prefix="/api/v1", tags=["verses"])


@router.get("/slok/{chapter}/{verse}", response_model=Verse, summary="Get specific verse")
async def get_verse(
    chapter: int = Path(..., ge=1, le=18, description="Chapter number (1-18)"),
    verse: int = Path(..., ge=1, description="Verse number")
) -> Verse:
    """
    Get a specific verse from the Bhagavad Gita.
    
    - **chapter**: Chapter number (1-18)
    - **verse**: Verse number within the chapter
    
    Returns the verse with Sanskrit text, transliteration, and translations
    in Hindi (Swami Sivananda) and English (Swami Gambirananda).
    """
    try:
        verse_data = await vedic_service.get_verse(chapter, verse)
        return Verse(**verse_data)
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/slok/{chapter}", response_model=Verse, summary="Get random verse from chapter")
async def get_random_verse(
    chapter: int = Path(..., ge=1, le=18, description="Chapter number (1-18)")
) -> Verse:
    """
    Get a random verse from a specific chapter.
    
    - **chapter**: Chapter number (1-18)
    
    Returns a randomly selected verse from the specified chapter.
    """
    try:
        verse_data = await vedic_service.get_random_verse_from_chapter(chapter)
        return Verse(**verse_data)
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/chapters", response_model=List[ChapterSummary], summary="Get all chapters")
async def get_all_chapters() -> List[ChapterSummary]:
    """
    Get information about all 18 chapters of the Bhagavad Gita.
    
    Returns a list containing chapter summaries with name, translation,
    and verse count for each chapter.
    """
    try:
        chapters_data = await vedic_service.get_all_chapters()
        return [ChapterSummary(**chapter) for chapter in chapters_data]
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/chapter/{chapter}", response_model=ChapterDetail, summary="Get specific chapter")
async def get_chapter(
    chapter: int = Path(..., ge=1, le=18, description="Chapter number (1-18)"),
    include_verses: bool = False
) -> ChapterDetail:
    """
    Get detailed information about a specific chapter.
    
    - **chapter**: Chapter number (1-18)
    - **include_verses**: If true, includes all verses in the chapter (default: false)
    
    Returns chapter details including name, translation, summary, and optionally all verses.
    """
    try:
        if include_verses:
            chapter_data = await vedic_service.get_chapter_with_verses(chapter)
        else:
            chapter_data = await vedic_service.get_chapter(chapter)
            chapter_data["verses"] = []
        
        return ChapterDetail(**chapter_data)
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/verse-of-the-day", response_model=Verse, summary="Get verse of the day")
async def get_verse_of_the_day() -> Verse:
    """
    Get the verse of the day.
    
    Returns a different verse each day based on a deterministic algorithm.
    The same verse is returned for the same calendar day.
    """
    try:
        verse_data = await vedic_service.get_verse_of_the_day()
        return Verse(**verse_data)
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/chapter/{chapter}/verses-count", summary="Get verse count for chapter")
async def get_verses_count(
    chapter: int = Path(..., ge=1, le=18, description="Chapter number (1-18)")
):
    """
    Get the count of verses in a specific chapter.
    
    - **chapter**: Chapter number (1-18)
    
    Returns the verse count along with chapter name and translation.
    """
    try:
        return await vedic_service.get_verses_count(chapter)
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/chapter-names", summary="Get all chapter names")
async def get_all_chapter_names():
    """
    Get names and translations of all 18 chapters.
    
    Returns a lightweight list with chapter names, translations, and verse counts.
    Useful for displaying chapter navigation or selection menus.
    """
    try:
        return await vedic_service.get_all_chapter_names()
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/chapter/{chapter}/summary", summary="Get chapter summary")
async def get_chapter_summary(
    chapter: int = Path(..., ge=1, le=18, description="Chapter number (1-18)")
):
    """
    Get detailed summary of a specific chapter.
    
    - **chapter**: Chapter number (1-18)
    
    Returns chapter summary in both Hindi and English, along with metadata.
    """
    try:
        return await vedic_service.get_chapter_summary(chapter)
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
