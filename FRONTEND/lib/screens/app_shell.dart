import 'package:flutter/material.dart';

import '../core/design_system.dart';
import 'community_screen.dart';
import 'home_screen.dart';
import 'learn_screen.dart';
import 'profile_screen.dart';
import 'progress_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  static const routeName = '/home';

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }
  
  List<Widget> get _tabs => [
    HomeScreen(
      onMenuPressed: _openDrawer,
      onNavigate: (index) {
        setState(() => _currentIndex = index);
      },
      onProfilePressed: () {
        setState(() => _currentIndex = 4); // Navigate to Profile tab
      },
    ),
    const LearnScreen(),
    const ProgressScreen(),
    const CommunityScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      key: _scaffoldKey,
      extendBody: true,
      drawer: _AppDrawer(
        currentIndex: _currentIndex,
        onNavigate: (index) {
          setState(() => _currentIndex = index);
          Navigator.pop(context); // Close drawer
        },
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs.map((tab) {
          // Pass the drawer opener to HomeScreen
          if (tab is HomeScreen) {
            return HomeScreen(onMenuPressed: _openDrawer);
          }
          return tab;
        }).toList(),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, 4),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavButton(
                icon: Icons.home_outlined,
                activeIcon: Icons.home_rounded,
                isSelected: _currentIndex == 0,
                onTap: () => setState(() => _currentIndex = 0),
              ),
              _buildNavButton(
                icon: Icons.school_outlined,
                activeIcon: Icons.school_rounded,
                isSelected: _currentIndex == 1,
                onTap: () => setState(() => _currentIndex = 1),
              ),
              _buildNavButton(
                icon: Icons.insights_outlined,
                activeIcon: Icons.insights_rounded,
                isSelected: _currentIndex == 2,
                onTap: () => setState(() => _currentIndex = 2),
              ),
              _buildNavButton(
                icon: Icons.people_outline,
                activeIcon: Icons.people_rounded,
                isSelected: _currentIndex == 3,
                onTap: () => setState(() => _currentIndex = 3),
              ),
              _buildNavButton(
                icon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
                isSelected: _currentIndex == 4,
                onTap: () => setState(() => _currentIndex = 4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required IconData activeIcon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected
              ? AppDesignSystem.primaryColor.withValues(alpha: 0.15)
              : Colors.transparent,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppDesignSystem.primaryColor.withValues(alpha: 0.25),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Icon(
          isSelected ? activeIcon : icon,
          color: isSelected
              ? AppDesignSystem.primaryColor
              : Theme.of(context).colorScheme.onSurfaceVariant,
          size: 24,
        ),
      ),
    );
  }
}

class _AppDrawer extends StatelessWidget {
  const _AppDrawer({
    required this.currentIndex,
    required this.onNavigate,
  });

  final int currentIndex;
  final Function(int) onNavigate;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppDesignSystem.primaryColor, AppDesignSystem.accentColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.auto_stories,
                    size: 48,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'SwarMitra',
                    style: textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Recitation Companion',
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            // Menu Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _DrawerItem(
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home_rounded,
                    label: 'Home',
                    isSelected: currentIndex == 0,
                    onTap: () => onNavigate(0),
                  ),
                  _DrawerItem(
                    icon: Icons.school_outlined,
                    activeIcon: Icons.school_rounded,
                    label: 'Learn',
                    isSelected: currentIndex == 1,
                    onTap: () => onNavigate(1),
                  ),
                  _DrawerItem(
                    icon: Icons.insights_outlined,
                    activeIcon: Icons.insights_rounded,
                    label: 'My Progress',
                    isSelected: currentIndex == 2,
                    onTap: () => onNavigate(2),
                  ),
                  _DrawerItem(
                    icon: Icons.people_outline,
                    activeIcon: Icons.people_rounded,
                    label: 'Community',
                    isSelected: currentIndex == 3,
                    onTap: () => onNavigate(3),
                  ),
                  _DrawerItem(
                    icon: Icons.person_outline_rounded,
                    activeIcon: Icons.person_rounded,
                    label: 'Profile',
                    isSelected: currentIndex == 4,
                    onTap: () => onNavigate(4),
                  ),
                  const Divider(height: 32),
                  _DrawerItem(
                    icon: Icons.favorite_border,
                    activeIcon: Icons.favorite,
                    label: 'Favourites',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/favorites');
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.settings_outlined,
                    activeIcon: Icons.settings,
                    label: 'Settings',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/profile');
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.info_outline,
                    activeIcon: Icons.info,
                    label: 'About',
                    onTap: () {
                      Navigator.pop(context);
                      showAboutDialog(
                        context: context,
                        applicationName: 'SwarMitra',
                        applicationVersion: '1.0.0',
                        applicationIcon: const Icon(Icons.auto_stories, size: 48, color: AppDesignSystem.primaryColor),
                        children: [
                          const Text('Your companion for learning Vedic recitation with proper pronunciation.'),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.onTap,
    this.isSelected = false,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        isSelected ? activeIcon : icon,
        color: isSelected ? AppDesignSystem.primaryColor : null,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: isSelected ? AppDesignSystem.primaryColor : null,
        ),
      ),
      selected: isSelected,
      selectedTileColor: AppDesignSystem.primaryColor.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      onTap: onTap,
    );
  }
}
