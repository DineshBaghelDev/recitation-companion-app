import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/ai_guru_screen.dart';
import 'screens/app_shell.dart';
import 'screens/course_progress_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/login_screen.dart';
import 'screens/problematic_verses_screen.dart';
import 'screens/user_info_screen.dart';
import 'screens/verse_detail_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Optimize Android graphics performance
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  
  runApp(const ProviderScope(child: RecitationApp()));
}

class RecitationApp extends StatelessWidget {
  const RecitationApp({super.key});

  @override
  Widget build(BuildContext context) {
  const colorSeed = Color(0xFF303F9F);
  const accent = Color(0xFFFF8F00);

    final lightScheme = ColorScheme.fromSeed(
      seedColor: colorSeed,
      brightness: Brightness.light,
    ).copyWith(secondary: accent);

    final darkScheme = ColorScheme.fromSeed(
      seedColor: colorSeed,
      brightness: Brightness.dark,
    ).copyWith(secondary: accent);

    final textTheme = GoogleFonts.notoSansTextTheme();

    return MaterialApp(
      title: 'Recitation Companion',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightScheme,
        textTheme: textTheme,
        appBarTheme: AppBarTheme(
          backgroundColor: lightScheme.surface,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: textTheme.titleLarge?.copyWith(
            color: lightScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardTheme(
          color: lightScheme.surface,
          elevation: 2,
          shadowColor: lightScheme.shadow.withValues(alpha: 0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkScheme,
        textTheme: GoogleFonts.notoSansTextTheme(
          ThemeData(brightness: Brightness.dark).textTheme,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: darkScheme.surface,
          elevation: 0,
          titleTextStyle: textTheme.titleLarge?.copyWith(
            color: darkScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardTheme(
          color: darkScheme.surface,
          elevation: 2,
          shadowColor: darkScheme.shadow.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      home: const LoginScreen(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case LoginScreen.routeName:
            return MaterialPageRoute(
              builder: (_) => const LoginScreen(),
              settings: settings,
            );
          case UserInfoScreen.routeName:
            return MaterialPageRoute(
              builder: (_) => const UserInfoScreen(),
              settings: settings,
            );
          case AppShell.routeName:
            return MaterialPageRoute(
              builder: (_) => const AppShell(),
              settings: settings,
            );
          case VerseDetailScreen.routeName:
            final verseId = settings.arguments as String?;
            return MaterialPageRoute(
              builder: (_) => VerseDetailScreen(verseId: verseId ?? ''),
              settings: settings,
            );
          case CourseProgressScreen.routeName:
            final courseId = settings.arguments as String?;
            return MaterialPageRoute(
              builder: (_) => CourseProgressScreen(courseId: courseId ?? ''),
              settings: settings,
            );
          case FavoritesScreen.routeName:
            return MaterialPageRoute(
              builder: (_) => const FavoritesScreen(),
              settings: settings,
            );
          case ProblematicVersesScreen.routeName:
            return MaterialPageRoute(
              builder: (_) => const ProblematicVersesScreen(),
              settings: settings,
            );
          case AIGuruScreen.routeName:
            return MaterialPageRoute(
              builder: (_) => const AIGuruScreen(),
              settings: settings,
            );
          default:
            return MaterialPageRoute(
              builder: (_) => const AppShell(),
              settings: settings,
            );
        }
      },
    ).animate().fadeIn(duration: 400.ms, curve: Curves.easeIn);
  }
}
