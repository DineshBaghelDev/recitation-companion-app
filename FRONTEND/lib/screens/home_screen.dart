import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/design_system.dart';
import '../models/course.dart';
import '../models/verse.dart';
import '../providers/course_providers.dart';
import '../providers/verse_providers.dart';
import '../providers/user_providers.dart';
import 'course_progress_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key, this.onMenuPressed, this.onNavigate, this.onProfilePressed});
  
  final VoidCallback? onMenuPressed;
  final ValueChanged<int>? onNavigate;
  final VoidCallback? onProfilePressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(progressStatsProvider);
    final featuredCourse = ref.watch(featuredCourseProvider);
    final coursesAsync = ref.watch(courseListProvider);
    final verseOfTheDayAsync = ref.watch(verseOfTheDayProvider);
    final userData = ref.watch(userDataProvider);
    final textTheme = Theme.of(context).textTheme;

    return Stack(
      children: [
        // Removed top gradient band so hero image can span edge-to-edge
        SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeroSection(
                  stats: stats,
                  featuredCourse: featuredCourse,
                  userName: userData.name,
                  onMenuPressed: onMenuPressed,
                  onProfilePressed: onProfilePressed,
                ).animate().fadeIn(duration: 450.ms, curve: Curves.easeOutQuad),
                Padding(
                  padding: AppDesignSystem.screenPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppDesignSystem.spacing4),
                      if (featuredCourse != null)
                        _ContinueLearningCard(
                          course: featuredCourse,
                          stats: stats,
                        ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.08),
                      const SizedBox(height: AppDesignSystem.spacing28),
                      _QuickAccessSection(
                        onNavigate: onNavigate,
                      ).animate().fadeIn(duration: 550.ms).slideY(begin: 0.05),
                      const SizedBox(height: AppDesignSystem.spacing28),
                      // Verse of the Day Card - Fetched from API
                      verseOfTheDayAsync.when(
                        data: (verse) => _VerseOfTheDayCard(
                          verse: verse,
                        ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.08),
                        loading: () => Container(
                          height: 200,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppDesignSystem.primaryColor, AppDesignSystem.accentColor],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        error: (err, stack) {
                          // Show fallback verse with error indicator
                          return Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.warning_amber, color: Colors.orange, size: 16),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Unable to load today\'s verse. Showing fallback.',
                                        style: TextStyle(color: Colors.orange.shade900, fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              const _VerseOfTheDayCard(
                                verse: Verse(
                                  chapter: 2,
                                  verse: 47,
                                  slok: 'कर्मण्येवाधिकारस्ते मा फलेषु कदाचन।\nमा कर्मफलहेतुर्भूर्मा ते सङ्गोऽस्त्वकर्मणि।।',
                                  transliteration: 'karmaṇyevādhikāraste mā phaleṣu kadācana\nmā karmaphalaheturbhūrmā te saṅgo\'stvakarmaṇi',
                                  hindiTranslation: 'तुम्हारा कर्म करने में ही अधिकार है, फल में कभी नहीं।',
                                  englishTranslation: 'You have a right to perform your prescribed duties, but you are not entitled to the fruits of your actions.',
                                  mastery: 0.95,
                                ),
                              ),
                            ],
                          ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.08);
                        },
                      ),
                      const SizedBox(height: AppDesignSystem.spacing28),
                      Text(
                        'Recommended for you',
                        style: AppDesignSystem.subheading(textTheme),
                      ),
                      const SizedBox(height: AppDesignSystem.spacing16),
                      coursesAsync.when(
                        data: (courses) => Column(
                          children: courses.take(3).map(
                            (course) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _CoursePreviewCard(course: course),
                            ),
                          ).toList(),
                        ),
                        loading: () => const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        error: (_, __) => const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text('Unable to load courses'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ContinueLearningCard extends StatelessWidget {
  const _ContinueLearningCard({required this.course, required this.stats});

  final Course course;
  final ProgressStats stats;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDesignSystem.spacing24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDesignSystem.radiusXLarge),
        boxShadow: AppDesignSystem.cardShadow(Colors.black),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Continue Learning',
            style: AppDesignSystem.subheading(textTheme),
          ),
          const SizedBox(height: AppDesignSystem.spacing8),
          Text(
            course.subtitle,
            style: AppDesignSystem.body(textTheme, colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: AppDesignSystem.spacing20),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: course.percentComplete,
              minHeight: 10,
              backgroundColor: colorScheme.outlineVariant.withValues(alpha: 0.25),
              valueColor: const AlwaysStoppedAnimation<Color>(AppDesignSystem.primaryColor),
            ),
          ),
          const SizedBox(height: AppDesignSystem.spacing12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(course.percentComplete * 100).round()}% complete',
                style: AppDesignSystem.caption(textTheme, colorScheme.onSurfaceVariant).copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Streak: ${stats.streakDays} days',
                style: AppDesignSystem.caption(textTheme, AppDesignSystem.primaryColor).copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VerseOfTheDayCard extends StatelessWidget {
  const _VerseOfTheDayCard({required this.verse});

  final Verse verse;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDesignSystem.spacing24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppDesignSystem.primaryColor, AppDesignSystem.accentColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppDesignSystem.primaryColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Verse of the Day',
                style: textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesignSystem.spacing16),
          Text(
            verse.slok,
            style: textTheme.bodyLarge?.copyWith(
              color: Colors.white,
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: AppDesignSystem.spacing16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              verse.englishTranslation,
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: AppDesignSystem.spacing16),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${verse.title}',
              style: textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({
    required this.stats,
    this.featuredCourse,
    this.userName,
    this.onMenuPressed,
    this.onProfilePressed,
  });

  final ProgressStats stats;
  final Course? featuredCourse;
  final String? userName;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onProfilePressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/hero6.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.center,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(0, 255, 255, 255),
                Colors.white,
              ],
              stops: [0.45, 1.0],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App bar row with hamburger and title
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDesignSystem.spacing8,
                    vertical: AppDesignSystem.spacing8,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.menu_rounded),
                        color: Colors.black,
                        onPressed: onMenuPressed ?? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Menu feature not available'),
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            if (userName != null && userName!.isNotEmpty)
                              Text(
                                'Hello, $userName',
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.85),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  letterSpacing: 0.5,
                                ),
                              )
                            else
                              Text(
                                'SwarMitra',
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.85),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  letterSpacing: 0.5,
                                ),
                              )
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.account_circle_outlined),
                        color: Colors.black,
                        onPressed: onProfilePressed ?? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Profile feature not available'),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickAccessSection extends StatelessWidget {
  const _QuickAccessSection({this.onNavigate});
  
  final ValueChanged<int>? onNavigate;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Access',
          style: AppDesignSystem.subheading(textTheme),
        ),
        const SizedBox(height: AppDesignSystem.spacing16),
        Row(
          children: [
            Expanded(
              child: _HomeAction(
                icon: Icons.favorite_border,
                label: 'Favourites',
                onTap: () {
                  Navigator.pushNamed(context, '/favorites');
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _HomeAction(
                icon: Icons.report_problem_outlined,
                label: 'Problematic verses',
                onTap: () {
                  Navigator.pushNamed(context, '/problematic-verses');
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _HomeAction(
                icon: Icons.auto_awesome,
                label: 'AI Guru',
                onTap: () {
                  Navigator.pushNamed(context, '/ai-guru');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}


class _HomeAction extends StatelessWidget {
  const _HomeAction({required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(AppDesignSystem.radiusLarge),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.symmetric(
          vertical: AppDesignSystem.spacing12,
          horizontal: AppDesignSystem.spacing8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDesignSystem.radiusLarge),
          boxShadow: AppDesignSystem.lightShadow(Colors.black),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: AppDesignSystem.primaryColor, size: 26),
            const SizedBox(height: AppDesignSystem.spacing8),
            Flexible(
              child: Text(
                label,
                style: AppDesignSystem.bodyBold(textTheme).copyWith(fontSize: 12),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CoursePreviewCard extends StatelessWidget {
  const _CoursePreviewCard({required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(AppDesignSystem.radiusLarge),
      onTap: () {
        Navigator.of(context).pushNamed(
          CourseProgressScreen.routeName,
          arguments: course.id,
        );
      },
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDesignSystem.radiusXLarge),
          boxShadow: AppDesignSystem.cardShadow(Colors.black),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDesignSystem.spacing20),
          child: Row(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppDesignSystem.radiusMedium),
                  gradient: course.artwork.toGradient(),
                ),
                child: Icon(
                  course.artwork.icon,
                  size: 36,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: AppDesignSystem.spacing20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      style: AppDesignSystem.subheading(textTheme),
                    ),
                    const SizedBox(height: AppDesignSystem.spacing8),
                    Text(
                      course.displayVerseCount,
                      style: AppDesignSystem.caption(textTheme, colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: AppDesignSystem.spacing16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: LinearProgressIndicator(
                        value: course.percentComplete,
                        minHeight: 8,
                        backgroundColor:
                            colorScheme.outlineVariant.withValues(alpha: 0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(AppDesignSystem.primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
