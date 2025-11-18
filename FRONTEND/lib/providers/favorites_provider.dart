import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/verse.dart';

/// StateNotifier to manage favorite verses
class FavoritesNotifier extends StateNotifier<List<Verse>> {
  FavoritesNotifier() : super([]);

  /// Add a verse to favorites
  void addFavorite(Verse verse) {
    if (!state.any((v) => v.chapter == verse.chapter && v.verse == verse.verse)) {
      state = [...state, verse];
    }
  }

  /// Remove a verse from favorites
  void removeFavorite(Verse verse) {
    state = state
        .where((v) => !(v.chapter == verse.chapter && v.verse == verse.verse))
        .toList();
  }

  /// Check if a verse is in favorites
  bool isFavorite(Verse verse) {
    return state.any((v) => v.chapter == verse.chapter && v.verse == verse.verse);
  }

  /// Toggle favorite status
  void toggleFavorite(Verse verse) {
    if (isFavorite(verse)) {
      removeFavorite(verse);
    } else {
      addFavorite(verse);
    }
  }

  /// Clear all favorites
  void clearFavorites() {
    state = [];
  }
}

/// Provider for favorite verses
final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<Verse>>((ref) {
  return FavoritesNotifier();
});
