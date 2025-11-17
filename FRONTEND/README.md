# Frontend - Recitation Companion App

Flutter mobile application for Sanskrit verse recitation practice with authentic TTS.

## Quick Start

```powershell
# Install dependencies
flutter pub get

# Run app
flutter run

# Or for specific platform
flutter run -d windows
flutter run -d android
flutter run -d chrome
```

## Configuration

Backend URL is set in `lib/services/api_config.dart`:

```dart
class ApiConfig {
  static const String baseUrl = 'http://localhost:8000';
}
```

Change this if your backend runs on a different address.

## Tech Stack

- **Framework**: Flutter 3.0+
- **State Management**: Riverpod
- **Audio Playback**: just_audio
- **HTTP Client**: http package
- **Design**: Material 3 with custom saffron-orange theme

## Key Features

- ✅ Browse Vedic scripture verses
- ✅ High-quality Sanskrit TTS playback (Vakyansh model)
- ✅ Real-time progress tracking
- ✅ Beautiful saffron-orange themed UI
- ✅ Cross-platform (Android, iOS, Windows, Web)

## Structure

```
lib/
├── screens/        # UI screens
├── services/       # API and TTS services
├── providers/      # Riverpod state management
├── models/         # Data models
├── widgets/        # Reusable UI components
└── core/           # Design system
```

See [main README](../README.md) for full documentation.
