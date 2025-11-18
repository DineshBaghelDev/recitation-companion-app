import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/design_system.dart';
import '../providers/verse_providers.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  static const routeName = '/progress';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(progressStatsProvider);
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: AppDesignSystem.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'My Progress',
                  style: AppDesignSystem.heading(textTheme),
                ).animate().fadeIn(duration: 400.ms, curve: Curves.easeOutQuad),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Settings coming soon! Use Profile tab for account settings.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.settings_outlined),
                ),
              ],
            ),
            const SizedBox(height: AppDesignSystem.spacing20),
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    title: 'Streak',
                    value: '${stats.streakDays} Days',
                    icon: Icons.local_fire_department_outlined,
                    emphasisColor: AppDesignSystem.primaryColor,
                  ),
                ),
                const SizedBox(width: AppDesignSystem.spacing16),
                Expanded(
                  child: _MetricCard(
                    title: 'Verses Learned',
                    value: '${stats.completedVerses}',
                    icon: Icons.menu_book_outlined,
                    emphasisColor: AppDesignSystem.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDesignSystem.spacing20),
            _PronunciationCard(average: stats.averagePronunciation),
            const SizedBox(height: AppDesignSystem.spacing24),
            Text(
              'Pronunciation Score by Chapter',
              style: AppDesignSystem.subheading(textTheme),
            ),
            const SizedBox(height: AppDesignSystem.spacing8),
            Text(
              'Track your pronunciation accuracy for each chapter',
              style: AppDesignSystem.caption(textTheme, Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: AppDesignSystem.spacing12),
            // Show pronunciation scores for first 18 chapters (Bhagavad Gita)
            SizedBox(
              height: 170,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: List.generate(18, (index) {
                    final chapter = index + 1;
                    // Mock pronunciation scores - in production, fetch from backend
                    final score = (75 + (chapter * 1.2) % 25).round();
                    return Padding(
                      padding: const EdgeInsets.only(right: 24),
                      child: _ChapterPronunciationChip(
                        chapterNumber: chapter,
                        score: score,
                      ),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'My Badges',
              style: AppDesignSystem.subheading(textTheme),
            ),
            const SizedBox(height: AppDesignSystem.spacing16),
            Wrap(
              spacing: 14,
              runSpacing: 14,
              children: const [
                _BadgeChip(label: 'Fluent Reciter', isActive: true),
                _BadgeChip(label: '5-Day Streak', isActive: true),
                _BadgeChip(label: 'First Verse', isActive: true),
                _BadgeChip(label: 'Perfectionist', isActive: false),
                _BadgeChip(label: 'Scholar', isActive: false),
                _BadgeChip(label: 'Master', isActive: false),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.emphasisColor,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color emphasisColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppDesignSystem.spacing20),
      decoration: AppDesignSystem.cardDecoration(colorScheme),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: emphasisColor, size: 28),
          const SizedBox(height: AppDesignSystem.spacing16),
          Text(
            title,
            style: AppDesignSystem.body(textTheme, colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: AppDesignSystem.spacing8),
          Text(
            value,
            style: AppDesignSystem.valueText(textTheme),
          ),
        ],
      ),
    );
  }
}

class _PronunciationCard extends StatelessWidget {
  const _PronunciationCard({required this.average});

  final double average;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final percent = (average * 100).clamp(0, 100);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDesignSystem.spacing24),
      decoration: AppDesignSystem.lightCardDecoration(colorScheme),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.mic_none_outlined,
                color: AppDesignSystem.primaryColor,
                size: 28,
              ),
              const SizedBox(width: AppDesignSystem.spacing16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recent Practice Score',
                      style: AppDesignSystem.subheading(textTheme),
                    ),
                    const SizedBox(height: AppDesignSystem.spacing4),
                    Text(
                      '${percent.round()}%',
                      style: AppDesignSystem.largeValue(textTheme),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesignSystem.spacing16),
          Text(
            'Tap any verse to see syllable-by-syllable feedback during practice',
            style: AppDesignSystem.caption(textTheme, colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _ChapterPronunciationChip extends StatelessWidget {
  const _ChapterPronunciationChip({
    required this.chapterNumber,
    required this.score,
  });

  final int chapterNumber;
  final int score;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    
    // Determine color based on score
    Color scoreColor;
    if (score >= 90) {
      scoreColor = Colors.green;
    } else if (score >= 75) {
      scoreColor = AppDesignSystem.primaryColor;
    } else if (score >= 60) {
      scoreColor = Colors.orange;
    } else {
      scoreColor = Colors.red;
    }

    return Column(
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(
                  value: score / 100,
                  strokeWidth: 10,
                  backgroundColor: colorScheme.outlineVariant.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$score%',
                    style: AppDesignSystem.valueText(textTheme).copyWith(
                      fontSize: 24,
                      color: scoreColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Icon(
                    score >= 90 
                      ? Icons.star 
                      : score >= 75 
                        ? Icons.thumb_up 
                        : Icons.trending_up,
                    size: 16,
                    color: scoreColor.withValues(alpha: 0.7),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDesignSystem.spacing12),
        Text(
          'Chapter $chapterNumber',
          style: AppDesignSystem.bodyBold(textTheme).copyWith(fontSize: 13),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppDesignSystem.spacing4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: scoreColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            score >= 90 ? 'Excellent' : score >= 75 ? 'Good' : score >= 60 ? 'Fair' : 'Practice',
            style: TextStyle(
              fontSize: 10,
              color: scoreColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _BadgeChip extends StatelessWidget {
  const _BadgeChip({required this.label, required this.isActive});

  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesignSystem.spacing16,
        vertical: AppDesignSystem.spacing12,
      ),
      decoration: BoxDecoration(
        color: isActive
            ? AppDesignSystem.primaryColor.withValues(alpha: 0.12)
            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppDesignSystem.radiusMedium),
        border: isActive
            ? Border.all(
                color: AppDesignSystem.primaryColor.withValues(alpha: 0.3),
                width: 1.5,
              )
            : null,
      ),
      child: Text(
        label,
        style: AppDesignSystem.bodyBold(textTheme).copyWith(
          color: isActive ? AppDesignSystem.primaryColor : colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
