import 'package:flutter/material.dart';
import 'package:job_listing_app/presentation/screen/profile_screen.dart';

/// Top header: logo + app name, notification & profile icons,
/// a personal greeting, and a small motivational line for job seekers.
/// Mirrors the reference design's header layout.
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  static const _username = 'there';

  static const _quotes = [
    'Your next opportunity is just a search away.',
    'Every application is a step closer to yes.',
    'Great things start with a single application.',
  ];

  @override
  Widget build(BuildContext context) {
    final quote = _quotes[DateTime.now().day % _quotes.length];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: const Icon(Icons.work_rounded,
                   color: Colors.white, size: 18),
              ),
              const SizedBox(width: 8),
              const Text(
                'Jobs Here',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  // TODO: open notifications screen once it exists.
                },
                icon: const Icon(Icons.notifications_none_rounded),
                style: IconButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.6),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                ),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  child: const Icon(Icons.person_rounded, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Text(
            'Hi, $_username 👋',
            style: TextStyle(
              fontSize: 13.5,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            quote,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, height: 1.25),
          ),
        ],
      ),
    );
  }
}