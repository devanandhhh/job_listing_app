
import 'package:flutter/material.dart';

class EmptyFavorites extends StatelessWidget {
  const EmptyFavorites({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border_rounded,
                size: 56, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 12),
            const Text('No favorites yet',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(
              'Tap the heart on any job to save it here',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}