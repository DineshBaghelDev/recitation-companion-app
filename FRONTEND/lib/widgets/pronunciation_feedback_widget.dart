import 'package:flutter/material.dart';
import '../core/design_system.dart';

/// Model for syllable pronunciation feedback
class SyllableFeedback {
  final String syllable;
  final double accuracy; // 0.0 to 1.0
  final String? tip;
  final int position;

  const SyllableFeedback({
    required this.syllable,
    required this.accuracy,
    this.tip,
    required this.position,
  });

  Color get feedbackColor {
    if (accuracy >= 0.9) {
      return Colors.green;
    } else if (accuracy >= 0.7) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  String get accuracyLabel {
    if (accuracy >= 0.9) {
      return 'Excellent';
    } else if (accuracy >= 0.7) {
      return 'Good';
    } else {
      return 'Needs Practice';
    }
  }
}

/// Widget that displays pronunciation feedback for individual syllables
class PronunciationFeedbackWidget extends StatelessWidget {
  const PronunciationFeedbackWidget({
    super.key,
    required this.syllables,
    required this.overallScore,
    this.onRetry,
  });

  final List<SyllableFeedback> syllables;
  final double overallScore;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDesignSystem.spacing24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDesignSystem.radiusXLarge),
        boxShadow: AppDesignSystem.cardShadow(Colors.black),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Pronunciation',
                    style: AppDesignSystem.subheading(textTheme),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${(overallScore * 100).round()}% Overall',
                    style: AppDesignSystem.largeValue(textTheme).copyWith(
                      color: _getScoreColor(overallScore),
                    ),
                  ),
                ],
              ),
              if (onRetry != null)
                IconButton(
                  icon: const Icon(Icons.replay),
                  onPressed: onRetry,
                  tooltip: 'Practice again',
                  color: AppDesignSystem.primaryColor,
                ),
            ],
          ),
          const SizedBox(height: AppDesignSystem.spacing20),

          // Legend
          Row(
            children: [
              _LegendItem(
                color: Colors.green,
                label: 'Excellent (90%+)',
              ),
              const SizedBox(width: 12),
              _LegendItem(
                color: Colors.orange,
                label: 'Good (70-89%)',
              ),
              const SizedBox(width: 12),
              _LegendItem(
                color: Colors.red,
                label: 'Practice (<70%)',
              ),
            ],
          ),
          const SizedBox(height: AppDesignSystem.spacing16),

          // Syllable breakdown
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: syllables.map((syllable) {
              return _SyllableChip(
                syllable: syllable,
                onTap: () => _showSyllableDetail(context, syllable),
              );
            }).toList(),
          ),

          const SizedBox(height: AppDesignSystem.spacing20),

          // Tips section
          if (syllables.any((s) => s.tip != null)) ...[
            Container(
              padding: const EdgeInsets.all(AppDesignSystem.spacing16),
              decoration: BoxDecoration(
                color: AppDesignSystem.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDesignSystem.radiusMedium),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: AppDesignSystem.primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Improvement Tips',
                        style: AppDesignSystem.bodyBold(textTheme).copyWith(
                          color: AppDesignSystem.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...syllables
                      .where((s) => s.tip != null)
                      .take(3)
                      .map((s) => Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              '• ${s.syllable}: ${s.tip}',
                              style: AppDesignSystem.body(
                                textTheme,
                                colorScheme.onSurface,
                              ),
                            ),
                          )),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 0.9) return Colors.green;
    if (score >= 0.7) return Colors.orange;
    return Colors.red;
  }

  void _showSyllableDetail(BuildContext context, SyllableFeedback syllable) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppDesignSystem.radiusMedium),
          ),
        ),
        padding: const EdgeInsets.all(AppDesignSystem.spacing24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              syllable.syllable,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: syllable.feedbackColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    syllable.accuracyLabel,
                    style: TextStyle(
                      color: syllable.feedbackColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${(syllable.accuracy * 100).round()}%',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            if (syllable.tip != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppDesignSystem.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.tips_and_updates,
                      color: AppDesignSystem.primaryColor,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        syllable.tip!,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                style: FilledButton.styleFrom(
                  backgroundColor: AppDesignSystem.primaryColor,
                ),
                child: const Text('Got it'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SyllableChip extends StatelessWidget {
  const _SyllableChip({
    required this.syllable,
    required this.onTap,
  });

  final SyllableFeedback syllable;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: syllable.feedbackColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: syllable.feedbackColor.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              syllable.syllable,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '${(syllable.accuracy * 100).round()}%',
              style: TextStyle(
                fontSize: 12,
                color: syllable.feedbackColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
  });

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
