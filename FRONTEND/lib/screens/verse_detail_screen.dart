import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';

import '../providers/verse_providers.dart';
import '../providers/favorites_provider.dart';
import '../services/tts_service.dart';

class VerseDetailScreen extends ConsumerStatefulWidget {
  const VerseDetailScreen({super.key, required this.verseId});

  static const routeName = '/verse';

  final String verseId;

  @override
  ConsumerState<VerseDetailScreen> createState() => _VerseDetailScreenState();
}

class _VerseDetailScreenState extends ConsumerState<VerseDetailScreen> {
  late final TtsService _ttsService;
  late final AudioPlayer _player;
  late final AudioRecorder _recorder;
  double _playbackPosition = 0.0;
  bool _isPlaying = false;
  bool _isLoading = false;
  bool _isTtsMode = true; // true = TTS, false = Audio file
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  Duration _lastNotifiedPosition = Duration.zero;
  double _lastNotifiedProgress = 0.0;
  String? _currentVerseText;
  DateTime? _lastAudioProgressUpdate;
  
  // For word highlighting
  int _currentWordIndex = 0;
  List<String> _words = [];
  bool _isPaused = false;
  
  // For audio recording
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _ttsService = TtsService();
    _player = AudioPlayer();
    _recorder = AudioRecorder();
    _setupAudioPlayer();
    _setupTtsService();
  }

  void _setupTtsService() {
    // Note: TTS service uses internal AudioPlayer.
    // Playback state is managed through the service's speak() callbacks
    // and we track state through _isPlaying and _isLoading variables.
  }

  void _setupAudioPlayer() {
    // Listen to player state changes
    _player.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state.playing;
          _isLoading = state.processingState == ProcessingState.loading ||
                      state.processingState == ProcessingState.buffering;
        });
      }
    });

    // Listen to duration changes
    _player.durationStream.listen((duration) {
      if (mounted && duration != null) {
        setState(() {
          _duration = duration;
        });
      }
    });

    // Listen to position changes
    _player.positionStream.listen((position) {
      if (!mounted) return;

      final now = DateTime.now();
      if (_lastAudioProgressUpdate != null &&
          now.difference(_lastAudioProgressUpdate!) <= const Duration(milliseconds: 200)) {
        return;
      }

      final positionDelta = (position - _lastNotifiedPosition).abs();
      if (positionDelta < const Duration(milliseconds: 200)) {
        return;
      }

      final newProgress = _duration.inMilliseconds > 0
          ? (position.inMilliseconds / _duration.inMilliseconds).clamp(0.0, 1.0)
          : 0.0;

      if ((newProgress - _lastNotifiedProgress).abs() < 0.02) {
        return;
      }

      _lastAudioProgressUpdate = now;

      setState(() {
        _position = position;
        _playbackPosition = newProgress;
        _lastNotifiedProgress = newProgress;
        _lastNotifiedPosition = position;
      });
    });

    // Listen to player completion
    _player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed && mounted) {
        setState(() {
          _isPlaying = false;
          _playbackPosition = 0.0;
          _position = Duration.zero;
          _lastNotifiedProgress = 0.0;
          _lastNotifiedPosition = Duration.zero;
        });
        _player.seek(Duration.zero);
      }
    });
  }

  Future<void> _togglePlayback() async {
    try {
      if (_isTtsMode) {
        // Use Text-to-Speech via backend
        if (_isPlaying) {
          // Currently playing - pause it
          await _ttsService.pause();
          if (mounted) {
            setState(() {
              _isPlaying = false;
              _isPaused = true;
            });
          }
        } else if (_isPaused) {
          // Currently paused - resume it
          await _ttsService.resume();
          if (mounted) {
            setState(() {
              _isPlaying = true;
              _isPaused = false;
            });
          }
        } else {
          // Not playing - start new playback
          if (_currentVerseText == null || _currentVerseText!.isEmpty) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Unable to play: verse text not loaded')),
              );
            }
            return;
          }
          
          // Split text into words for highlighting
          _words = _currentVerseText!.split(RegExp(r'\s+'));
          _currentWordIndex = 0;
          
          if (mounted) {
            setState(() {
              _isPlaying = true;
              _isLoading = true;
              _isPaused = false;
            });
          }
          
          try {
            await _ttsService.speak(
              _currentVerseText!,
              onProgress: (position, duration) {
                if (!mounted) return;
                
                if (duration.inMilliseconds == 0) return;

                final now = DateTime.now();
                if (_lastAudioProgressUpdate != null &&
                    now.difference(_lastAudioProgressUpdate!) <= const Duration(milliseconds: 200)) {
                  return;
                }

                final progress = position.inMilliseconds / duration.inMilliseconds;
                if ((progress - _lastNotifiedProgress).abs() < 0.02) {
                  return;
                }

                _lastAudioProgressUpdate = now;

                // Update word index based on progress
                final newWordIndex = (_words.length * progress).floor().clamp(0, _words.length - 1);

                setState(() {
                  _playbackPosition = progress.clamp(0.0, 1.0);
                  _lastNotifiedProgress = progress;
                  _position = position;
                  _duration = duration;
                  _currentWordIndex = newWordIndex;
                });
              },
              onComplete: () {
                if (mounted) {
                  setState(() {
                    _isPlaying = false;
                    _isPaused = false;
                    _playbackPosition = 0.0;
                    _lastNotifiedProgress = 0.0;
                    _currentWordIndex = 0;
                  });
                }
              },
            );
          } catch (e) {
            if (mounted) {
              setState(() {
                _isPlaying = false;
                _isPaused = false;
                _isLoading = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('TTS error: $e')),
              );
            }
          } finally {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          }
        }
      } else {
        // Use audio player for file playback
        if (_isPlaying) {
          await _player.pause();
        } else {
          await _player.play();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _isLoading = false;
          _isPaused = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Playback error: $e')),
        );
      }
    }
  }

  Future<void> _seekTo(double position) async {
    if (_isTtsMode) {
      // TTS doesn't support seeking, restart from beginning
      if (_isPlaying) {
        await _ttsService.stop();
        if (_currentVerseText != null) {
          await _ttsService.speak(_currentVerseText!);
        }
      }
    } else {
      final newPosition = Duration(milliseconds: (_duration.inMilliseconds * position).round());
      await _player.seek(newPosition);
    }
  }

  Future<void> _skipBackward() async {
    if (_isTtsMode) {
      // Restart TTS from beginning
      await _ttsService.stop();
      if (_currentVerseText != null) {
        setState(() => _isPlaying = true);
        await _ttsService.speak(_currentVerseText!);
      }
    } else {
      final newPosition = _position - const Duration(seconds: 10);
      await _player.seek(newPosition < Duration.zero ? Duration.zero : newPosition);
    }
  }

  Future<void> _skipForward() async {
    if (_isTtsMode) {
      // TTS doesn't support skip forward, just stop
      await _ttsService.stop();
      setState(() {
        _isPlaying = false;
        _playbackPosition = 0.0;
      });
    } else {
      final newPosition = _position + const Duration(seconds: 10);
      await _player.seek(newPosition > _duration ? _duration : newPosition);
    }
  }

  void _setVerseText(String verseText) {
    _currentVerseText = verseText;
    _lastNotifiedProgress = 0.0;
    _lastAudioProgressUpdate = null;
    _lastNotifiedPosition = Duration.zero;
  }

  Widget _buildHighlightedText(String text, TextTheme textTheme) {
    if (_words.isEmpty || !_isPlaying) {
      // Not playing or no words split yet - show normal text
      return Text(
        text,
        style: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          height: 1.4,
        ),
        textAlign: TextAlign.center,
      );
    }

    // Build rich text with highlighted current word
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: _words.asMap().entries.map((entry) {
        final index = entry.key;
        final word = entry.value;
        final isCurrentWord = index == _currentWordIndex;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isCurrentWord 
                ? const Color(0xFFFF6B35).withOpacity(0.3)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            word,
            style: textTheme.titleLarge?.copyWith(
              fontWeight: isCurrentWord ? FontWeight.w900 : FontWeight.w700,
              height: 1.4,
              color: isCurrentWord 
                  ? const Color(0xFFD84315)
                  : Colors.black87,
              shadows: isCurrentWord ? [
                Shadow(
                  color: const Color(0xFFFF6B35).withOpacity(0.3),
                  blurRadius: 8,
                ),
              ] : null,
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  void dispose() {
    _player.dispose();
    _ttsService.dispose();
    _recorder.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      // Check if recorder has permission first
      if (!await _recorder.hasPermission()) {
        // Request microphone permission
        final status = await Permission.microphone.request();
        if (!status.isGranted) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Microphone permission is required for recording'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }
      }

      // Start recording with explicit config
      // Use a simple path that doesn't require path_provider plugin
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final config = RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
      );
      
      // For Android, use app's cache directory path directly
      // For iOS, use app's document directory path directly
      await _recorder.start(config, path: '/data/user/0/com.example.recitation_companion/cache/recording_$timestamp.m4a');
      
      if (mounted) {
        setState(() {
          _isRecording = true;
        });
        
        // Show recording started feedback
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Recording started'),
            duration: Duration(seconds: 1),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on MissingPluginException {
      if (mounted) {
        setState(() {
          _isRecording = false;
        });
        
        // Show immediate error dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red),
                SizedBox(width: 8),
                Text('Plugin Error'),
              ],
            ),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'The recording feature requires a full app restart to work properly.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                Text('Please:'),
                SizedBox(height: 8),
                Text('1. Stop the app completely'),
                Text('2. Restart the app'),
                Text('3. Try recording again'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isRecording = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to start recording: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _recorder.stop();
      
      if (mounted) {
        setState(() {
          _isRecording = false;
        });
      }

      if (path != null) {
        // Analyze the recording
        await _analyzePronunciation(path);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isRecording = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to stop recording: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _analyzePronunciation(String recordingPath) async {
    if (!mounted) return;

    // Show analyzing dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          margin: EdgeInsets.all(32),
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Analyzing pronunciation...'),
              ],
            ),
          ),
        ),
      ),
    );

    // TODO: Implement actual pronunciation analysis with backend API
    // For now, simulate with delay and show mock results
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    Navigator.of(context).pop(); // Close analyzing dialog

    // Mock results - replace with actual API call
    final mockAccuracy = 75 + (DateTime.now().millisecond % 20);
    final mockDifficultWords = ['धर्मक्षेत्रे', 'समवेता', 'युयुत्सवः'];

    // Show results dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pronunciation Analysis'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$mockAccuracy%',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF6B35),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Pronunciation Accuracy',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Difficult Words:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...mockDifficultWords.map((word) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber, size: 20, color: Colors.orange),
                  const SizedBox(width: 8),
                  Text(word),
                ],
              ),
            )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              _startRecording(); // Record again
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );

    // Clean up recording file
    try {
      final file = File(recordingPath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // Ignore cleanup errors
    }
  }

  @override
  Widget build(BuildContext context) {
    final verseAsync = ref.watch(verseByIdProvider(widget.verseId));
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = const Color(0xFFFF6B35); // Deep saffron orange

    return verseAsync.when(
      loading: () => Scaffold(
        backgroundColor: primaryColor,
        body: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
      error: (error, stack) => Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, size: 48, color: colorScheme.error),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load verse',
                    style: textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    child: const Text('Go back'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      data: (verse) => _buildVerseContent(verse, primaryColor, colorScheme, textTheme),
    );
  }

  Widget _buildVerseContent(
    verse,
    Color primaryColor,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    if (verse.id == 'not-found' || verse.chapter == 0) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.library_books_outlined, size: 48, color: primaryColor),
                  const SizedBox(height: 16),
                  Text(
                    'Verse not found',
                    style: textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text('The selected verse is unavailable. Please return to Home.'),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    child: const Text('Back to library'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Set the verse text for TTS playback immediately (only slok, no transliteration)
    final verseText = verse.slok;
    if (_currentVerseText != verseText) {
      // Use addPostFrameCallback to avoid setState during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _setVerseText(verseText);
        }
      });
    }

    final accuracyPercent = (verse.mastery * 100).clamp(0, 100).round();

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 360,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primaryColor.withValues(alpha: 0.9),
                    primaryColor.withValues(alpha: 0.6),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                        onPressed: () => Navigator.of(context).maybePop(),
                      ),
                      const Spacer(),
                      Consumer(
                        builder: (context, ref, child) {
                          final favorites = ref.watch(favoritesProvider);
                          final isFavorite = favorites.any(
                            (v) => v.chapter == verse.chapter && v.verse == verse.verse,
                          );
                          return IconButton(
                            icon: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: Colors.white,
                            ),
                            tooltip: isFavorite ? 'Remove from favourites' : 'Add to favourites',
                            onPressed: () {
                              ref.read(favoritesProvider.notifier).toggleFavorite(verse);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isFavorite
                                        ? 'Removed from favourites'
                                        : 'Added to favourites',
                                  ),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy_outlined, color: Colors.white),
                        tooltip: 'Copy verse',
                        onPressed: () async {
                          final joinedVerse = verse.slok;
                          final messenger = ScaffoldMessenger.of(context);
                          await Clipboard.setData(ClipboardData(text: joinedVerse));
                          messenger.showSnackBar(
                            const SnackBar(content: Text('Verse copied to clipboard')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 160),
                    child: Column(
                      children: [
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.25),
                                blurRadius: 24,
                                offset: const Offset(0, 16),
                              ),
                            ],
                            color: Colors.white,
                          ),
                          child: ClipOval(
                            child: Transform.scale(
                              scale: 1.4, // Scale up to crop out the 30px margin
                              child: Image.asset(
                                'assets/images/mascot2.png',
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          verse.title,
                          style: textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Chapter ${verse.chapter}',
                          style: textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                        const SizedBox(height: 28),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 32,
                                offset: const Offset(0, 24),
                                spreadRadius: -16,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Word-by-word highlighted text
                              _buildHighlightedText(verse.slok, textTheme),
                            ],
                          ),
                        ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.08),
                        Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: _TranslationCard(
                            title: 'Hindi Translation',
                            translation: verse.hindiTranslation,
                            primaryColor: primaryColor,
                          ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.06),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: _TranslationCard(
                            title: 'English Translation',
                            translation: verse.englishTranslation,
                            primaryColor: primaryColor,
                          ).animate(delay: 350.ms).fadeIn().slideY(begin: 0.06),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _RecitationControlBar(
        accuracyPercent: accuracyPercent,
        isPlaying: _isPlaying,
        isLoading: _isLoading,
        isRecording: _isRecording,
        isTtsMode: _isTtsMode,
        onPlay: _togglePlayback,
        onPause: _togglePlayback,
        onRecord: () async {
          if (_isRecording) {
            // Stop recording if already recording
            await _stopRecording();
          } else {
            // Start recording
            await _startRecording();
          }
        },
        onRetry: _skipBackward,
        onSkipForward: _skipForward,
        onPrevious: () {
          if (verse.verse > 1) {
            Navigator.of(context).pushReplacementNamed(
              VerseDetailScreen.routeName,
              arguments: {'verseId': '${verse.chapter}.${verse.verse - 1}'},
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('This is the first verse of the chapter'),
                backgroundColor: primaryColor,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        onNext: () {
          Navigator.of(context).pushReplacementNamed(
            VerseDetailScreen.routeName,
            arguments: {'verseId': '${verse.chapter}.${verse.verse + 1}'},
          );
        },
        onPositionChanged: (value) {
          _seekTo(value);
        },
        onTogglePlayback: _togglePlayback,
        playbackPosition: _playbackPosition,
        position: _position,
        duration: _duration,
        primaryColor: primaryColor,
      ),
    );
  }
}

class _TranslationCard extends StatelessWidget {
  const _TranslationCard({
    required this.title,
    required this.translation,
    required this.primaryColor,
  });

  final String title;
  final String translation;
  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 16),
            spreadRadius: -12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: textTheme.titleSmall?.copyWith(
                  color: primaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            translation,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface,
              height: 1.6,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}

class _RecitationControlBar extends StatelessWidget {
  const _RecitationControlBar({
    required this.accuracyPercent,
    required this.playbackPosition,
    required this.isPlaying,
    required this.isLoading,
    required this.isRecording,
    required this.isTtsMode,
    required this.onTogglePlayback,
    required this.onPositionChanged,
    required this.onPlay,
    required this.onPause,
    required this.onRecord,
    required this.onRetry,
    required this.onSkipForward,
    required this.onPrevious,
    required this.onNext,
    required this.position,
    required this.duration,
    required this.primaryColor,
  });

  final int accuracyPercent;
  final double playbackPosition;
  final bool isPlaying;
  final bool isLoading;
  final bool isRecording;
  final bool isTtsMode;
  final VoidCallback onTogglePlayback;
  final ValueChanged<double> onPositionChanged;
  final VoidCallback onPlay;
  final VoidCallback onPause;
  final VoidCallback onRecord;
  final VoidCallback onRetry;
  final VoidCallback onSkipForward;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final Duration position;
  final Duration duration;
  final Color primaryColor;

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, -12),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(position),
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  _formatDuration(duration),
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: primaryColor,
                inactiveTrackColor: colorScheme.outlineVariant.withValues(alpha: 0.2),
                thumbColor: primaryColor,
                overlayColor: primaryColor.withValues(alpha: 0.2),
                trackHeight: 4,
              ),
              child: Slider(
                value: playbackPosition.clamp(0.0, 1.0),
                onChanged: onPositionChanged,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Play/Pause button
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        primaryColor,
                        primaryColor.withValues(alpha: 0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: isLoading ? null : onTogglePlayback,
                      customBorder: const CircleBorder(),
                      child: Container(
                        width: 72,
                        height: 72,
                        alignment: Alignment.center,
                        child: isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Icon(
                                isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                size: 36,
                                color: Colors.white,
                              ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 32),
                // Record button
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: isRecording
                          ? [
                              Colors.red,
                              Colors.red.withValues(alpha: 0.8),
                            ]
                          : [
                              const Color(0xFFD84315),
                              const Color(0xFFD84315).withValues(alpha: 0.8),
                            ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (isRecording ? Colors.red : const Color(0xFFD84315))
                            .withValues(alpha: 0.4),
                        blurRadius: isRecording ? 24 : 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onRecord,
                      customBorder: const CircleBorder(),
                      child: Container(
                        width: 64,
                        height: 64,
                        alignment: Alignment.center,
                        child: Icon(
                          isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
                    .animate(
                      onPlay: (controller) => isRecording
                          ? controller.repeat(reverse: true)
                          : controller.stop(),
                    )
                    .scale(
                      duration: 800.ms,
                      begin: const Offset(1.0, 1.0),
                      end: const Offset(1.1, 1.1),
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
