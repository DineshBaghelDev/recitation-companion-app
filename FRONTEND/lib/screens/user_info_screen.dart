import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/design_system.dart';
import '../providers/user_providers.dart';
import 'app_shell.dart';

class UserInfoScreen extends ConsumerStatefulWidget {
  const UserInfoScreen({super.key});

  static const routeName = '/user-info';

  @override
  ConsumerState<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends ConsumerState<UserInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _selectedLanguage = 'English';
  String _selectedGoal = 'Daily Practice';

  final List<String> _languages = [
    'English',
    'Hindi',
    'Sanskrit',
    'Bengali',
    'Tamil',
    'Telugu',
  ];
  
  // Languages that are currently available
  final List<String> _availableLanguages = [
    'English',
    'Hindi',
  ];

  final List<String> _goals = [
    'Daily Practice',
    'Learn Basics',
    'Master Recitation',
    'Spiritual Growth',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveAndContinue() {
    if (_formKey.currentState!.validate()) {
      // Save user data to provider
      ref.read(userDataProvider.notifier).setUserInfo(
            name: _nameController.text.trim(),
            language: _selectedLanguage,
            goal: _selectedGoal,
          );

      // Navigate to home
      Navigator.of(context).pushReplacementNamed(AppShell.routeName);
    }
  }
  
  void _showNotifyMeDialog(String language) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.notifications_none, color: AppDesignSystem.primaryColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '$language Coming Soon!',
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'We\'re working hard to add $language support.',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Text(
              'Would you like to be notified when it becomes available?',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Maybe Later'),
          ),
          FilledButton.icon(
            onPressed: () {
              // TODO: Save notification preference
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('We\'ll notify you when $language is available!'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(Icons.notifications_active, size: 18),
            label: const Text('Notify Me'),
            style: FilledButton.styleFrom(
              backgroundColor: AppDesignSystem.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDesignSystem.spacing24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                // Header
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tell us about yourself',
                      style: textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppDesignSystem.primaryColor,
                          ) ??
                          TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: AppDesignSystem.primaryColor,
                          ),
                    ).animate().fadeIn().slideX(begin: -0.1),
                    const SizedBox(height: AppDesignSystem.spacing8),
                    Text(
                      'Help us personalize your experience',
                      style: AppDesignSystem.body(textTheme, AppDesignSystem.deepOrange),
                    ).animate().fadeIn(delay: 100.ms),
                  ],
                ),
                const SizedBox(height: 48),
                // Name field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Name',
                      style: AppDesignSystem.bodyBold(textTheme).copyWith(
                        color: const Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: AppDesignSystem.spacing8),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Enter your name',
                        hintStyle: TextStyle(color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
                        filled: true,
                        fillColor: colorScheme.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppDesignSystem.radiusMedium),
                          borderSide: BorderSide(color: colorScheme.outlineVariant),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppDesignSystem.radiusMedium),
                          borderSide: BorderSide(color: colorScheme.outlineVariant),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppDesignSystem.radiusMedium),
                          borderSide: const BorderSide(color: AppDesignSystem.primaryColor, width: 2),
                        ),
                        contentPadding: const EdgeInsets.all(AppDesignSystem.spacing20),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
                  ],
                ),
                const SizedBox(height: AppDesignSystem.spacing28),
                // Language dropdown
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Preferred Language',
                      style: AppDesignSystem.bodyBold(textTheme).copyWith(
                        color: const Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: AppDesignSystem.spacing8),
                    DropdownButtonFormField<String>(
                      value: _selectedLanguage,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: colorScheme.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppDesignSystem.radiusMedium),
                          borderSide: BorderSide(color: colorScheme.outlineVariant),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppDesignSystem.radiusMedium),
                          borderSide: BorderSide(color: colorScheme.outlineVariant),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppDesignSystem.radiusMedium),
                          borderSide: const BorderSide(color: AppDesignSystem.primaryColor, width: 2),
                        ),
                        contentPadding: const EdgeInsets.all(AppDesignSystem.spacing20),
                      ),
                      items: _languages.map((language) {
                        final isAvailable = _availableLanguages.contains(language);
                        return DropdownMenuItem(
                          value: language,
                          enabled: isAvailable,
                          onTap: !isAvailable ? () => _showNotifyMeDialog(language) : null,
                          child: Row(
                            children: [
                              Text(
                                language,
                                style: TextStyle(
                                  color: isAvailable 
                                    ? null 
                                    : colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                                ),
                              ),
                              if (!isAvailable) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade100,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'Soon',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.orange.shade800,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (_availableLanguages.contains(value)) {
                          setState(() {
                            _selectedLanguage = value!;
                          });
                        } else {
                          // Show notify me dialog
                          _showNotifyMeDialog(value!);
                        }
                      },
                    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),
                  ],
                ),
                const SizedBox(height: AppDesignSystem.spacing28),
                // Goal selection
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Goal',
                      style: AppDesignSystem.bodyBold(textTheme).copyWith(
                        color: const Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: AppDesignSystem.spacing12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: _goals.map((goal) {
                        final isSelected = _selectedGoal == goal;
                        return FilterChip(
                          label: Text(goal),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedGoal = goal;
                            });
                          },
                          backgroundColor: colorScheme.surface,
                          selectedColor: AppDesignSystem.primaryColor.withValues(alpha: 0.15),
                          checkmarkColor: AppDesignSystem.primaryColor,
                          labelStyle: AppDesignSystem.body(textTheme, 
                            isSelected ? AppDesignSystem.primaryColor : colorScheme.onSurface,
                          ).copyWith(fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500),
                          side: BorderSide(
                            color: isSelected ? AppDesignSystem.primaryColor : colorScheme.outlineVariant,
                            width: isSelected ? 2 : 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppDesignSystem.radiusMedium),
                          ),
                        );
                      }).toList(),
                    ).animate().fadeIn(delay: 400.ms),
                  ],
                ),
                const SizedBox(height: 48),
                // Continue button
                FilledButton(
                  onPressed: _saveAndContinue,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppDesignSystem.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: AppDesignSystem.spacing20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDesignSystem.radiusMedium),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: AppDesignSystem.bodyBold(textTheme).copyWith(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
