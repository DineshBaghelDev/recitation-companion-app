import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/design_system.dart';
import '../providers/user_providers.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  TimeOfDay _selectedTime = const TimeOfDay(hour: 7, minute: 0);
  String _selectedVoice = 'Calm mentor';
  String _selectedLanguage = 'English';

  final List<String> _voices = [
    'Calm mentor',
    'Clear narrator',
    'Spiritual guide',
    'Traditional chant',
  ];

  final List<String> _languages = [
    'English',
    'Hindi',
    'Sanskrit',
    'Bengali',
    'Tamil',
    'Telugu',
  ];

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFFFF6B35), // Deep saffron orange
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Daily reminder set for ${_formatTime(_selectedTime)}'),
            backgroundColor: const Color(0xFFFF6B35),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDesignSystem.radiusSmall),
            ),
          ),
        );
      }
    }
  }

  void _selectVoice(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppDesignSystem.radiusMedium),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: AppDesignSystem.spacing24),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDesignSystem.spacing24),
                  child: Row(
                    children: [
                      Text(
                        'Select Voice',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDesignSystem.spacing16),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: _voices.map((voice) => ListTile(
                            leading: Icon(
                              Icons.record_voice_over_outlined,
                              color: _selectedVoice == voice
                                  ? const Color(0xFFFF6B35)
                                  : Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                            title: Text(voice),
                            trailing: _selectedVoice == voice
                                ? const Icon(Icons.check, color: Color(0xFFFF6B35))
                                : null,
                            onTap: () {
                              setState(() {
                                _selectedVoice = voice;
                              });
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Voice changed to $voice'),
                                  backgroundColor: const Color(0xFFFF6B35),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(AppDesignSystem.radiusSmall),
                                  ),
                                ),
                              );
                            },
                          )).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _selectLanguage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppDesignSystem.radiusMedium),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: AppDesignSystem.spacing24),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDesignSystem.spacing24),
                  child: Row(
                    children: [
                      Text(
                        'Select Language',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDesignSystem.spacing16),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: _languages.map((language) => ListTile(
                            leading: Icon(
                              Icons.language_outlined,
                              color: _selectedLanguage == language
                                  ? const Color(0xFFFF6B35)
                                  : Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                            title: Text(language),
                            trailing: _selectedLanguage == language
                                ? const Icon(Icons.check, color: Color(0xFFFF6B35))
                                : null,
                            onTap: () {
                              setState(() {
                                _selectedLanguage = language;
                              });
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Language changed to $language'),
                                  backgroundColor: const Color(0xFFFF6B35),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(AppDesignSystem.radiusSmall),
                                  ),
                                ),
                              );
                            },
                          )).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final userData = ref.watch(userDataProvider);
    final userName = userData.name ?? 'User Name';
    final userInitial = userName.isNotEmpty ? userName[0].toUpperCase() : 'U';

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        child: Padding(
          padding: AppDesignSystem.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profile',
                style: AppDesignSystem.heading(textTheme),
              ),
              const SizedBox(height: AppDesignSystem.spacing24),
              
              // Profile Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppDesignSystem.spacing24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFFF6B35),
                      const Color(0xFFF7931E),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppDesignSystem.radiusMedium),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF6B35).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: CircleAvatar(
                        radius: 48,
                        backgroundColor: Colors.white,
                        child: Text(
                          userInitial,
                          style: AppDesignSystem.valueText(textTheme).copyWith(
                            color: const Color(0xFFFF6B35),
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDesignSystem.spacing20),
                    Text(
                      userName,
                      style: AppDesignSystem.subheading(textTheme).copyWith(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: AppDesignSystem.spacing24),
              
              // Preferences Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppDesignSystem.spacing24),
                decoration: AppDesignSystem.cardDecoration(colorScheme),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Preferences',
                      style: AppDesignSystem.subheading(textTheme),
                    ),
                    const SizedBox(height: AppDesignSystem.spacing20),
                    _ProfileSetting(
                      icon: Icons.notifications_outlined,
                      title: 'Daily reminder',
                      value: _formatTime(_selectedTime),
                      onTap: () => _selectTime(context),
                    ),
                    const Divider(height: 32),
                    _ProfileSetting(
                      icon: Icons.record_voice_over_outlined,
                      title: 'Preferred voice',
                      value: _selectedVoice,
                      onTap: () => _selectVoice(context),
                    ),
                    const Divider(height: 32),
                    _ProfileSetting(
                      icon: Icons.language_outlined,
                      title: 'Interface language',
                      value: _selectedLanguage,
                      onTap: () => _selectLanguage(context),
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

class _ProfileSetting extends StatelessWidget {
  const _ProfileSetting({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDesignSystem.radiusSmall),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDesignSystem.spacing4),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDesignSystem.spacing8),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35).withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDesignSystem.radiusSmall),
              ),
              child: Icon(
                icon,
                color: const Color(0xFFFF6B35),
                size: 20,
              ),
            ),
            const SizedBox(width: AppDesignSystem.spacing16),
            Expanded(
              child: Text(
                title,
                style: AppDesignSystem.body(textTheme, Theme.of(context).colorScheme.onSurface),
              ),
            ),
            Text(
              value,
              style: AppDesignSystem.bodyBold(textTheme).copyWith(
                color: AppDesignSystem.primaryColor,
              ),
            ),
            const SizedBox(width: AppDesignSystem.spacing8),
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
