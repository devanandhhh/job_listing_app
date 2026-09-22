import 'package:flutter/material.dart';
import 'package:job_listing_app/presentation/provider/favourite_provider.dart';
import 'package:job_listing_app/presentation/widget/featured_section.dart';
import 'package:job_listing_app/presentation/widget/home_header.dart';
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
      final matchesType =
          _selectedType == 'All' || job.jobType == _selectedType;
      final matchesQuery =
          _query.isEmpty ||
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
          const HomeHeader(),
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
              separatorBuilder: (_, _) => const SizedBox(width: 8),
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
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest,
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
                          child: FeaturedSection(jobs: jobs.take(5).toList()),
                        ),
                        const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                            child: Text(
                              'All Jobs',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                              ),
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
                            delegate: SliverChildBuilderDelegate((context, i) {
                              final job = jobs[i];
                              // context.watch here (not just Consumer) keeps
                              // every card's heart in sync regardless of
                              // which screen toggled it.
                              final favorites = context
                                  .watch<FavoritesProvider>();
                              final isFav = favorites.isFavorite(job.id);
                              return JobCard(
                                job: job,
                                isFavorite: isFav,
                                onFavoriteToggle: () =>
                                    favorites.toggleFavorite(job.id),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => JobDetailsScreen(job: job),
                                  ),
                                ),
                              );
                            }, childCount: jobs.length),
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
            Icon(
              Icons.search_off_rounded,
              size: 56,
              color: Theme.of(context).colorScheme.outline,
            ),
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
