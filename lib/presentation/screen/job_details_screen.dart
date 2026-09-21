// import 'package:flutter/material.dart';
// import '../../core/entities/job.dart';

// class JobDetailsScreen extends StatefulWidget {
//   final Job job;
//   const JobDetailsScreen({super.key, required this.job});

//   @override
//   State<JobDetailsScreen> createState() => _JobDetailsScreenState();
// }

// class _JobDetailsScreenState extends State<JobDetailsScreen> {
//   bool _isFavorite = false; // TODO: read from FavoritesProvider

//   @override
//   Widget build(BuildContext context) {
//     final job = widget.job;

//     return Scaffold(
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             pinned: true,
//             expandedHeight: 190,
//             actions: [
//               IconButton(
//                 onPressed: () => setState(() => _isFavorite = !_isFavorite),
//                 icon: Icon(
//                   _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
//                   color: _isFavorite ? Colors.redAccent : null,
//                 ),
//               ),
//             ],
//             flexibleSpace: FlexibleSpaceBar(
//               background: Padding(
//                 padding: const EdgeInsets.fromLTRB(20, 60, 20, 16),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(16),
//                       child: Image.network(
//                         job.logoUrl,
//                         width: 64,
//                         height: 64,
//                         fit: BoxFit.cover,
//                         errorBuilder: (_, __, ___) => Container(
//                           width: 64,
//                           height: 64,
//                           color: Theme.of(context).colorScheme.primaryContainer,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 14),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             job.title,
//                             style: const TextStyle(
//                                 fontSize: 20, fontWeight: FontWeight.w800),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             '${job.company} · ${job.location}',
//                             style: TextStyle(
//                               color: Theme.of(context)
//                                   .colorScheme
//                                   .onSurface
//                                   .withOpacity(0.65),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Wrap(
//                     spacing: 10,
//                     runSpacing: 10,
//                     children: [
//                       _InfoChip(icon: Icons.work_outline_rounded, label: job.jobType),
//                       _InfoChip(icon: Icons.payments_outlined, label: job.salary),
//                       _InfoChip(icon: Icons.timeline_rounded, label: job.experience),
//                     ],
//                   ),
//                   const SizedBox(height: 24),
//                   Text('Description',
//                       style: Theme.of(context)
//                           .textTheme
//                           .titleMedium
//                           ?.copyWith(fontWeight: FontWeight.w700)),
//                   const SizedBox(height: 8),
//                   Text(job.description, style: const TextStyle(height: 1.5)),
//                   const SizedBox(height: 24),
//                   Text('Skills',
//                       style: Theme.of(context)
//                           .textTheme
//                           .titleMedium
//                           ?.copyWith(fontWeight: FontWeight.w700)),
//                   const SizedBox(height: 10),
//                   Wrap(
//                     spacing: 8,
//                     runSpacing: 8,
//                     children: job.skills
//                         .map((s) => Chip(
//                               label: Text(s),
//                               backgroundColor: Theme.of(context)
//                                   .colorScheme
//                                   .primaryContainer,
//                             ))
//                         .toList(),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: SafeArea(
//         minimum: const EdgeInsets.all(20),
//         child: SizedBox(
//           height: 54,
//           child: ElevatedButton(
//             onPressed: () {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('Applying to ${job.title} at ${job.company}...')),
//               );
//               // TODO: url_launcher to job.applyUrl
//             },
//             style: ElevatedButton.styleFrom(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//             ),
//             child: const Text('Apply Now',
//                 style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _InfoChip extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   const _InfoChip({required this.icon, required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
//           const SizedBox(width: 6),
//           Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:job_listing_app/presentation/provider/favourite_provider.dart';
import 'package:provider/provider.dart';
import '../../core/entities/job.dart';

class JobDetailsScreen extends StatelessWidget {
  final Job job;
  const JobDetailsScreen({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>();
    final isFavorite = favorites.isFavorite(job.id);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 190,
            actions: [
              IconButton(
                onPressed: () => favorites.toggleFavorite(job.id),
                icon: Icon(
                  isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: isFavorite ? Colors.redAccent : null,
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        job.logoUrl,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 64,
                          height: 64,
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.title,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${job.company} · ${job.location}',
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.65),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _InfoChip(icon: Icons.work_outline_rounded, label: job.jobType),
                      _InfoChip(icon: Icons.payments_outlined, label: job.salary),
                      _InfoChip(icon: Icons.timeline_rounded, label: job.experience),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text('Description',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text(job.description, style: const TextStyle(height: 1.5)),
                  const SizedBox(height: 24),
                  Text('Skills',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: job.skills
                        .map((s) => Chip(
                              label: Text(s),
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(20),
        child: SizedBox(
          height: 54,
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Applying to ${job.title} at ${job.company}...')),
              );
              // TODO: url_launcher to job.applyUrl
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text('Apply Now',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}