/// API configuration for the Recitation Companion App
class ApiConfig {
  /// Base URL for the backend API
  /// Change this to match your backend server address
  static const String baseUrl = 'http://localhost:8000';
  
  /// API version
  static const String apiVersion = 'v1';
  
  /// Full API base path
  static String get apiBasePath => '$baseUrl/api/$apiVersion';
  
  /// Timeout duration for API requests
  static const Duration timeout = Duration(seconds: 30);
  
  /// TTS endpoint configuration
  static const Duration ttsTimeout = Duration(seconds: 60); // Longer for TTS generation
}
