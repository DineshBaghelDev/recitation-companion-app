"""Debug script to inspect the Vedic Scriptures API response structure."""
import asyncio
import httpx
import json


async def inspect_api():
    """Inspect the actual API response."""
    url = "https://vedicscriptures.github.io/slok/1/1/"
    
    async with httpx.AsyncClient(timeout=30.0, follow_redirects=True) as client:
        response = await client.get(url)
        response.encoding = 'utf-8'
        data = response.json()
        
        print("=" * 60)
        print("FULL API RESPONSE:")
        print("=" * 60)
        print(json.dumps(data, indent=2, ensure_ascii=False))
        print("\n" + "=" * 60)
        print("AVAILABLE FIELDS:")
        print("=" * 60)
        for key in data.keys():
            print(f"  - {key}: {type(data[key]).__name__}")
        
        if 'translations' in data:
            print("\n" + "=" * 60)
            print("TRANSLATIONS STRUCTURE:")
            print("=" * 60)
            for i, trans in enumerate(data['translations']):
                print(f"\nTranslation {i+1}:")
                for key, value in trans.items():
                    if key == 'description':
                        print(f"  {key}: {value[:100]}..." if len(str(value)) > 100 else f"  {key}: {value}")
                    else:
                        print(f"  {key}: {value}")


if __name__ == "__main__":
    asyncio.run(inspect_api())
