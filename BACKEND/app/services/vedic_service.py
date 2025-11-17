import asyncio
import httpx
import random
from typing import List, Optional, Dict, Any
from fastapi import HTTPException

from ..config import settings


class VedicScripturesService:
    """Service to interact with Vedic Scriptures GitHub API."""
    
    def __init__(self):
        self.base_url = settings.vedic_api_base_url
        self.timeout = 30.0
    
    async def _fetch_json(self, endpoint: str) -> Any:
        """Fetch JSON data from the API."""
        # Ensure endpoint ends with trailing slash (required by GitHub Pages)
        if not endpoint.endswith('/'):
            endpoint = f"{endpoint}/"
        
        url = f"{self.base_url}{endpoint}"
        
        async with httpx.AsyncClient(timeout=self.timeout, follow_redirects=True) as client:
            try:
                response = await client.get(url)
                response.raise_for_status()
                response.encoding = 'utf-8'  # Ensure proper UTF-8 decoding
                return response.json()
            except httpx.HTTPStatusError as e:
                raise HTTPException(
                    status_code=e.response.status_code,
                    detail=f"Failed to fetch data from Vedic Scriptures API: {str(e)}"
                )
            except httpx.RequestError as e:
                raise HTTPException(
                    status_code=503,
                    detail=f"Service unavailable: {str(e)}"
                )
            except Exception as e:
                raise HTTPException(
                    status_code=500,
                    detail=f"Unexpected error: {str(e)}"
                )
    
    def _extract_translation(self, data: Dict, author_key: str, text_key: str) -> Optional[str]:
        """Extract translation text for a specific author from nested structure."""
        author_data = data.get(author_key, {})
        if isinstance(author_data, dict):
            return author_data.get(text_key, "")
        return None
    
    async def get_verse(self, chapter: int, verse: int) -> Dict[str, Any]:
        """
        Get a specific verse from a chapter.
        
        Args:
            chapter: Chapter number (1-18)
            verse: Verse number
            
        Returns:
            Dict containing verse data with Hindi and English translations
        """
        endpoint = f"/slok/{chapter}/{verse}"
        data = await self._fetch_json(endpoint)
        
        # Extract translations from nested structure
        # Hindi: Swami Ramsukhdas (rams.ht key)
        # English: Swami Gambirananda (gambir.et key)
        hindi_translation = self._extract_translation(data, "rams", "ht")
        english_translation = self._extract_translation(data, "gambir", "et")
        
        return {
            "chapter": chapter,
            "verse": verse,
            "slok": data.get("slok", ""),
            "transliteration": data.get("transliteration", ""),
            "hindi_translation": hindi_translation,
            "english_translation": english_translation
        }
    
    async def get_random_verse_from_chapter(self, chapter: int) -> Dict[str, Any]:
        """
        Get a random verse from a specific chapter.
        
        Args:
            chapter: Chapter number (1-18)
            
        Returns:
            Dict containing random verse data
        """
        # First, get chapter info to know verse count
        chapter_data = await self.get_chapter(chapter)
        verses_count = chapter_data.get("verses_count", 1)
        
        # Generate random verse number
        random_verse = random.randint(1, verses_count)
        
        # Fetch that verse
        return await self.get_verse(chapter, random_verse)
    
    async def get_all_chapters(self) -> List[Dict[str, Any]]:
        """
        Get information about all chapters (optimized with concurrent requests).
        
        Returns:
            List of chapter summaries
        """
        # Fetch all chapters concurrently instead of sequentially
        async def fetch_chapter_summary(chapter_num: int) -> Optional[Dict[str, Any]]:
            try:
                chapter_data = await self.get_chapter(chapter_num)
                return {
                    "chapter_number": chapter_num,
                    "name": chapter_data.get("name", ""),
                    "translation": chapter_data.get("translation", ""),
                    "verses_count": chapter_data.get("verses_count", 0),
                    "summary": chapter_data.get("summary", {})
                }
            except HTTPException:
                return None
        
        # Run all 18 chapter requests concurrently
        tasks = [fetch_chapter_summary(ch) for ch in range(1, 19)]
        results = await asyncio.gather(*tasks)
        
        # Filter out None values (failed requests)
        return [chapter for chapter in results if chapter is not None]
    
    async def get_chapter(self, chapter: int) -> Dict[str, Any]:
        """
        Get detailed information about a specific chapter.
        
        Args:
            chapter: Chapter number (1-18)
            
        Returns:
            Dict containing chapter details
        """
        endpoint = f"/chapter/{chapter}"
        data = await self._fetch_json(endpoint)
        
        return {
            "chapter_number": chapter,
            "name": data.get("name", ""),
            "translation": data.get("translation", ""),
            "verses_count": data.get("verses_count", 0),
            "summary": data.get("summary", {}),
        }
    
    async def get_chapter_with_verses(self, chapter: int) -> Dict[str, Any]:
        """
        Get chapter information along with all its verses (optimized with concurrent requests).
        
        Args:
            chapter: Chapter number (1-18)
            
        Returns:
            Dict containing chapter details and all verses
        """
        chapter_data = await self.get_chapter(chapter)
        verses_count = chapter_data.get("verses_count", 0)
        
        # Fetch all verses concurrently instead of sequentially
        async def fetch_verse(verse_num: int) -> Optional[Dict[str, Any]]:
            try:
                return await self.get_verse(chapter, verse_num)
            except HTTPException:
                return None
        
        # Run all verse requests concurrently
        tasks = [fetch_verse(v) for v in range(1, verses_count + 1)]
        results = await asyncio.gather(*tasks)
        
        # Filter out None values and maintain order
        verses = [verse for verse in results if verse is not None]
        
        chapter_data["verses"] = verses
        return chapter_data
    
    async def get_verse_of_the_day(self) -> Dict[str, Any]:
        """
        Get verse of the day based on current date.
        
        Uses a deterministic algorithm based on date to select a verse,
        ensuring the same verse is returned for the same day.
        
        Returns:
            Dict containing verse data for today
        """
        from datetime import datetime
        
        # Use current date as seed for deterministic selection
        today = datetime.now()
        day_of_year = today.timetuple().tm_yday  # 1-365/366
        
        # Total verses in Bhagavad Gita: 700
        # We'll cycle through all chapters proportionally
        # Simple algorithm: use day_of_year modulo total verses
        
        # Chapter verse counts (Bhagavad Gita)
        chapter_verses = {
            1: 47, 2: 72, 3: 43, 4: 42, 5: 29, 6: 47,
            7: 30, 8: 28, 9: 34, 10: 42, 11: 55, 12: 20,
            13: 35, 14: 27, 15: 20, 16: 24, 17: 28, 18: 78
        }
        
        total_verses = sum(chapter_verses.values())  # 700
        verse_index = day_of_year % total_verses
        
        # Find which chapter and verse this index corresponds to
        cumulative = 0
        selected_chapter = 1
        selected_verse = 1
        
        for ch, count in chapter_verses.items():
            if verse_index < cumulative + count:
                selected_chapter = ch
                selected_verse = verse_index - cumulative + 1
                break
            cumulative += count
        
        # Fetch the verse
        verse_data = await self.get_verse(selected_chapter, selected_verse)
        verse_data["verse_of_the_day"] = True
        verse_data["date"] = today.strftime("%Y-%m-%d")
        
        return verse_data
    
    async def get_verses_count(self, chapter: int) -> Dict[str, Any]:
        """
        Get the count of verses in a specific chapter.
        
        Args:
            chapter: Chapter number (1-18)
            
        Returns:
            Dict containing chapter number and verse count
        """
        chapter_data = await self.get_chapter(chapter)
        
        return {
            "chapter": chapter,
            "verses_count": chapter_data.get("verses_count", 0),
            "chapter_name": chapter_data.get("name", ""),
            "chapter_translation": chapter_data.get("translation", "")
        }
    
    async def get_all_chapter_names(self) -> List[Dict[str, Any]]:
        """
        Get names and translations of all chapters (optimized with concurrent requests).
        
        Returns:
            List of dicts containing chapter names and translations
        """
        # Fetch all chapters concurrently
        async def fetch_chapter_info(chapter_num: int) -> Optional[Dict[str, Any]]:
            try:
                chapter_data = await self.get_chapter(chapter_num)
                return {
                    "chapter_number": chapter_num,
                    "name": chapter_data.get("name", ""),
                    "translation": chapter_data.get("translation", ""),
                    "verses_count": chapter_data.get("verses_count", 0)
                }
            except HTTPException:
                return None
        
        # Run all 18 chapter requests concurrently
        tasks = [fetch_chapter_info(ch) for ch in range(1, 19)]
        results = await asyncio.gather(*tasks)
        
        # Filter out None values
        return [chapter for chapter in results if chapter is not None]
    
    async def get_chapter_summary(self, chapter: int) -> Dict[str, Any]:
        """
        Get detailed summary of a specific chapter.
        
        Args:
            chapter: Chapter number (1-18)
            
        Returns:
            Dict containing chapter summary and metadata
        """
        chapter_data = await self.get_chapter(chapter)
        
        return {
            "chapter_number": chapter,
            "name": chapter_data.get("name", ""),
            "translation": chapter_data.get("translation", ""),
            "verses_count": chapter_data.get("verses_count", 0),
            "summary": chapter_data.get("summary", {}),
            "summary_hindi": chapter_data.get("summary", {}).get("hi", ""),
            "summary_english": chapter_data.get("summary", {}).get("en", "")
        }


# Singleton instance
vedic_service = VedicScripturesService()
