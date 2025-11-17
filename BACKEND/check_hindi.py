"""Check which author has Hindi translation."""
import asyncio
import httpx

async def check():
    url = "https://vedicscriptures.github.io/slok/2/47/"
    async with httpx.AsyncClient(follow_redirects=True) as client:
        response = await client.get(url)
        response.encoding = 'utf-8'
        data = response.json()
        
        print("Checking author fields for Hindi (ht) text:\n")
        
        authors_with_hindi = []
        for author_key, author_data in data.items():
            if isinstance(author_data, dict) and 'ht' in author_data:
                text = author_data['ht']
                if text and len(text) > 0:
                    authors_with_hindi.append(author_key)
                    print(f"{author_key} (author: {author_data.get('author', 'N/A')})")
                    print(f"  Has 'ht': YES - Length: {len(text)}")
                    print(f"  Preview: {text[:100]}...\n")
        
        print(f"\nAuthors with Hindi text: {', '.join(authors_with_hindi)}")
        
        # Check Swami Sivananda
        siva_data = data.get('siva', {})
        print(f"\nSwami Sivananda (siva) fields: {list(siva_data.keys())}")

asyncio.run(check())
