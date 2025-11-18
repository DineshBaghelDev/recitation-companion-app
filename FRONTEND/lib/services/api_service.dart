import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform, SocketException;
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiService {
  // API prefix
  static const String apiPrefix = '/api/v1';
  
  // Timeout duration for API calls - increased to handle slower connections
  static const Duration timeoutDuration = Duration(seconds: 30);
  static const Duration longTimeoutDuration = Duration(seconds: 60); // For batch operations

  // Determine base URL depending on platform. Use configurable host overrides for physical devices.
  static const String _overrideBaseUrl =
      String.fromEnvironment('API_BASE_URL', defaultValue: '');
  static const String _hostFromEnv =
    String.fromEnvironment('API_HOST', defaultValue: 'localhost');
  static const String _schemeFromEnv =
      String.fromEnvironment('API_SCHEME', defaultValue: 'http');
  static const String _portFromEnv =
      String.fromEnvironment('API_PORT', defaultValue: '8000');
  static const bool _useAndroidEmulatorLoopback =
      bool.fromEnvironment('USE_ANDROID_EMULATOR', defaultValue: false);

  static String get baseUrl => _baseUri.toString();

  static Uri get _baseUri {
    if (_overrideBaseUrl.isNotEmpty) {
      return Uri.parse(_normalizeBaseUrl(_overrideBaseUrl));
    }

    if (kIsWeb) {
      final base = Uri.base;
      final host = (_hostFromEnv.isNotEmpty && _hostFromEnv != '0.0.0.0')
          ? _hostFromEnv
          : base.host;
      final port = int.tryParse(_portFromEnv);
      final scheme = _schemeFromEnv.isNotEmpty ? _schemeFromEnv : base.scheme;

      final uri = Uri(
        scheme: scheme,
        host: host.isNotEmpty ? host : 'localhost',
        port: port,
      );
      return Uri.parse(_normalizeBaseUrl(uri.toString()));
    }

    final host = _resolvePlatformHost();
    final port = int.tryParse(_portFromEnv);

    final uri = Uri(
      scheme: _schemeFromEnv,
      host: host,
      port: port,
    );

    return Uri.parse(_normalizeBaseUrl(uri.toString()));
  }

  static String _resolvePlatformHost() {
    try {
      if (Platform.isAndroid) {
        if (_useAndroidEmulatorLoopback) {
          return '10.0.2.2';
        }
        return _hostFromEnv;
      }
      if (Platform.isIOS) {
        return _hostFromEnv;
      }
    } catch (_) {
      // Platform not available (e.g., tests or web)
    }
    return 'localhost';
  }

  static String _normalizeBaseUrl(String base) {
    if (base.endsWith('/')) {
      return base.substring(0, base.length - 1);
    }
    return base;
  }

  static Uri _buildUri(String path, {Map<String, String>? queryParameters}) {
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    final uri = _baseUri.resolve(normalizedPath);
    if (queryParameters == null) {
      return uri;
    }
    return uri.replace(queryParameters: queryParameters);
  }

  static Future<http.Response> _get(Uri uri, Duration timeout) async {
    try {
      return await http.get(uri).timeout(timeout);
    } on TimeoutException {
      throw Exception('Request to ${uri.toString()} timed out after ${timeout.inSeconds}s');
    } on SocketException catch (error) {
      final fallbackPort = _baseUri.hasPort
          ? _baseUri.port
          : (_baseUri.scheme == 'https' ? 443 : 80);
      throw Exception(
          'Unable to reach API server at ${_baseUri.host}:$fallbackPort. ${error.message}');
    } on http.ClientException catch (error) {
      throw Exception('Network error contacting API: ${error.message}');
    }
  }

  static Map<String, dynamic> _decodeMap(http.Response response) {
    return json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
  }

  static List<dynamic> _decodeList(http.Response response) {
    return json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>;
  }

  // Health check
  static Future<Map<String, dynamic>> getHealth() async {
    final response = await _get(_buildUri('/health'), timeoutDuration);
    if (response.statusCode == 200) {
      return _decodeMap(response);
    }
    throw Exception('Failed to load health status (HTTP ${response.statusCode})');
  }

  // Get specific verse
  static Future<Map<String, dynamic>> getVerse(int chapter, int verse) async {
    final response =
        await _get(_buildUri('$apiPrefix/slok/$chapter/$verse'), timeoutDuration);
    if (response.statusCode == 200) {
      return _decodeMap(response);
    }
    if (response.statusCode == 404) {
      throw Exception('Verse not found');
    }
    throw Exception('Failed to load verse (HTTP ${response.statusCode})');
  }

  // Get random verse from chapter
  static Future<Map<String, dynamic>> getRandomVerseFromChapter(
      int chapter) async {
    final response =
        await _get(_buildUri('$apiPrefix/slok/$chapter'), timeoutDuration);
    if (response.statusCode == 200) {
      return _decodeMap(response);
    }
    throw Exception('Failed to load random verse (HTTP ${response.statusCode})');
  }

  // Get all chapter summaries
  static Future<List<dynamic>> getChapters() async {
    final response = await _get(
      _buildUri('$apiPrefix/chapters'),
      longTimeoutDuration,
    );
    if (response.statusCode == 200) {
      return _decodeList(response);
    }
    throw Exception('Failed to load chapters (HTTP ${response.statusCode})');
  }

  // Get chapter detail
  static Future<Map<String, dynamic>> getChapterDetail(
    int chapter, {
    bool includeVerses = false,
  }) async {
    final uri = _buildUri(
      '$apiPrefix/chapter/$chapter',
      queryParameters: {'include_verses': includeVerses.toString()},
    );
    final timeout = includeVerses ? longTimeoutDuration : timeoutDuration;
    final response = await _get(uri, timeout);
    if (response.statusCode == 200) {
      return _decodeMap(response);
    }
    throw Exception('Failed to load chapter detail (HTTP ${response.statusCode})');
  }

  // Get verse of the day
  static Future<Map<String, dynamic>> getVerseOfTheDay() async {
    // Use longer timeout for verse of the day as it may need to fetch from external API
    final response =
        await _get(_buildUri('$apiPrefix/verse-of-the-day'), longTimeoutDuration);
    if (response.statusCode == 200) {
      return _decodeMap(response);
    }
    throw Exception('Failed to load verse of the day (HTTP ${response.statusCode})');
  }

  // Get chapter verses count
  static Future<Map<String, dynamic>> getChapterVersesCount(
      int chapter) async {
    final response = await _get(
      _buildUri('$apiPrefix/chapter/$chapter/verses-count'),
      timeoutDuration,
    );
    if (response.statusCode == 200) {
      return _decodeMap(response);
    }
    throw Exception('Failed to load chapter verses count (HTTP ${response.statusCode})');
  }

  // Get chapter names (lightweight)
  static Future<List<dynamic>> getChapterNames() async {
    final response = await _get(
      _buildUri('$apiPrefix/chapter-names'),
      longTimeoutDuration,
    );
    if (response.statusCode == 200) {
      return _decodeList(response);
    }
    throw Exception('Failed to load chapter names (HTTP ${response.statusCode})');
  }

  // Get chapter summary
  static Future<Map<String, dynamic>> getChapterSummary(int chapter) async {
    final response = await _get(
      _buildUri('$apiPrefix/chapter/$chapter/summary'),
      timeoutDuration,
    );
    if (response.statusCode == 200) {
      return _decodeMap(response);
    }
    throw Exception('Failed to load chapter summary (HTTP ${response.statusCode})');
  }
}
