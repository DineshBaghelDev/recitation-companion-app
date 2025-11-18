import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/design_system.dart';
import '../providers/favorites_provider.dart';
import '../widgets/verse_card.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  static const routeName = '/favorites';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favourites'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
        actions: [
          if (favorites.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Clear All Favourites'),
                    content: const Text(
                      'Are you sure you want to remove all verses from your favourites?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          ref.read(favoritesProvider.notifier).clearFavorites();
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: const Text('Clear All'),
                      ),
                    ],
                  ),
                );
              },
              tooltip: 'Clear all favourites',
            ),
        ],
      ),
      body: favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: AppDesignSystem.spacing16),
                  Text(
                    'No Favourites Yet',
                    style: textTheme.titleLarge?.copyWith(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppDesignSystem.spacing8),
                  Text(
                    'Add verses to your favourites to see them here',
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: AppDesignSystem.screenPadding,
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final verse = favorites[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppDesignSystem.spacing16),
                  child: Dismissible(
                    key: Key('${verse.chapter}-${verse.verse}'),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(AppDesignSystem.radiusMedium),
                      ),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    onDismissed: (direction) {
                      ref.read(favoritesProvider.notifier).removeFavorite(verse);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Removed Chapter ${verse.chapter}, Verse ${verse.verse} from favourites',
                          ),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {
                              ref.read(favoritesProvider.notifier).addFavorite(verse);
                            },
                          ),
                        ),
                      );
                    },
                    child: VerseCard(
                      verse: verse,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/verse',
                          arguments: '${verse.chapter}.${verse.verse}',
                        );
                      },
                      onPreviewTap: () {
                        // Preview functionality (could play audio snippet)
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
