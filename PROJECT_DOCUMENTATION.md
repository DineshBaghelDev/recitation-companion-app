# SwarMitra - Recitation Companion App

> Your personal Sanskrit pronunciation companion for mastering Vedic recitation

A Flutter-based mobile and web application for learning Sanskrit verse recitation from the Bhagavad Gita with AI-powered pronunciation guidance and progress tracking.

---

## 📱 Overview

SwarMitra is a comprehensive Sanskrit learning platform that combines traditional Vedic knowledge with modern technology to help users master the pronunciation of the Bhagavad Gita verses.

### Key Features

- 📖 **Complete Bhagavad Gita**: Access all 700 verses across 18 chapters
- 🔊 **Sanskrit TTS**: Authentic Devanagari pronunciation with high-quality text-to-speech
- 🎙️ **Voice Recording**: Record your pronunciation and get instant feedback
- 📊 **Progress Tracking**: Track your learning journey with detailed analytics
- 🏆 **Leaderboard**: Compete with other learners (with privacy option)
- ⭐ **Favorites System**: Save and organize your favorite verses
- 🎯 **Problematic Verses**: Identify and focus on challenging verses
- 🤖 **AI Guru**: AI-powered pronunciation coaching (in development)
- 🎨 **Beautiful UI**: Traditional Indian aesthetic with modern design
- 📱 **Cross-Platform**: Works on Android, iOS, and Web

---

## 🏗️ Architecture

```
recitation-companion-app/
├── BACKEND/              # FastAPI Python server
│   ├── app/
│   │   ├── main.py      # Application entry point
│   │   ├── config.py    # Configuration settings
│   │   ├── models/      # Data models & schemas
│   │   ├── routers/     # API endpoints (TTS, verses)
│   │   └── services/    # Business logic (Vedic service)
│   ├── requirements.txt # Python dependencies
│   └── start.bat       # Quick start script
│
└── FRONTEND/            # Flutter application
    ├── lib/
    │   ├── main.dart   # App entry point
    │   ├── core/       # Design system & constants
    │   ├── models/     # Data models (Verse, Course, User)
    │   ├── providers/  # State management (Riverpod)
    │   ├── screens/    # UI screens
    │   ├── services/   # API & TTS services
    │   └── widgets/    # Reusable UI components
    ├── assets/         # Images & resources
    ├── web/           # Web-specific files
    └── pubspec.yaml   # Flutter dependencies
```

### Tech Stack

**Backend**
- Framework: FastAPI 0.115.0
- TTS Engine: Vakyansh Sanskrit Model (via external API)
- Verse Data: GitHub Pages API (Vedic Scriptures)
- Language: Python 3.10+
- Server: Uvicorn (ASGI)

**Frontend**
- Framework: Flutter 3.0+
- State Management: Riverpod 2.5.1
- Audio Playback: just_audio 0.9.36
- Voice Recording: record 5.1.2
- HTTP Client: http 1.1.0
- Animations: flutter_animate 4.2.0
- UI: Material Design 3 with custom theme

---

## 🚀 Getting Started

### Prerequisites

- **Python 3.10+** (for backend)
- **Flutter 3.0+** (for frontend)
- **Git**
- **VS Code** (recommended) or Android Studio

### Installation

#### 1. Clone Repository

```powershell
git clone https://github.com/yourusername/recitation-companion-app.git
cd recitation-companion-app
```

#### 2. Backend Setup

```powershell
cd BACKEND

# Install dependencies
pip install -r requirements.txt

# Start server (default port: 8000)
python -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

# Or use the batch script
.\start.bat
```

**Backend API Documentation**: http://localhost:8000/docs

#### 3. Frontend Setup

```powershell
cd FRONTEND

# Install dependencies
flutter pub get

# Configure API endpoint (for web)
# Edit lib/services/api_config.dart
# Use 'http://localhost:8000' for web
# Use 'http://10.0.2.2:8000' for Android emulator

# Run on your device/emulator
flutter run

# Or run on web
flutter run -d chrome
```

---

## 📡 API Endpoints

### Verses API

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/chapters` | List all 18 chapters |
| GET | `/api/v1/slok/{chapter}/{verse}` | Get specific verse |
| GET | `/api/v1/verse-of-the-day` | Get daily verse (changes daily) |

### Text-to-Speech API

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/v1/tts/generate` | Generate Sanskrit audio |
| GET | `/api/v1/tts/health` | Check TTS service status |

**Example Request:**
```powershell
curl -X POST "http://localhost:8000/api/v1/tts/generate" \
  -H "Content-Type: application/json" \
  -d '{"text": "कर्मण्येवाधिकारस्ते", "temperature": 0.667, "top_p": 0.9}'
```

---

## 🎨 Design System

### Color Palette

```dart
// Primary Colors
Primary:   #7B2CBF (Purple)
Accent:    #C77DFF (Light Purple)

// UI Colors
Background:    #FFFFFF
Surface:       #F8F9FA
Text Primary:  #212529
Text Secondary: #6C757D
```

### Typography
- **Headings**: Poppins (Bold)
- **Body**: Poppins (Regular)
- **Sanskrit**: Noto Sans Devanagari

### Key Screens

1. **Login Screen**: User authentication and onboarding
2. **User Info Screen**: Profile setup with age group and language preferences
3. **Home Screen**: Dashboard with stats, verse of the day, and quick access
4. **Learn Screen**: Browse all chapters and verses
5. **Verse Detail Screen**: Full verse view with audio, translation, and recording
6. **Progress Screen**: Learning analytics and pronunciation scores by chapter
7. **Community Screen**: Leaderboard and social features
8. **Profile Screen**: User settings and account management
9. **Favorites Screen**: Saved verses collection
10. **Problematic Verses Screen**: Focus on challenging verses
11. **AI Guru Screen**: AI coaching interface (beta)

---

## 🔧 Configuration

### Backend Configuration

**File**: `BACKEND/app/config.py`

```python
# API Settings
API_V1_PREFIX = "/api/v1"
PROJECT_NAME = "Recitation Companion API"

# External APIs
VEDIC_SCRIPTURES_API = "https://gita-api.vercel.app"
VAKYANSH_TTS_API = "https://models.reverieinc.com"
```

### Frontend Configuration

**File**: `FRONTEND/lib/services/api_config.dart`

```dart
class ApiConfig {
  // Change based on platform
  static const String baseUrl = 'http://localhost:8000';  // Web
  // static const String baseUrl = 'http://10.0.2.2:8000'; // Android Emulator
}
```

---

## 📊 Features in Detail

### 1. Voice Recording & Analysis
- Record your pronunciation using the microphone
- Get instant feedback on accuracy
- Identify difficult words and sounds
- Track improvement over time

### 2. Progress Tracking
- Total verses learned
- Learning streak (days)
- Average pronunciation score
- Chapter-wise pronunciation breakdown
- Visual progress indicators

### 3. Favorites System
- Save verses for later review
- Swipe to remove from favorites
- Quick access from home screen
- Undo removal option

### 4. Problematic Verses
- Automatically tracks verses needing attention
- Shows difficulty level (Easy, Medium, Hard, Very Hard)
- Displays specific problematic words in Sanskrit
- Attempt count and average scores
- Practice tips and suggestions

### 5. Community Features
- Global leaderboard with rankings
- User pronunciation scores
- "Hide My Rank" option for privacy
- Current user highlighting

### 6. AI Guru (Beta)
- Personalized pronunciation coaching
- Step-by-step learning guidance
- Feature overview and how-it-works guide
- Coming soon: Real-time AI feedback

---

## 🛠️ Development

### Running Tests

```powershell
# Backend tests
cd BACKEND
pytest

# Frontend tests
cd FRONTEND
flutter test
```

### Building for Production

```powershell
# Web
flutter build web

# Android
flutter build apk --release

# iOS
flutter build ios --release
```

### Code Quality

The project maintains high code quality with:
- Lint-free codebase (flutter_lints 4.0.0)
- Type-safe state management (Riverpod)
- Error handling throughout
- Responsive UI design
- Performance optimizations (audio caching)

---

## 📝 Key Implementation Details

### Audio Caching
TTS responses are cached in memory to avoid redundant API calls:
```dart
final Map<String, Uint8List> _audioCache = {};
String cacheKey = '$text-$temperature-$topP';
```

### Verse of the Day Algorithm
Deterministic daily verse selection based on date:
```python
day_seed = today.year * 10000 + today.month * 100 + today.day
verse_index = day_seed % total_verses
```

### State Management
Using Riverpod providers for clean, testable code:
- `verseListProvider` - All verses
- `verseByIdProvider` - Single verse by chapter.verse
- `progressStatsProvider` - User progress data
- `favoritesProvider` - Favorites management
- `userDataProvider` - User profile data

---

## 🐛 Known Issues & Limitations

1. **Recording on Web**: May require HTTPS for microphone access
2. **Audio Caching**: In-memory only, cleared on app restart
3. **AI Analysis**: Currently shows mock data, real AI integration pending
4. **Offline Mode**: Requires internet connection for TTS and verse data

---

## 🚦 Recent Changes

### Latest Updates (November 2025)

✅ **Fixed Issues:**
- Pause/play button state management
- Verse of the day API (now varies daily)
- Recording button error handling
- Removed ||pattern|| from Sanskrit text
- Profile icon navigation in home screen
- Settings icon in progress screen

✅ **New Features:**
- Menu drawer with navigation
- Favorites system with like button
- Problematic verses screen with word tracking
- AI Guru screen with feature overview
- Quick access buttons (3 main actions)
- Pronunciation scores by chapter
- Hide rank option in leaderboard
- Language "Notify Me" dialog for upcoming languages

✅ **UI Improvements:**
- Hero image updated to hero3.png
- Mascot updated to mascot2.png (larger, cropped)
- Favicon/app icon set to favicon.png
- Removed mock analysis disclaimer
- Increased verses learned display (20-30 range)

---

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## 🙏 Acknowledgments

- **Bhagavad Gita API**: GitHub Pages Vedic Scriptures API
- **TTS Engine**: Vakyansh Sanskrit TTS by Reverie Language Technologies
- **Icons**: Material Design Icons
- **Fonts**: Google Fonts (Poppins, Noto Sans Devanagari)

---

## 📞 Support

For issues, questions, or contributions:
- Create an issue on GitHub
- Contact: [your-email@example.com]

---

**Built with ❤️ for Sanskrit learning enthusiasts**

*SwarMitra - Where tradition meets technology*
