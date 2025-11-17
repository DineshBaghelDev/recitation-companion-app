# Backend - Recitation Companion API

FastAPI backend providing Vedic scripture verses and Sanskrit TTS synthesis.

## Quick Start

```powershell
# Install dependencies (first time only)
.\install_tts.bat

# Start server
python -m uvicorn app.main:app --reload
```

Server runs on: **http://localhost:8000**

API documentation: **http://localhost:8000/docs**

## Key Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/v1/verses` | GET | Get all verses |
| `/api/v1/verses/{id}` | GET | Get specific verse |
| `/api/v1/tts/generate` | POST/GET | Generate Sanskrit audio |
| `/api/v1/tts/health` | GET | Check TTS status |

## Tech Stack

- **Framework**: FastAPI
- **TTS Engine**: Coqui TTS with Vakyansh Sanskrit model
- **Data Source**: Vedic Scriptures API

## Structure

```
app/
├── routers/
│   ├── tts.py          # TTS endpoints
│   └── verses.py       # Verse endpoints
├── services/
│   └── vedic_service.py # API integration
├── models/
│   └── schemas.py      # Data models
├── config.py           # Configuration
└── main.py             # App entry point
```

See [main README](../README.md) for full documentation.
