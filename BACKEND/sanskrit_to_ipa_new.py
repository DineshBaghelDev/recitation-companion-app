"""
Sanskrit Devanagari to IPA Converter

Simple but effective converter for Sanskrit TTS.
Maps Devanagari characters directly to IPA phonemes.
"""


def devanagari_to_ipa(text: str) -> str:
    """
    Convert Devanagari to IPA with simple character mapping.
    
    Note: This is a simplified approach. For perfect results, a full
    phonological analyzer would be needed to handle all conjuncts.
    """
    # Direct character-to-IPA mapping
    char_map = {
        # Independent vowels
        "अ": "ə", "आ": "aː", "इ": "i", "ई": "iː",
        "उ": "u", "ऊ": "uː", "ऋ": "ri",
        "ए": "eː", "ऐ": "ai", "ओ": "oː", "औ": "au",
        
        # Consonants (with inherent 'a')
        "क": "k", "ख": "kʰ", "ग": "g", "घ": "gʱ", "ङ": "ŋ",
        "च": "tʃ", "छ": "tʃʰ", "ज": "dʒ", "झ": "dʒʱ", "ञ": "ɲ",
        "ट": "ʈ", "ठ": "ʈʰ", "ड": "ɖ", "ढ": "ɖʱ", "ण": "ɳ",
        "त": "t", "थ": "tʰ", "द": "d", "ध": "dʱ", "न": "n",
        "प": "p", "फ": "pʰ", "ब": "b", "भ": "bʱ", "म": "m",
        "य": "j", "र": "r", "ल": "l", "व": "v",
        "श": "ʃ", "ष": "ʂ", "स": "s", "ह": "h",
        
        # Vowel diacritics (matras)
        "ा": "aː", "ि": "i", "ी": "iː",
        "ु": "u", "ू": "uː", "ृ": "ri",
        "े": "eː", "ै": "ai", "ो": "oː", "ौ": "au",
        
        # Special marks
        "ं": "m", "ः": "h", "ँ": "̃", "्": "",
        
        # Sacred
        "ॐ": "om",
        
        # Punctuation
        "।": ".", "॥": "..", " ": " ", "\n": " ",
    }
    
    result = []
    i = 0
    while i < len(text):
        char = text[i]
        
        # Check if current char is in map
        if char in char_map:
            ipa = char_map[char]
            
            # If it's a consonant (not empty, not vowel marker, not space)
            if ipa and ipa not in ["", " ", ".", "..", "̃"]:
                # Check if next char is a vowel marker or halant
                if i + 1 < len(text):
                    next_char = text[i + 1]
                    if next_char in ["ा", "ि", "ी", "ु", "ू", "ृ", "े", "ै", "ो", "ौ", "्", "ं", "ः"]:
                        # Consonant followed by matra/halant - just add consonant
                        result.append(ipa)
                    else:
                        # Consonant with inherent 'a'
                        if char in ["क", "ख", "ग", "घ", "ङ",
                                  "च", "छ", "ज", "झ", "ञ",
                                  "ट", "ठ", "ड", "ढ", "ण",
                                  "त", "थ", "द", "ध", "न",
                                  "प", "फ", "ब", "भ", "म",
                                  "य", "र", "ल", "व",
                                  "श", "ष", "स", "ह"]:
                            result.append(ipa + "a")
                        else:
                            result.append(ipa)
                else:
                    # Last character
                    if char in ["क", "ख", "ग", "घ", "ङ",
                              "च", "छ", "ज", "झ", "ञ",
                              "ट", "ठ", "ड", "ढ", "ण",
                              "त", "थ", "द", "ध", "न",
                              "प", "फ", "ब", "भ", "म",
                              "य", "र", "ल", "व",
                              "श", "ष", "स", "ह"]:
                        result.append(ipa + "a")
                    else:
                        result.append(ipa)
            else:
                result.append(ipa)
        else:
            # Unknown character - keep as is
            result.append(char)
        
        i += 1
    
    return "".join(result)


if __name__ == "__main__":
    # Test cases
    tests = [
        "ॐ नमः शिवाय",
        "धृतराष्ट्र उवाच",
        "नमस्ते",
        "गायत्री"
    ]
    
    print("Sanskrit to IPA Converter - Test")
    print("=" * 50)
    for text in tests:
        ipa = devanagari_to_ipa(text)
        print(f"Input:  {text}")
        print(f"IPA:    {ipa}")
        print()
