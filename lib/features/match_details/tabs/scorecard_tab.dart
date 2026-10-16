import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/placeholder_view.dart';
import '../../../data/models/innings.dart';
import '../../../data/models/match.dart';
import '../widgets/details_card.dart';
import '../widgets/stat_table.dart';

class ScorecardTab extends StatefulWidget {
  const ScorecardTab({super.key, required this.match});

  final Match match;

  @override
  State<ScorecardTab> createState() => _ScorecardTabState();
}

class _ScorecardTabState extends State<ScorecardTab> {
  /// Indexes of expanded innings. The latest innings starts open.
  late final Set<int> _expanded = {widget.match.innings.length - 1};

  void _toggle(int i) => setState(
        () => _expanded.contains(i) ? _expanded.remove(i) : _expanded.add(i),
      );

  @override
  Widget build(BuildContext context) {
    final match = widget.match;
    if (match.innings.isEmpty) {
      return const PlaceholderView(
        icon: Icons.table_chart_outlined,
        title: 'No scorecard yet',
        message: 'The scorecard will be available once the match starts.',
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        MatchStatusMessage(match: match),
        const SizedBox(height: 12),
        for (var i = 0; i < match.innings.length; i++) ...[
          _InningsSection(
            innings: match.innings[i],
            isLive: match.status == MatchStatus.live &&
                i == match.innings.length - 1,
            expanded: _expanded.contains(i),
            onToggle: () => _toggle(i),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _InningsSection extends StatelessWidget {
  const _InningsSection({
    required this.innings,
    required this.isLive,
    required this.expanded,
    required this.onToggle,
  });

  final Innings innings;
  final bool isLive;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final headerFg = expanded ? Colors.white : AppColors.textPrimary;

    return DetailsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header: green when open, white when collapsed.
          Material(
            color: expanded ? AppColors.primary : AppColors.surface,
            child: InkWell(
              onTap: onToggle,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        innings.battingTeam.name,
                        style: TextStyle(
                          color: headerFg,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      '${innings.runs}-${innings.wickets} (${innings.oversText})',
                      style: TextStyle(
                        color: headerFg,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      expanded ? Icons.expand_less : Icons.expand_more,
                      color: expanded ? Colors.white : AppColors.textMuted,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (expanded) ..._buildBody(),
        ],
      ),
    );
  }

  List<Widget> _buildBody() {
    return [
      StatTable.batting(
        rows: [
          for (final b in innings.batting) StatRows.batter(b, live: isLive),
        ],
      ),
      StatTable.bowling(
        rows: [for (final b in innings.bowling) StatRows.bowler(b)],
      ),
    ];
  }
}

