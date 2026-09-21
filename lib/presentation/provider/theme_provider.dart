// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// /// Holds and persists the app's dark/light mode preference.
// /// Location: lib/presentation/provider/theme_provider.dart
// class ThemeProvider extends ChangeNotifier {
//   static const _storageKey = 'is_dark_mode';

//   bool _isDarkMode = false;
//   bool get isDarkMode => _isDarkMode;

//   ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

//   /// Call once at app startup, same as FavoritesProvider.loadFavorites().
//   Future<void> loadThemePreference() async {
//     final prefs = await SharedPreferences.getInstance();
//     _isDarkMode = prefs.getBool(_storageKey) ?? false;
//     notifyListeners();
//   }

//   Future<void> toggleDarkMode(bool value) async {
//     _isDarkMode = value;
//     notifyListeners(); // update UI immediately, don't wait on disk write
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool(_storageKey, value);
//   }
// }
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const _storageKey = 'is_dark_mode';

  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeMode get themeMode =>
      _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  Future<void> loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();

    _isDarkMode = prefs.getBool(_storageKey) ?? false;

    notifyListeners();
  }

  Future<void> toggleDarkMode(bool value) async {
    _isDarkMode = value;

    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_storageKey, value);
  }
}