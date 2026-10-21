import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/match.dart';
import 'tabs/info_tab.dart';
import 'tabs/live_tab.dart';
import 'tabs/overs_tab.dart';
import 'tabs/scorecard_tab.dart';
import 'tabs/squads_tab.dart';

class MatchDetailsScreen extends StatelessWidget {
  const MatchDetailsScreen({super.key, required this.match});

  final Match match;

  static const _tabs = ['Info', 'Live', 'Scorecard', 'Squads', 'Overs'];

  /// Opens on the most useful tab for the match state.
  int get _initialTab => switch (match.status) {
        MatchStatus.live => 1,
        MatchStatus.completed => 2,
        MatchStatus.upcoming => 0,
      };

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      initialIndex: _initialTab,
      child: Scaffold(
        backgroundColor: AppColors.surfaceAlt,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          title: Text(match.shortTitle),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            unselectedLabelStyle:
                const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.label,
            dividerColor: Colors.transparent,
            tabs: [for (final t in _tabs) Tab(text: t)],
          ),
        ),
        body: TabBarView(
          children: [
            InfoTab(match: match),
            LiveTab(match: match),
            ScorecardTab(match: match),
            SquadsTab(match: match),
            OversTab(match: match),
          ],
        ),
      ),
    );
  }
}
