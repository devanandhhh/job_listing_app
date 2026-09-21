import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Holds the set of favorited job IDs and persists them to disk.
/// Location: lib/presentation/providers/favorites_provider.dart
class FavoritesProvider extends ChangeNotifier {
  static const _storageKey = 'favorite_job_ids';

  final Set<String> _favoriteIds = {};
  bool _loaded = false;

  Set<String> get favoriteIds => _favoriteIds;
  bool get isLoaded => _loaded;

  /// Call once at app startup (e.g. in main.dart before runApp,
  /// or immediately after the provider is created).
  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_storageKey) ?? [];
    _favoriteIds
      ..clear()
      ..addAll(saved);
    _loaded = true;
    notifyListeners();
  }

  bool isFavorite(String jobId) => _favoriteIds.contains(jobId);

  Future<void> toggleFavorite(String jobId) async {
    if (_favoriteIds.contains(jobId)) {
      _favoriteIds.remove(jobId);
    } else {
      _favoriteIds.add(jobId);
    }
    notifyListeners(); // update UI immediately, don't wait on disk write
    await _persist();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storageKey, _favoriteIds.toList());
  }
}