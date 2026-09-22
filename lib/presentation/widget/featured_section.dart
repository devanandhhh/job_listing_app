import 'package:flutter/material.dart';
import 'package:job_listing_app/core/entities/job.dart';
import 'package:job_listing_app/presentation/provider/favourite_provider.dart';
import 'package:provider/provider.dart';

import '../screen/job_details_screen.dart';

/// Horizontal rail of bold gradient "hero" cards for the top jobs —
/// mirrors the reference design's colorful "Your Groups" row, sitting
/// above the plainer flat "All Jobs" list below it.
class FeaturedSection extends StatelessWidget {
  final List<Job> jobs;
  const FeaturedSection({super.key, required this.jobs});

  static const _gradients = [
    [Color(0xFF3B6DF6), Color(0xFF6C8DFF)], // blue
    [Color(0xFF8B5CF6), Color(0xFFB794F6)], // purple
    [Color(0xFFEC6A5C), Color(0xFFF3927F)], // coral
    [Color(0xFF10B981), Color(0xFF6EE7B7)], // green
  ];

  @override
  Widget build(BuildContext context) {
    if (jobs.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 4, 20, 10),
          child: Text(
            'Featured Jobs',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
        ),
        SizedBox(
          height: 176,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: jobs.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final job = jobs[i];
              final favorites = context.watch<FavoritesProvider>();
              return _FeaturedJobCard(
                job: job,
                gradient: _gradients[i % _gradients.length],
                isFavorite: favorites.isFavorite(job.id),
                onFavoriteToggle: () => favorites.toggleFavorite(job.id),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => JobDetailsScreen(job: job)),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _FeaturedJobCard extends StatelessWidget {
  final Job job;
  final List<Color> gradient;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;

  const _FeaturedJobCard({
    required this.job,
    required this.gradient,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        width: 240,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: gradient.last.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 36,
                    height: 36,
                    color: Colors.white,
                    child: Image.network(
                      job.logoUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.business_rounded, size: 18),
                    ),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onFavoriteToggle,
                  child: Icon(
                    isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              job.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 15.5,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              job.company,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 12.5),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.22),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      job.jobType,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.arrow_forward_rounded,
                      size: 15, color: gradient.last),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}