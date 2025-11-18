# Backend - Recitation Companion API# Backend - Recitation Companion API# Backend - Recitation Companion API



FastAPI backend providing Bhagavad Gita verses and Sanskrit text-to-speech synthesis.



## Quick StartFastAPI backend providing Bhagavad Gita verses and Sanskrit text-to-speech synthesis.FastAPI backend providing Vedic scripture verses and Sanskrit TTS synthesis.



```powershell

# Install dependencies (one-time setup)

pip install -r requirements.txt## Quick Start## Quick Start



# Start the server

python -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

```powershell```powershell

# OR use the startup script

.\start.bat# Install dependencies# Install dependencies (first time only)

```

pip install -r requirements.txt.\install_tts.bat

**Server**: http://localhost:8000  

**API Docs**: http://localhost:8000/docs



## API Endpoints# Start development server# Start server



### Versespython -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000python -m uvicorn app.main:app --reload

- `GET /api/v1/chapters` - List all chapters

- `GET /api/v1/slok/{chapter}/{verse}` - Get specific verse``````

- `GET /api/v1/verse-of-the-day` - Get daily verse



### Text-to-Speech

- `POST /api/v1/tts/generate` - Generate Sanskrit audio (JSON body)**Server**: http://localhost:8000  Server runs on: **http://localhost:8000**

- `GET /api/v1/tts/generate?text={text}` - Generate audio (query param)

- `GET /api/v1/tts/health` - Check TTS status**API Docs**: http://localhost:8000/docs



## Technology StackAPI documentation: **http://localhost:8000/docs**



- **Framework**: FastAPI 0.115.0## API Endpoints

- **Server**: Uvicorn with auto-reload

- **TTS Engine**: Google TTS (gTTS) with Hindi/Devanagari## Key Endpoints

- **Data Source**: Bhagavad Gita API

### Verses

## Project Structure

- `GET /api/v1/chapters` - List all chapters| Endpoint | Method | Description |

```

app/- `GET /api/v1/slok/{chapter}/{verse}` - Get specific verse|----------|--------|-------------|

├── routers/

│   ├── verses.py        # Bhagavad Gita verse endpoints- `GET /api/v1/verse-of-the-day` - Get daily verse| `/api/v1/verses` | GET | Get all verses |

│   └── tts.py           # Text-to-speech endpoints

├── services/| `/api/v1/verses/{id}` | GET | Get specific verse |

│   └── vedic_service.py # External API integration

├── models/### Text-to-Speech| `/api/v1/tts/generate` | POST/GET | Generate Sanskrit audio |

│   └── schemas.py       # Pydantic data models

├── config.py            # App configuration- `POST /api/v1/tts/generate` - Generate Sanskrit audio| `/api/v1/tts/health` | GET | Check TTS status |

└── main.py              # Application entry point

```- `GET /api/v1/tts/generate?text={text}` - Generate audio (GET)



## Configuration- `GET /api/v1/tts/health` - Check TTS status## Tech Stack



Environment variables (`.env`):

```env

API_BASE_URL=https://bhagavadgitaapi.in## Technology Stack- **Framework**: FastAPI

API_KEY=your_api_key_here

```- **TTS Engine**: Coqui TTS with Vakyansh Sanskrit model



## Development- **Framework**: FastAPI 0.115.0- **Data Source**: Vedic Scriptures API



The server runs with hot-reload enabled. Changes to Python files will automatically restart the server.- **Server**: Uvicorn with auto-reload



**CORS**: Configured to allow all origins for Flutter development.- **TTS Engine**: Google TTS (gTTS) with Hindi/Devanagari## Structure



## TTS Information- **Data Source**: Bhagavad Gita API



Currently using **Google TTS (gTTS)** with Hindi language for Devanagari text:```

- Fast and reliable

- No GPU required## Project Structureapp/

- Indian accent (`tld='co.in'`)

- Returns MP3 audio├── routers/



**Note**: GPU-based alternatives (like rverma0631/Sanskrit_TTS) require CUDA and won't work on CPU-only systems.```│   ├── tts.py          # TTS endpoints



## Dependenciesapp/│   └── verses.py       # Verse endpoints



All dependencies are installed globally via pip. No virtual environment needed.├── routers/├── services/



See `requirements.txt` for the complete list.│   ├── verses.py        # Bhagavad Gita verse endpoints│   └── vedic_service.py # API integration


│   └── tts.py           # Text-to-speech endpoints├── models/

├── services/│   └── schemas.py      # Data models

│   └── vedic_service.py # External API integration├── config.py           # Configuration

├── models/└── main.py             # App entry point

│   └── schemas.py       # Pydantic data models```

├── config.py            # App configuration

└── main.py              # Application entry pointSee [main README](../README.md) for full documentation.

```

## Configuration

Environment variables (`.env`):
```env
API_BASE_URL=https://bhagavadgitaapi.in
API_KEY=your_api_key_here
```

## Development

The server runs with hot-reload enabled. Changes to Python files will automatically restart the server.

**CORS**: Configured to allow all origins for Flutter development.

## TTS Notes

Currently using **Google TTS (gTTS)** with Hindi language for Devanagari text:
- Fast and reliable
- No GPU required
- Indian accent (`tld='co.in'`)
- Returns MP3 audio

**GPU-based alternatives** (like rverma0631/Sanskrit_TTS) require CUDA and won't work on CPU.
