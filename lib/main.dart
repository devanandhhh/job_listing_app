import 'package:flutter/material.dart';
import 'package:job_listing_app/presentation/provider/favourite_provider.dart';
import 'package:job_listing_app/presentation/provider/theme_provider.dart';
import 'package:job_listing_app/presentation/screen/home_shell.dart';
import 'package:job_listing_app/presentation/screen/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const JobListingApp());
}

class JobListingApp extends StatelessWidget {
  const JobListingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => FavoritesProvider()..loadFavorites(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider()..loadThemePreference(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp(
            title: 'JobFinder',
            debugShowCheckedModeBanner: false,

            theme: ThemeData(
              brightness: Brightness.light,
              useMaterial3: true,
              colorSchemeSeed: const Color.fromARGB(255, 45, 145, 65),
            ),

            darkTheme: ThemeData(
              brightness: Brightness.dark,
              useMaterial3: true,
              colorSchemeSeed: const Color.fromARGB(255, 45, 145, 65),
            ),

            themeMode: context.watch<ThemeProvider>().themeMode,

            home: const SplashScreen(
              nextScreen: HomeShell(),
            ),
          );
        },
      ),
    );
  }
}