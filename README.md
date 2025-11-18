# Recitation Companion App

A Flutter mobile application for learning Sanskrit verse recitation from the Bhagavad Gita with AI-powered text-to-speech pronunciation guidance.

## ✨ Features

- **📖 Bhagavad Gita Verses**: Access all 700 verses across 18 chapters
- **🔊 Sanskrit TTS**: Authentic Devanagari pronunciation using Google TTS
- **🎨 Traditional Design**: Saffron-orange themed UI reflecting Indian aesthetics
- **📱 Cross-Platform**: Works on Android, iOS, and Web
- **⚡ Fast & Lightweight**: No heavy ML models, instant audio generation

## 🏗️ Architecture

```
recitation-companion-app/
├── BACKEND/          # FastAPI server for TTS and verses
└── FRONTEND/         # Flutter mobile application
```

### Backend (FastAPI + Python)
- **Framework**: FastAPI 0.115.0
- **TTS Engine**: Google Text-to-Speech (gTTS)
- **Language**: Hindi for Devanagari pronunciation
- **Port**: 8000
- **API Docs**: http://localhost:8000/docs

### Frontend (Flutter + Dart)
- **Framework**: Flutter 3.0+
- **State Management**: Riverpod
- **Audio**: just_audio package
- **Design**: Material Design with custom saffron-orange theme

## 📋 Prerequisites

- **Python 3.10+** (for backend)
- **Flutter 3.0+** (for frontend)
- **Git** (for cloning)

## 🚀 Quick Start

### 1. Clone Repository

```powershell
git clone https://github.com/yourusername/recitation-companion-app.git
cd recitation-companion-app
```

### 2. Backend Setup

```powershell
cd BACKEND

# Install dependencies
pip install -r requirements.txt

# Create environment file
copy .env.example .env

# Start server
python -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

**Backend will be available at**: http://localhost:8000

### 3. Frontend Setup

```powershell
cd FRONTEND

# Install dependencies
flutter pub get

# Run on your device/emulator
flutter run
```

## 📚 API Endpoints

### Verses
- `GET /api/v1/chapters` - List all Gita chapters
- `GET /api/v1/slok/{chapter}/{verse}` - Get specific verse
- `GET /api/v1/verse-of-the-day` - Get daily verse

### Text-to-Speech
- `POST /api/v1/tts/generate` - Generate audio (JSON body)
- `GET /api/v1/tts/generate?text={text}` - Generate audio (query param)
- `GET /api/v1/tts/health` - Check TTS status

Example:
```powershell
curl "http://localhost:8000/api/v1/tts/generate?text=नमस्ते" -o output.mp3
```

## 🎨 Design System

### Color Palette
- **Primary Orange**: `#FF6B35` - Main actions, highlights
- **Accent Orange**: `#F7931E` - Secondary elements
- **Deep Orange**: `#D84315` - Emphasis, important states
- **Light Peach**: `#FFAB91` - Backgrounds, subtle highlights
- **Background**: `#FFF8F0` - Warm cream background

### Typography
- **Headings**: Noto Serif (traditional feel)
- **Body**: Noto Sans (readability)
- **Sanskrit**: Noto Sans Devanagari

## 🛠️ Technology Stack

### Backend
- FastAPI - Modern web framework
- gTTS - Google Text-to-Speech
- Uvicorn - ASGI server
- Python-dotenv - Environment management

### Frontend
- Flutter - Cross-platform framework
- Riverpod - State management
- just_audio - Audio playback
- HTTP - API communication

## 📁 Project Structure

```
BACKEND/
├── app/
│   ├── routers/
│   │   ├── tts.py          # TTS endpoints
│   │   └── verses.py       # Verse endpoints
│   ├── services/
│   │   └── vedic_service.py # API integration
│   ├── models/
│   │   └── schemas.py      # Data models
│   ├── config.py           # Configuration
│   └── main.py             # App entry point
├── requirements.txt        # Python dependencies
├── .env.example           # Environment template
└── start.bat              # Startup script

FRONTEND/
├── lib/
│   ├── screens/           # UI screens
│   ├── widgets/           # Reusable components
│   ├── providers/         # State management
│   ├── services/          # API services
│   ├── models/            # Data models
│   └── main.dart          # App entry point
├── assets/                # Images, fonts
└── pubspec.yaml          # Flutter dependencies
```

## 🔧 Configuration

### Backend (.env)
```env
API_BASE_URL=https://bhagavadgitaapi.in
API_KEY=your_api_key_here
```

### Frontend (lib/services/api_config.dart)
```dart
static const String baseUrl = 'http://localhost:8000';
```

## 🧪 Development

### Backend Development
```powershell
cd BACKEND
python -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```
Server runs with hot-reload enabled. Changes to Python files automatically restart the server.

### Frontend Development
```powershell
cd FRONTEND
flutter run
```
Flutter runs with hot-reload. Press `r` to hot reload, `R` to hot restart.

## 📝 Notes

- **TTS**: Currently using Google TTS (gTTS) with Hindi language for Devanagari text
- **GPU Models**: Advanced models like rverma0631/Sanskrit_TTS require CUDA GPU
- **CORS**: Backend configured to allow all origins for development

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📧 Contact

For questions or support, please open an issue on GitHub.
