import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/design_system.dart';

class AIGuruScreen extends ConsumerStatefulWidget {
  const AIGuruScreen({super.key});

  static const routeName = '/ai-guru';

  @override
  ConsumerState<AIGuruScreen> createState() => _AIGuruScreenState();
}

class _AIGuruScreenState extends ConsumerState<AIGuruScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppDesignSystem.primaryColor.withValues(alpha: 0.05),
              AppDesignSystem.accentColor.withValues(alpha: 0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'AI Guru',
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppDesignSystem.primaryColor,
                            AppDesignSystem.accentColor,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.auto_awesome,
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Beta',
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Hero Section
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppDesignSystem.primaryColor,
                      AppDesignSystem.accentColor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppDesignSystem.radiusLarge),
                  boxShadow: [
                    BoxShadow(
                      color: AppDesignSystem.primaryColor.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.psychology_outlined,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Your Personal Pronunciation Coach',
                      style: textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'AI-powered guidance to perfect your Sanskrit pronunciation',
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Tab Selection
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: _TabButton(
                        label: 'Features',
                        icon: Icons.stars,
                        isSelected: _selectedTab == 0,
                        onTap: () => setState(() => _selectedTab = 0),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _TabButton(
                        label: 'How It Works',
                        icon: Icons.info_outline,
                        isSelected: _selectedTab == 1,
                        onTap: () => setState(() => _selectedTab = 1),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: _selectedTab == 0
                      ? _buildFeaturesContent(textTheme)
                      : _buildHowItWorksContent(textTheme),
                ),
              ),

              // CTA Button
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('AI Guru will be available soon! Stay tuned.'),
                          backgroundColor: AppDesignSystem.primaryColor,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppDesignSystem.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDesignSystem.radiusMedium),
                      ),
                      elevation: 4,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.rocket_launch),
                        const SizedBox(width: 8),
                        Text(
                          'Get Early Access',
                          style: textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturesContent(TextTheme textTheme) {
    return Column(
      children: [
        _FeatureCard(
          icon: Icons.hearing,
          title: 'Pronunciation Analysis',
          description: 'AI will analyze your recorded pronunciation and provide detailed feedback',
          color: Colors.blue,
        ),
        const SizedBox(height: 12),
        _FeatureCard(
          icon: Icons.tips_and_updates,
          title: 'Personalized Suggestions',
          description: 'Get customized tips to improve specific sounds and syllables in Sanskrit',
          color: Colors.orange,
        ),
        const SizedBox(height: 12),
        _FeatureCard(
          icon: Icons.trending_up,
          title: 'Progress Tracking',
          description: 'Track your pronunciation improvement over time with AI-generated scores',
          color: Colors.green,
        ),
        const SizedBox(height: 12),
        _FeatureCard(
          icon: Icons.school,
          title: 'Guided Learning',
          description: 'Step-by-step guidance on difficult verses and complex Sanskrit sounds',
          color: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildHowItWorksContent(TextTheme textTheme) {
    return Column(
      children: [
        _StepCard(
          stepNumber: 1,
          title: 'Select a Verse',
          description: 'Choose any verse from the Bhagavad Gita you want to master',
          icon: Icons.menu_book,
        ),
        const SizedBox(height: 16),
        _StepCard(
          stepNumber: 2,
          title: 'Listen to Audio',
          description: 'Play the Sanskrit TTS audio to hear the correct pronunciation',
          icon: Icons.headphones,
        ),
        const SizedBox(height: 16),
        _StepCard(
          stepNumber: 3,
          title: 'Record Your Attempt',
          description: 'Use the recording feature to capture your pronunciation',
          icon: Icons.mic,
        ),
        const SizedBox(height: 16),
        _StepCard(
          stepNumber: 4,
          title: 'AI Analysis (Coming Soon)',
          description: 'AI will analyze your recording and compare it with the correct pronunciation',
          icon: Icons.analytics,
        ),
        const SizedBox(height: 16),
        _StepCard(
          stepNumber: 5,
          title: 'Get Feedback & Improve',
          description: 'Receive detailed feedback on specific sounds, words, and syllables to practice',
          icon: Icons.trending_up,
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(AppDesignSystem.radiusMedium),
            border: Border.all(
              color: Colors.blue[200]!,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.blue[700],
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'AI Guru is currently in development. You can already practice with audio playback and recording features!',
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.blue[900],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDesignSystem.radiusMedium),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppDesignSystem.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(AppDesignSystem.radiusMedium),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppDesignSystem.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : AppDesignSystem.lightShadow(Colors.black),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.white : AppDesignSystem.primaryColor,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: textTheme.bodyMedium?.copyWith(
                color: isSelected ? Colors.white : AppDesignSystem.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDesignSystem.radiusMedium),
        boxShadow: AppDesignSystem.lightShadow(Colors.black),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.icon,
  });

  final int stepNumber;
  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDesignSystem.radiusMedium),
        boxShadow: AppDesignSystem.lightShadow(Colors.black),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppDesignSystem.primaryColor,
                  AppDesignSystem.accentColor,
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$stepNumber',
                style: textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      size: 20,
                      color: AppDesignSystem.primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
