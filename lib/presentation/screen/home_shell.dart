import 'package:flutter/material.dart';
import 'package:liquid_glass_bottom_nav/liquid_glass_bottom_nav.dart';
import 'jobs_list_screen.dart';
import 'favorites_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  // IndexedStack keeps both tabs alive so scroll position / search text persist.
  final _screens = const [
    JobsListScreen(),
    FavoritesScreen(),
  ];

  static const _items = [
    LiquidGlassNavItem(id: 'jobs', icon: Icons.work_rounded, label: 'Jobs'),
    LiquidGlassNavItem(
        id: 'favorites', icon: Icons.favorite_rounded, label: 'Favorites'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Stack(
  children: [
    Positioned.fill(
      child: IndexedStack(
        index: _index,
        children: _screens,
      ),
    ),

    Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: 210,
        child: LiquidGlassNavBar(
          dragRainbowBorder: true,
          items: _items,
          selectedIndex: _index,
          onTap: (i) => setState(() => _index = i),
        ),
      ),
    ),
  ],
),
    );
  }
}