import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/async_view.dart';
import '../../data/models/match.dart';
import '../../data/services/app_services.dart';
import 'widgets/home_header.dart';
import 'widgets/match_card.dart';
import 'widgets/promo_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.onViewAll});

  /// Switches the bottom nav to the Matches tab.
  final VoidCallback onViewAll;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Match>> _matchesFuture;

  @override
  void initState() {
    super.initState();
    _matchesFuture = AppServices.matches.getMatches();
  }

  Future<void> _refresh() async {
    final future = AppServices.matches.getMatches();
    setState(() => _matchesFuture = future);
    await future;
  }

  void _comingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature is coming soon')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: _refresh,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            HomeHeader(
              onSearch: () => _comingSoon('Search'),
              onNotifications: () => _comingSoon('Notifications'),
            ),
            const SizedBox(height: 20),
            const PromoBanner(),
            const SizedBox(height: 22),
            Row(
              children: [
                const Text(
                  'Matches',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
                const Spacer(),
                TextButton(
                  onPressed: widget.onViewAll,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('View All'),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward, size: 16),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            AsyncView<List<Match>>(
              future: _matchesFuture,
              onRetry: _refresh,
              builder: (context, matches) {
                // Home shows what's happening now and next.
                final featured = [
                  ...matches.where((m) => m.status == MatchStatus.live),
                  ...matches.where((m) => m.status == MatchStatus.upcoming),
                ];
                return Column(
                  children: [
                    for (final match in featured) ...[
                      MatchCard(match: match),
                      const SizedBox(height: 12),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
