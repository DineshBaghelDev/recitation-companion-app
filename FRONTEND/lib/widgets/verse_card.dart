import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../models/verse.dart';
import '../core/design_system.dart';

class VerseCard extends StatelessWidget {
  const VerseCard({
    super.key,
    required this.verse,
    required this.onTap,
    required this.onPreviewTap,
  });

  final Verse verse;
  final VoidCallback onTap;
  final VoidCallback onPreviewTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final masteredPercent = (verse.mastery.clamp(0, 1) * 100).round();

    return Card(
      margin: EdgeInsets.zero,
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          verse.title,
                          style: AppDesignSystem.subheading(Theme.of(context).textTheme),
                        ),
                        const SizedBox(height: 6),
                        Chip(
                          label: Text('Chapter ${verse.chapter}'),
                          backgroundColor: colorScheme.secondary.withValues(alpha: 0.15),
                          labelStyle: AppDesignSystem.caption(Theme.of(context).textTheme, colorScheme.secondary),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.play_arrow_rounded),
                    tooltip: 'Preview audio',
                    onPressed: onPreviewTap,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LinearPercentIndicator(
                lineHeight: 12,
                percent: verse.mastery.clamp(0, 1),
                animation: true,
                animationDuration: 600,
                barRadius: const Radius.circular(12),
                backgroundColor: colorScheme.outlineVariant.withValues(alpha: 0.2),
                progressColor: colorScheme.primary,
                padding: EdgeInsets.zero,
              ),
              const SizedBox(height: 10),
              Text(
                '$masteredPercent% mastered',
                style: AppDesignSystem.caption(Theme.of(context).textTheme, colorScheme.onSurfaceVariant).copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
