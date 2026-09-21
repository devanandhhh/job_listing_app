import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/theme_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Basic profile header — placeholder until auth/user data exists.
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: const Icon(Icons.person_rounded, size: 34),
              ),
              const SizedBox(width: 16),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'there', // TODO: replace with real user name once auth exists
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 2),
                  Text('Job seeker', style: TextStyle(fontSize: 13)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 28),
          Text(
            'Preferences',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.4),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: SwitchListTile(
              secondary: Icon(
                themeProvider.isDarkMode
                    ? Icons.dark_mode_rounded
                    : Icons.light_mode_rounded,
              ),
              title: const Text('Dark Mode'),
              subtitle: Text(
                themeProvider.isDarkMode ? 'On' : 'Off',
                style: const TextStyle(fontSize: 12.5),
              ),
              value: themeProvider.isDarkMode,
              onChanged: (value) => themeProvider.toggleDarkMode(value),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'About',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.4),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: const Column(
              children: [
                ListTile(
                  leading: Icon(Icons.info_outline_rounded),
                  title: Text('App version'),
                  trailing: Text('1.0.0'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}