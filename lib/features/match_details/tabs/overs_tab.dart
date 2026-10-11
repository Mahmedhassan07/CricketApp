import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/placeholder_view.dart';
import '../../../data/models/match.dart';
import '../../../data/models/over_summary.dart';
import '../widgets/ball_chip.dart';
import '../widgets/details_card.dart';

class OversTab extends StatelessWidget {
  const OversTab({super.key, required this.match});

  final Match match;

  @override
  Widget build(BuildContext context) {
    final innings = match.currentInnings;
    if (innings == null || innings.overs.isEmpty) {
      return const PlaceholderView(
        icon: Icons.sports_baseball_outlined,
        title: 'No over-by-over data',
        message: 'Ball-by-ball updates appear here during live matches.',
      );
    }

    final overs = innings.overs.reversed.toList(); // newest first
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            '${innings.battingTeam.name} innings · recent overs',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        DetailsCard(
          child: Column(
            children: [
              for (var i = 0; i < overs.length; i++) ...[
                if (i > 0) const Divider(),
                _OverRow(over: overs[i]),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _OverRow extends StatelessWidget {
  const _OverRow({required this.over});

  final OverSummary over;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 56,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Over',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
                ),
                Text(
                  '${over.number}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  over.bowler,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryDark,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [for (final b in over.balls) BallChip(ball: b)],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${over.runs}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const Text(
                'runs',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
