import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
import 'api_config.dart';

/// Service for Text-to-Speech using Vakyansh Sanskrit TTS model.
/// 
/// This service provides high-quality Sanskrit TTS by calling the backend
/// which uses the Vakyansh model specifically trained for Sanskrit pronunciation.
/// 
/// Example usage:
/// ```dart
/// final tts = TtsService();
/// await tts.speak(
///   "ॐ नमः शिवाय",
///   onProgress: (pos, dur) => print('Progress: $pos / $dur'),
///   onComplete: () => print('Done!'),
/// );
/// ```
class TtsService {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  bool _isLoading = false;

  /// Get current playing status
  bool get isPlaying => _isPlaying;

  /// Get current loading status
  bool get isLoading => _isLoading;

  /// Get the audio player instance for advanced control
  AudioPlayer get player => _player;

  /// Generate and play Sanskrit text using TTS.
  /// 
  /// Example:
  /// ```dart
  /// final ttsService = TtsService();
  /// await ttsService.speak("ॐ नमः शिवाय");
  /// ```
  Future<void> speak(String text, {
    double temperature = 0.2,
    double topP = 0.9,
    Function(Duration position, Duration duration)? onProgress,
    VoidCallback? onComplete,
  }) async {
    try {
      _isLoading = true;

      // Build the API URL
      final uri = Uri.parse(
        "${ApiConfig.baseUrl}/api/v1/tts/generate?text=${Uri.encodeComponent(text)}&temperature=$temperature&top_p=$topP",
      );

      // Fetch audio from backend
      final response = await http.get(uri);

      if (response.statusCode != 200) {
        throw Exception('TTS generation failed: ${response.body}');
      }

      // Get audio bytes
      final audioBytes = response.bodyBytes;

      // Set up audio source
      await _player.setAudioSource(
        AudioSource.uri(
          Uri.dataFromBytes(
            audioBytes,
            mimeType: "audio/wav",
          ),
        ),
      );

      _isLoading = false;

      // Listen to player state
      _player.playerStateStream.listen((state) {
        _isPlaying = state.playing;
        
        if (state.processingState == ProcessingState.completed) {
          _isPlaying = false;
          onComplete?.call();
        }
      });

      // Listen to position for progress tracking
      if (onProgress != null) {
        _player.positionStream.listen((position) {
          final duration = _player.duration ?? Duration.zero;
          onProgress(position, duration);
        });
      }

      // Play the audio
      await _player.play();
      _isPlaying = true;

    } catch (e) {
      _isLoading = false;
      _isPlaying = false;
      rethrow;
    }
  }

  /// Stop current playback
  Future<void> stop() async {
    await _player.stop();
    _isPlaying = false;
  }

  /// Pause current playback
  Future<void> pause() async {
    await _player.pause();
    _isPlaying = false;
  }

  /// Resume paused playback
  Future<void> resume() async {
    await _player.play();
    _isPlaying = true;
  }

  /// Seek to specific position
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  /// Get current position
  Duration get position => _player.position;

  /// Get total duration
  Duration? get duration => _player.duration;

  /// Set volume (0.0 to 1.0)
  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume.clamp(0.0, 1.0));
  }

  /// Set playback speed (0.5 to 2.0)
  Future<void> setSpeed(double speed) async {
    await _player.setSpeed(speed.clamp(0.5, 2.0));
  }

  /// Dispose resources
  void dispose() {
    _player.dispose();
  }

  /// Generate TTS audio bytes without playing (for caching)
  /// 
  /// Returns the audio bytes that can be saved or played later
  static Future<Uint8List> generateAudioBytes(String text, {
    double temperature = 0.2,
    double topP = 0.9,
  }) async {
    final uri = Uri.parse(
      "${ApiConfig.baseUrl}/api/v1/tts/generate?text=${Uri.encodeComponent(text)}&temperature=$temperature&top_p=$topP",
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('TTS generation failed: ${response.body}');
    }

    return response.bodyBytes;
  }

  /// Check if TTS service is available
  static Future<bool> checkHealth() async {
    try {
      final uri = Uri.parse("${ApiConfig.baseUrl}/api/v1/tts/health");
      final response = await http.get(uri);
      
      if (response.statusCode == 200) {
        // Could parse JSON to check if configured
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
