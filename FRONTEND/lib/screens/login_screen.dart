import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../core/design_system.dart';
import 'user_info_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const routeName = '/login';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDesignSystem.spacing24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                // Hero section
                Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppDesignSystem.primaryColor,
                            AppDesignSystem.primaryColor.withValues(alpha: 0.7),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppDesignSystem.primaryColor.withValues(alpha: 0.3),
                            blurRadius: 32,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.music_note_rounded,
                        size: 56,
                        color: Colors.white,
                      ),
                    ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
                    const SizedBox(height: AppDesignSystem.spacing32),
                    Text(
                      'Welcome to',
                      style: AppDesignSystem.body(textTheme, colorScheme.onSurfaceVariant),
                    ).animate().fadeIn(delay: 200.ms),
                    const SizedBox(height: AppDesignSystem.spacing8),
                    Text(
                      'SwarMitra',
                      style: textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppDesignSystem.primaryColor,
                          ) ??
                          TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w800,
                            color: AppDesignSystem.primaryColor,
                          ),
                    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, duration: 400.ms),
                    const SizedBox(height: AppDesignSystem.spacing12),
                    Text(
                      'Your companion for mindful recitation',
                      style: AppDesignSystem.body(textTheme, AppDesignSystem.deepOrange),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(delay: 400.ms),
                  ],
                ),
                const SizedBox(height: 80),
                // Login options
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _LoginButton(
                      icon: Icons.email_outlined,
                      label: 'Continue with Email',
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(UserInfoScreen.routeName);
                      },
                      isPrimary: true,
                    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1),
                    const SizedBox(height: AppDesignSystem.spacing16),
                    _LoginButton(
                      icon: Icons.phone_outlined,
                      label: 'Continue with Phone',
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(UserInfoScreen.routeName);
                      },
                    ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.1),
                    const SizedBox(height: AppDesignSystem.spacing16),
                    _LoginButton(
                      icon: Icons.g_mobiledata_rounded,
                      label: 'Continue with Google',
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(UserInfoScreen.routeName);
                      },
                    ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.1),
                  ],
                ),
                const SizedBox(height: 40),
                // Skip link
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(UserInfoScreen.routeName);
                  },
                  child: Text(
                    'Skip for now',
                    style: AppDesignSystem.bodyBold(textTheme).copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ).animate().fadeIn(delay: 800.ms),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isPrimary = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: isPrimary ? AppDesignSystem.primaryColor : colorScheme.surface,
      borderRadius: BorderRadius.circular(AppDesignSystem.radiusMedium),
      elevation: 0,
      shadowColor: isPrimary ? AppDesignSystem.primaryColor.withValues(alpha: 0.3) : Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppDesignSystem.radiusMedium),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppDesignSystem.spacing20,
            horizontal: AppDesignSystem.spacing24,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDesignSystem.radiusMedium),
            border: isPrimary
                ? null
                : Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isPrimary ? Colors.white : colorScheme.onSurface,
                size: 24,
              ),
              const SizedBox(width: AppDesignSystem.spacing12),
              Flexible(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppDesignSystem.bodyBold(textTheme).copyWith(
                    color: isPrimary ? Colors.white : colorScheme.onSurface,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
