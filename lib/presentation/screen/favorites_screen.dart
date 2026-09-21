import 'package:flutter/material.dart';
import 'package:job_listing_app/presentation/provider/favourite_provider.dart';
import 'package:job_listing_app/presentation/widget/job_card.dart';
import 'package:liquid_glass_bottom_nav/liquid_glass_bottom_nav.dart';
import 'package:provider/provider.dart';
import '../../core/entities/job.dart';
import 'job_details_screen.dart';

/// Shows every job the user has favorited, using the same JobCard
/// widget as the Jobs list screen for a consistent look.
/// NOTE: currently filters mockJobs — once JobProvider/API is wired in,
/// swap `mockJobs` below for the provider's live job list so favorites
/// reflect real fetched jobs, not just the hardcoded set.
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>();
    final favoriteJobs =
        mockJobs.where((job) => favorites.isFavorite(job.id)).toList();

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: Text(
              'Favorites',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ),
          Expanded(
            child: favoriteJobs.isEmpty
                ? const _EmptyFavorites()
                : ListView.builder(
                    padding: EdgeInsets.fromLTRB(
                      20,
                      4,
                      20,
                      20 + LiquidGlassNavBar.contentBottomInset,
                    ),
                    itemCount: favoriteJobs.length,
                    itemBuilder: (context, i) {
                      final job = favoriteJobs[i];
                      // Dismissible wraps the same JobCard used on the Jobs
                      // screen, so favorites look identical but keep the
                      // swipe-to-remove interaction on top.
                      return Dismissible(
                        key: ValueKey(job.id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => favorites.toggleFavorite(job.id),
                        background: Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          alignment: Alignment.centerRight,
                          decoration: BoxDecoration(
                            color: Colors.redAccent.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Icon(Icons.delete_outline_rounded,
                              color: Colors.white),
                        ),
                        child: JobCard(
                          job: job,
                          isFavorite: true,
                          onFavoriteToggle: () =>
                              favorites.toggleFavorite(job.id),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => JobDetailsScreen(job: job),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites();

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