import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/design_system.dart';

class ProblematicVersesScreen extends ConsumerWidget {
  const ProblematicVersesScreen({super.key});

  static const routeName = '/problematic-verses';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    // Dummy data for problematic verses
    final problematicVerses = [
      _ProblematicVerseItem(
        chapter: 2,
        verse: 47,
        attempts: 8,
        averageScore: 65,
        lastAttempt: DateTime.now().subtract(const Duration(hours: 3)),
        difficulty: 'Hard',
        problematicWords: ['कर्मण्येवाधिकारस्ते', 'मा फलेषु'],
      ),
      _ProblematicVerseItem(
        chapter: 3,
        verse: 14,
        attempts: 5,
        averageScore: 58,
        lastAttempt: DateTime.now().subtract(const Duration(days: 1)),
        difficulty: 'Very Hard',
        problematicWords: ['अन्नाद्भवन्ति', 'पर्जन्यादन्नसम्भवः', 'यज्ञः'],
      ),
      _ProblematicVerseItem(
        chapter: 1,
        verse: 23,
        attempts: 6,
        averageScore: 72,
        lastAttempt: DateTime.now().subtract(const Duration(hours: 12)),
        difficulty: 'Medium',
        problematicWords: ['योत्स्यमानान्', 'अवेक्षेऽहम्'],
      ),
      _ProblematicVerseItem(
        chapter: 4,
        verse: 7,
        attempts: 4,
        averageScore: 68,
        lastAttempt: DateTime.now().subtract(const Duration(days: 2)),
        difficulty: 'Hard',
        problematicWords: ['यदा यदा', 'धर्मस्य ग्लानिर्भवति'],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Problematic Verses'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        padding: AppDesignSystem.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppDesignSystem.primaryColor.withValues(alpha: 0.1),
                    AppDesignSystem.accentColor.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppDesignSystem.radiusMedium),
                border: Border.all(
                  color: AppDesignSystem.primaryColor.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppDesignSystem.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Verses needing attention',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Focus on these verses to improve your pronunciation',
                          style: textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Stats Row
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.analytics_outlined,
                    label: 'Total',
                    value: problematicVerses.length.toString(),
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.trending_down,
                    label: 'Avg Score',
                    value: '66%',
                    color: Colors.red,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.repeat,
                    label: 'Avg Attempts',
                    value: '5.8',
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Section Header
            Text(
              'Verses List',
              style: AppDesignSystem.subheading(textTheme),
            ),
            const SizedBox(height: 16),

            // List of problematic verses
            ...problematicVerses.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _ProblematicVerseCard(item: item),
            )),
            
            const SizedBox(height: 24),
            
            // Tips Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(AppDesignSystem.radiusMedium),
                border: Border.all(
                  color: Colors.blue[200]!,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: Colors.blue[700],
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Tips to Improve',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _TipItem(text: 'Practice daily for 10-15 minutes'),
                  _TipItem(text: 'Listen to the audio multiple times'),
                  _TipItem(text: 'Break complex verses into smaller parts'),
                  _TipItem(text: 'Record yourself and compare with the original'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProblematicVerseItem {
  final int chapter;
  final int verse;
  final int attempts;
  final int averageScore;
  final DateTime lastAttempt;
  final String difficulty;
  final List<String> problematicWords;

  _ProblematicVerseItem({
    required this.chapter,
    required this.verse,
    required this.attempts,
    required this.averageScore,
    required this.lastAttempt,
    required this.difficulty,
    required this.problematicWords,
  });
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDesignSystem.radiusMedium),
        boxShadow: AppDesignSystem.lightShadow(Colors.black),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ProblematicVerseCard extends StatelessWidget {
  const _ProblematicVerseCard({required this.item});

  final _ProblematicVerseItem item;

  Color _getDifficultyColor() {
    switch (item.difficulty) {
      case 'Very Hard':
        return Colors.red;
      case 'Hard':
        return Colors.orange;
      case 'Medium':
        return Colors.amber;
      default:
        return Colors.green;
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inMinutes}m ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/verse',
          arguments: '${item.chapter}.${item.verse}',
        );
      },
      borderRadius: BorderRadius.circular(AppDesignSystem.radiusMedium),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDesignSystem.radiusMedium),
          boxShadow: AppDesignSystem.lightShadow(Colors.black),
          border: Border.all(
            color: _getDifficultyColor().withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppDesignSystem.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Chapter ${item.chapter} : Verse ${item.verse}',
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getDifficultyColor().withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    item.difficulty,
                    style: textTheme.bodySmall?.copyWith(
                      color: _getDifficultyColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _InfoChip(
                  icon: Icons.repeat,
                  label: '${item.attempts} attempts',
                ),
                const SizedBox(width: 12),
                _InfoChip(
                  icon: Icons.score,
                  label: '${item.averageScore}% avg',
                ),
                const SizedBox(width: 12),
                _InfoChip(
                  icon: Icons.access_time,
                  label: _getTimeAgo(item.lastAttempt),
                ),
              ],
            ),
            if (item.problematicWords.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.red[200]!,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          size: 16,
                          color: Colors.red[700],
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Problematic Words:',
                          style: textTheme.bodySmall?.copyWith(
                            color: Colors.red[900],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: item.problematicWords.map((word) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red[100],
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: Colors.red[300]!,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            word,
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.red[900],
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}

class _TipItem extends StatelessWidget {
  const _TipItem({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            size: 20,
            color: Colors.blue[700],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.blue[900],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
