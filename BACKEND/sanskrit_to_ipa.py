"""
Sanskrit Devanagari to Romanization for TTS

Converts Devanagari to simple Latin script romanization
that TTS models can pronounce naturally.
"""


def devanagari_to_ipa(text: str) -> str:
    """
    Convert Devanagari to simple romanization for TTS.
    
    Uses ITRANS-style transliteration which is easier for
    TTS models to pronounce than complex IPA.
    """
    # Simple romanization mapping
    char_map = {
        # Independent vowels
        "अ": "a", "आ": "aa", "इ": "i", "ई": "ee",
        "उ": "u", "ऊ": "oo", "ऋ": "ri",
        "ए": "e", "ऐ": "ai", "ओ": "o", "औ": "au",
        
        # Consonants
        "क": "ka", "ख": "kha", "ग": "ga", "घ": "gha", "ङ": "nga",
        "च": "cha", "छ": "chha", "ज": "ja", "झ": "jha", "ञ": "jna",
        "ट": "ta", "ठ": "tha", "ड": "da", "ढ": "dha", "ण": "na",
        "त": "ta", "थ": "tha", "द": "da", "ध": "dha", "न": "na",
        "प": "pa", "फ": "pha", "ब": "ba", "भ": "bha", "म": "ma",
        "य": "ya", "र": "ra", "ल": "la", "व": "va",
        "श": "sha", "ष": "sha", "स": "sa", "ह": "ha",
        
        # Vowel signs (matras)
        "ा": "aa", "ि": "i", "ी": "ee",
        "ु": "u", "ू": "oo", "ृ": "ri",
        "े": "e", "ै": "ai", "ो": "o", "ौ": "au",
        
        # Special marks
        "ं": "m", "ः": "h", "ँ": "n", "्": "",
        
        # Sacred
        "ॐ": "om",
        
        # Punctuation
        "।": ".", "॥": ".", " ": " ", "\n": " ",
    }
    
    result = []
    i = 0
    
    while i < len(text):
        char = text[i]
        
        if char in char_map:
            base = char_map[char]
            
            # Check if it's a consonant (ends with 'a')
            is_consonant = (base.endswith('a') and len(base) > 1 and 
                          char not in ["अ", "आ", "ा"])
            
            if is_consonant:
                # Look ahead for vowel modifier or halant
                if i + 1 < len(text):
                    next_char = text[i + 1]
                    if next_char == "्":
                        # Halant - remove inherent 'a'
                        result.append(base[:-1])
                        i += 1  # Skip the halant
                    elif next_char in ["ा", "ि", "ी", "ु", "ू", "ृ", "े", "ै", "ो", "ौ"]:
                        # Vowel modifier - remove inherent 'a' and add modifier
                        result.append(base[:-1])
                    else:
                        # Standalone consonant with inherent 'a'
                        result.append(base)
                else:
                    # Last character
                    result.append(base)
            else:
                # Vowel, matra, or special character
                result.append(base)
        else:
            # Unknown - keep as is
            result.append(char)
        
        i += 1
    
    return "".join(result)


if __name__ == "__main__":
    tests = [
        "ॐ नमः शिवाय",
        "धृतराष्ट्र उवाच",
        "नमस्ते",
        "धर्मक्षेत्रे कुरुक्षेत्रे"
    ]
    
    print("Sanskrit Romanization Test")
    print("=" * 50)
    for text in tests:
        rom = devanagari_to_ipa(text)
        print(f"Input:  {text}")
        print(f"Output: {rom}")
        print()
