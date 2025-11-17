import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/design_system.dart';
import '../providers/user_providers.dart';

class CommunityScreen extends ConsumerWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final userData = ref.watch(userDataProvider);
    final currentUserName = userData.name ?? 'You';

    // Mock leaderboard data
    final leaderboardData = [
      LeaderboardEntry(
        rank: 1,
        name: 'Arjun Sharma',
        versesLearned: 156,
        accuracyScore: 98,
        avatar: 'AS',
        isCurrentUser: false,
      ),
      LeaderboardEntry(
        rank: 2,
        name: 'Priya Patel',
        versesLearned: 142,
        accuracyScore: 96,
        avatar: 'PP',
        isCurrentUser: false,
      ),
      LeaderboardEntry(
        rank: 3,
        name: 'Rahul Kumar',
        versesLearned: 138,
        accuracyScore: 95,
        avatar: 'RK',
        isCurrentUser: false,
      ),
      LeaderboardEntry(
        rank: 4,
        name: currentUserName,
        versesLearned: 124,
        accuracyScore: 94,
        avatar: currentUserName.isNotEmpty ? currentUserName[0].toUpperCase() : 'Y',
        isCurrentUser: true,
      ),
      LeaderboardEntry(
        rank: 5,
        name: 'Sneha Gupta',
        versesLearned: 118,
        accuracyScore: 93,
        avatar: 'SG',
        isCurrentUser: false,
      ),
      LeaderboardEntry(
        rank: 6,
        name: 'Vikram Singh',
        versesLearned: 112,
        accuracyScore: 91,
        avatar: 'VS',
        isCurrentUser: false,
      ),
      LeaderboardEntry(
        rank: 7,
        name: 'Ananya Reddy',
        versesLearned: 108,
        accuracyScore: 90,
        avatar: 'AR',
        isCurrentUser: false,
      ),
      LeaderboardEntry(
        rank: 8,
        name: 'Karthik Menon',
        versesLearned: 95,
        accuracyScore: 88,
        avatar: 'KM',
        isCurrentUser: false,
      ),
    ];

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        child: Padding(
          padding: AppDesignSystem.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Community',
                style: AppDesignSystem.heading(textTheme),
              ),
              const SizedBox(height: AppDesignSystem.spacing8),
              Text(
                'Compete with learners worldwide',
                style: AppDesignSystem.body(textTheme, colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: AppDesignSystem.spacing24),

              // Stats Overview
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.people_outline,
                      value: '2.5K',
                      label: 'Active\nLearners',
                      colorScheme: colorScheme,
                    ),
                  ),
                  const SizedBox(width: AppDesignSystem.spacing16),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.emoji_events_outlined,
                      value: '#4',
                      label: 'Your\nRank',
                      colorScheme: colorScheme,
                      isHighlight: true,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppDesignSystem.spacing32),

              // Leaderboard Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Top Learners',
                    style: AppDesignSystem.subheading(textTheme),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDesignSystem.spacing12,
                      vertical: AppDesignSystem.spacing8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B35).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppDesignSystem.radiusSmall),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.refresh,
                          size: 16,
                          color: Color(0xFFFF6B35),
                        ),
                        const SizedBox(width: AppDesignSystem.spacing4),
                        Text(
                          'Live',
                          style: AppDesignSystem.bodyBold(textTheme).copyWith(
                            color: const Color(0xFFFF6B35),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDesignSystem.spacing16),

              // Leaderboard List
              Container(
                decoration: AppDesignSystem.cardDecoration(colorScheme),
                child: Column(
                  children: [
                    // Top 3 with medals
                    ...leaderboardData.take(3).map((entry) => _LeaderboardItem(
                          entry: entry,
                          showMedal: true,
                        )),
                    
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDesignSystem.spacing16,
                      ),
                      child: Divider(height: 1),
                    ),
                    
                    // Rest of the leaderboard
                    ...leaderboardData.skip(3).map((entry) => _LeaderboardItem(
                          entry: entry,
                          showMedal: false,
                        )),
                  ],
                ),
              ),

              const SizedBox(height: AppDesignSystem.spacing24),

              // Tips Card
              Container(
                padding: const EdgeInsets.all(AppDesignSystem.spacing20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFFF6B35).withOpacity(0.1),
                      const Color(0xFFF7931E).withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppDesignSystem.radiusMedium),
                  border: Border.all(
                    color: const Color(0xFFFF6B35).withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppDesignSystem.spacing12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B35).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(AppDesignSystem.radiusSmall),
                      ),
                      child: const Icon(
                        Icons.lightbulb_outline,
                        color: Color(0xFFFF6B35),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: AppDesignSystem.spacing16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Climb the ranks!',
                            style: AppDesignSystem.bodyBold(textTheme).copyWith(
                              color: const Color(0xFFFF6B35),
                            ),
                          ),
                          const SizedBox(height: AppDesignSystem.spacing4),
                          Text(
                            'Learn more verses and improve your pronunciation accuracy to rise in the leaderboard.',
                            style: AppDesignSystem.body(
                              textTheme,
                              colorScheme.onSurfaceVariant,
                            ).copyWith(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppDesignSystem.spacing24),
            ],
          ),
        ),
      ),
    );
  }
}

class LeaderboardEntry {
  final int rank;
  final String name;
  final int versesLearned;
  final int accuracyScore;
  final String avatar;
  final bool isCurrentUser;

  LeaderboardEntry({
    required this.rank,
    required this.name,
    required this.versesLearned,
    required this.accuracyScore,
    required this.avatar,
    required this.isCurrentUser,
  });
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.colorScheme,
    this.isHighlight = false,
  });

  final IconData icon;
  final String value;
  final String label;
  final ColorScheme colorScheme;
  final bool isHighlight;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppDesignSystem.spacing20),
      decoration: BoxDecoration(
        gradient: isHighlight
            ? LinearGradient(
                colors: [
                  AppDesignSystem.primaryColor,
                  AppDesignSystem.accentColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isHighlight ? null : colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDesignSystem.radiusMedium),
        border: Border.all(
          color: isHighlight
              ? Colors.transparent
              : colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: isHighlight
            ? [
                BoxShadow(
                  color: AppDesignSystem.primaryColor.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ]
            : AppDesignSystem.lightShadow(colorScheme.shadow),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDesignSystem.spacing12),
            decoration: BoxDecoration(
              color: isHighlight
                  ? Colors.white.withOpacity(0.2)
                  : AppDesignSystem.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDesignSystem.radiusSmall),
            ),
            child: Icon(
              icon,
              color: isHighlight ? Colors.white : AppDesignSystem.primaryColor,
              size: 28,
            ),
          ),
          const SizedBox(height: AppDesignSystem.spacing12),
          Text(
            value,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isHighlight ? Colors.white : colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppDesignSystem.spacing4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppDesignSystem.body(
              textTheme,
              isHighlight
                  ? Colors.white.withOpacity(0.9)
                  : colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _LeaderboardItem extends StatelessWidget {
  const _LeaderboardItem({
    required this.entry,
    required this.showMedal,
  });

  final LeaderboardEntry entry;
  final bool showMedal;

  Color _getMedalColor() {
    switch (entry.rank) {
      case 1:
        return const Color(0xFFFFD700); // Gold
      case 2:
        return const Color(0xFFC0C0C0); // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesignSystem.spacing16,
        vertical: AppDesignSystem.spacing16,
      ),
      decoration: BoxDecoration(
        color: entry.isCurrentUser
            ? AppDesignSystem.primaryColor.withOpacity(0.05)
            : Colors.transparent,
        border: entry.isCurrentUser
            ? Border(
                left: BorderSide(
                  color: AppDesignSystem.primaryColor,
                  width: 3,
                ),
              )
            : null,
      ),
      child: Row(
        children: [
          // Rank/Medal
          SizedBox(
            width: 32,
            child: showMedal
                ? Icon(
                    Icons.emoji_events,
                    color: _getMedalColor(),
                    size: 28,
                  )
                : Text(
                    '#${entry.rank}',
                    style: AppDesignSystem.bodyBold(textTheme).copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
          ),
          const SizedBox(width: AppDesignSystem.spacing12),

          // Avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: entry.isCurrentUser
                  ? AppDesignSystem.primaryColor
                  : colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(AppDesignSystem.radiusSmall),
            ),
            child: Center(
              child: Text(
                entry.avatar,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: entry.isCurrentUser
                      ? Colors.white
                      : colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppDesignSystem.spacing12),

          // Name and stats
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        entry.name,
                        style: AppDesignSystem.bodyBold(textTheme).copyWith(
                          color: entry.isCurrentUser
                              ? AppDesignSystem.primaryColor
                              : colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (entry.isCurrentUser) ...[
                      const SizedBox(width: AppDesignSystem.spacing8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDesignSystem.spacing8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppDesignSystem.primaryColor,
                          borderRadius: BorderRadius.circular(AppDesignSystem.radiusSmall),
                        ),
                        child: Text(
                          'YOU',
                          style: textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppDesignSystem.spacing4),
                Text(
                  '${entry.versesLearned} verses • ${entry.accuracyScore}% accuracy',
                  style: AppDesignSystem.body(
                    textTheme,
                    colorScheme.onSurfaceVariant,
                  ).copyWith(fontSize: 12),
                ),
              ],
            ),
          ),

          // Score badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDesignSystem.spacing12,
              vertical: AppDesignSystem.spacing8,
            ),
            decoration: BoxDecoration(
              color: _getScoreColor(entry.accuracyScore).withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDesignSystem.radiusSmall),
              border: Border.all(
                color: _getScoreColor(entry.accuracyScore).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              '${entry.accuracyScore}%',
              style: AppDesignSystem.bodyBold(textTheme).copyWith(
                color: _getScoreColor(entry.accuracyScore),
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 95) return const Color(0xFF10B981); // Green
    if (score >= 90) return AppDesignSystem.primaryColor; // Saffron orange
    if (score >= 85) return AppDesignSystem.accentColor; // Gold orange
    return const Color(0xFFEF4444); // Red
  }
}
