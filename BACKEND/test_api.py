"""Test script to verify API endpoints."""
import asyncio
import httpx


async def test_endpoints():
    """Test all API endpoints."""
    base_url = "http://localhost:8000"
    
    async with httpx.AsyncClient(timeout=30.0) as client:
        print("🧪 Testing Recitation Companion API\n")
        
        # Test 1: Health check
        print("1. Testing health check...")
        response = await client.get(f"{base_url}/health")
        print(f"   Status: {response.status_code}")
        print(f"   Response: {response.json()}\n")
        
        # Test 2: Root endpoint
        print("2. Testing root endpoint...")
        response = await client.get(f"{base_url}/")
        print(f"   Status: {response.status_code}")
        print(f"   Response: {response.json()}\n")
        
        # Test 3: Get specific verse (Chapter 2, Verse 47 - Famous karma yoga verse)
        print("3. Testing specific verse (Chapter 2, Verse 47 - Karma Yoga)...")
        response = await client.get(f"{base_url}/api/v1/slok/2/47")
        print(f"   Status: {response.status_code}")
        if response.status_code == 200:
            data = response.json()
            print(f"   Chapter: {data.get('chapter')}, Verse: {data.get('verse')}")
            print(f"   Slok: {data.get('slok')[:80]}...")
            print(f"   Has Hindi: {bool(data.get('hindi_translation'))}")
            print(f"   Has English: {bool(data.get('english_translation'))}")
            if data.get('hindi_translation'):
                print(f"   Hindi preview: {data.get('hindi_translation')[:60]}...")
            if data.get('english_translation'):
                print(f"   English preview: {data.get('english_translation')[:80]}...\n")
        else:
            print(f"   Error: {response.text}\n")
        
        # Test 4: Get random verse from chapter 2
        print("4. Testing random verse (Chapter 2)...")
        response = await client.get(f"{base_url}/api/v1/slok/2")
        print(f"   Status: {response.status_code}")
        if response.status_code == 200:
            data = response.json()
            print(f"   Got verse {data.get('verse')} from chapter {data.get('chapter')}\n")
        else:
            print(f"   Error: {response.text}\n")
        
        # Test 5: Get all chapters
        print("5. Testing all chapters...")
        response = await client.get(f"{base_url}/api/v1/chapters")
        print(f"   Status: {response.status_code}")
        if response.status_code == 200:
            chapters = response.json()
            print(f"   Total chapters: {len(chapters)}")
            if chapters:
                print(f"   First chapter: {chapters[0].get('name')}\n")
        else:
            print(f"   Error: {response.text}\n")
        
        # Test 6: Get specific chapter
        print("6. Testing specific chapter (Chapter 1)...")
        response = await client.get(f"{base_url}/api/v1/chapter/1")
        print(f"   Status: {response.status_code}")
        if response.status_code == 200:
            data = response.json()
            print(f"   Name: {data.get('name')}")
            print(f"   Translation: {data.get('translation')}")
            print(f"   Verses count: {data.get('verses_count')}\n")
        else:
            print(f"   Error: {response.text}\n")
        
        # Test 7: Get verse of the day
        print("7. Testing verse of the day...")
        response = await client.get(f"{base_url}/api/v1/verse-of-the-day")
        print(f"   Status: {response.status_code}")
        if response.status_code == 200:
            data = response.json()
            print(f"   Today's verse: Chapter {data.get('chapter')}, Verse {data.get('verse')}")
            print(f"   Date: {data.get('date', 'N/A')}")
            print(f"   Slok preview: {data.get('slok', '')[:60]}...\n")
        else:
            print(f"   Error: {response.text}\n")
        
        # Test 8: Get verses count for a chapter
        print("8. Testing verses count (Chapter 2)...")
        response = await client.get(f"{base_url}/api/v1/chapter/2/verses-count")
        print(f"   Status: {response.status_code}")
        if response.status_code == 200:
            data = response.json()
            print(f"   Chapter {data.get('chapter')}: {data.get('verses_count')} verses")
            print(f"   Name: {data.get('chapter_name')}\n")
        else:
            print(f"   Error: {response.text}\n")
        
        # Test 9: Get all chapter names
        print("9. Testing all chapter names...")
        response = await client.get(f"{base_url}/api/v1/chapter-names")
        print(f"   Status: {response.status_code}")
        if response.status_code == 200:
            chapters = response.json()
            print(f"   Total chapters: {len(chapters)}")
            if len(chapters) >= 3:
                print(f"   Chapter 1: {chapters[0].get('name')} ({chapters[0].get('translation')})")
                print(f"   Chapter 2: {chapters[1].get('name')} ({chapters[1].get('translation')})")
                print(f"   Chapter 18: {chapters[17].get('name')} ({chapters[17].get('translation')})\n")
        else:
            print(f"   Error: {response.text}\n")
        
        # Test 10: Get chapter summary
        print("10. Testing chapter summary (Chapter 1)...")
        response = await client.get(f"{base_url}/api/v1/chapter/1/summary")
        print(f"   Status: {response.status_code}")
        if response.status_code == 200:
            data = response.json()
            print(f"   Chapter: {data.get('name')} ({data.get('translation')})")
            print(f"   Verses: {data.get('verses_count')}")
            has_hindi = bool(data.get('summary_hindi'))
            has_english = bool(data.get('summary_english'))
            print(f"   Has Hindi summary: {has_hindi}")
            print(f"   Has English summary: {has_english}")
            if has_english:
                summary = data.get('summary_english', '')
                print(f"   English preview: {summary[:100]}...\n")
        else:
            print(f"   Error: {response.text}\n")
        
        print("✅ All tests completed!")


if __name__ == "__main__":
    asyncio.run(test_endpoints())
