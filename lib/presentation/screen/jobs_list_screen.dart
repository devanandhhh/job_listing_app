import 'package:flutter/material.dart';
import 'package:job_listing_app/presentation/provider/favourite_provider.dart';
import 'package:job_listing_app/presentation/screen/profile_screen.dart';
import 'package:job_listing_app/presentation/widget/job_card.dart';
import 'package:liquid_glass_bottom_nav/liquid_glass_bottom_nav.dart';
import 'package:provider/provider.dart';
import '../../core/entities/job.dart';

import 'job_details_screen.dart';

class JobsListScreen extends StatefulWidget {
  const JobsListScreen({super.key});

  @override
  State<JobsListScreen> createState() => _JobsListScreenState();
}

class _JobsListScreenState extends State<JobsListScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  String _selectedType = 'All';
  bool _loading = false;

  final List<String> _types = const [
    'All',
    'Full-time',
    'Internship',
    'Part-time',
    'Remote',
  ];

  List<Job> get _filteredJobs {
    return mockJobs.where((job) {
      final matchesType = _selectedType == 'All' || job.jobType == _selectedType;
      final matchesQuery = _query.isEmpty ||
          job.title.toLowerCase().contains(_query.toLowerCase()) ||
          job.company.toLowerCase().contains(_query.toLowerCase());
      return matchesType && matchesQuery;
    }).toList();
  }

  Future<void> _onRefresh() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 900)); // simulate fetch
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final jobs = _filteredJobs;

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          const _HomeHeader(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Search job title or company',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: _types.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final type = _types[i];
                final selected = type == _selectedType;
                return ChoiceChip(
                  label: Text(type),
                  selected: selected,
                  onSelected: (_) => setState(() => _selectedType = type),
                  showCheckmark: false,
                  labelStyle: TextStyle(
                    color: selected
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                  selectedColor: Theme.of(context).colorScheme.primary,
                  backgroundColor:
                      Theme.of(context).colorScheme.surfaceVariant,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide.none,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : jobs.isEmpty
                      ? _EmptyState(query: _query)
                      : CustomScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          slivers: [
                            SliverToBoxAdapter(
                              child: _FeaturedSection(jobs: jobs.take(5).toList()),
                            ),
                            const SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                                child: Text(
                                  'All Jobs',
                                  style: TextStyle(
                                      fontSize: 17, fontWeight: FontWeight.w800),
                                ),
                              ),
                            ),
                            SliverPadding(
                              padding: EdgeInsets.fromLTRB(
                                20,
                                0,
                                20,
                                20 + LiquidGlassNavBar.contentBottomInset,
                              ),
                              sliver: SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, i) {
                                    final job = jobs[i];
                                    // context.watch here (not just Consumer) keeps
                                    // every card's heart in sync regardless of
                                    // which screen toggled it.
                                    final favorites =
                                        context.watch<FavoritesProvider>();
                                    final isFav = favorites.isFavorite(job.id);
                                    return JobCard(
                                      job: job,
                                      isFavorite: isFav,
                                      onFavoriteToggle: () =>
                                          favorites.toggleFavorite(job.id),
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              JobDetailsScreen(job: job),
                                        ),
                                      ),
                                    );
                                  },
                                  childCount: jobs.length,
                                ),
                              ),
                            ),
                          ],
                        ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Top header: logo + app name, notification & profile icons,
/// a personal greeting, and a small motivational line for job seekers.
/// Mirrors the reference design's header layout.
class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  // TODO: swap for the real signed-in user's name once auth is added.
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
                'JobFinder',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
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

/// Horizontal rail of bold gradient "hero" cards for the top jobs —
/// mirrors the reference design's colorful "Your Groups" row, sitting
/// above the plainer flat "All Jobs" list below it.
class _FeaturedSection extends StatelessWidget {
  final List<Job> jobs;
  const _FeaturedSection({required this.jobs});

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

class _EmptyState extends StatelessWidget {
  final String query;
  const _EmptyState({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded,
                size: 56, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 12),
            Text(
              query.isEmpty ? 'No jobs found' : 'No matches for "$query"',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}