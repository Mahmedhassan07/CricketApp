import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/async_view.dart';
import '../../core/widgets/placeholder_view.dart';
import '../../data/models/match.dart';
import '../../data/services/app_services.dart';
import '../home/widgets/match_card.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  late Future<List<Match>> _matchesFuture;

  /// null = All
  MatchStatus? _filter;

  static const _filters = <(String, MatchStatus?)>[
    ('All', null),
    ('Live', MatchStatus.live),
    ('Upcoming', MatchStatus.upcoming),
    ('Completed', MatchStatus.completed),
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Matches')),
      body: Column(
        children: [
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filters.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final (label, status) = _filters[i];
                final selected = _filter == status;
                return ChoiceChip(
                  label: Text(label),
                  selected: selected,
                  showCheckmark: false,
                  onSelected: (_) => setState(() => _filter = status),
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.surfaceAlt,
                  side: BorderSide(
                    color: selected ? AppColors.primary : AppColors.border,
                  ),
                  shape: const StadiumBorder(),
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: AsyncView<List<Match>>(
              future: _matchesFuture,
              onRetry: _refresh,
              builder: (context, matches) {
                final visible = _filter == null
                    ? matches
                    : matches.where((m) => m.status == _filter).toList();
                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: _refresh,
                  child: visible.isEmpty
                      ? ListView(children: const [
                          SizedBox(height: 80),
                          PlaceholderView(
                            icon: Icons.sports_cricket_outlined,
                            title: 'No matches here',
                          ),
                        ])
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                          itemCount: visible.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 12),
                          itemBuilder: (_, i) => MatchCard(match: visible[i]),
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
