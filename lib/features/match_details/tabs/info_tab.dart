import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/team_flag.dart';
import '../../../data/models/match.dart';
import '../widgets/details_card.dart';

class InfoTab extends StatelessWidget {
  const InfoTab({super.key, required this.match});

  final Match match;

  @override
  Widget build(BuildContext context) {
    final rows = <(IconData, String, String)>[
      (Icons.emoji_events_outlined, 'Series', match.series),
      (Icons.flag_outlined, 'Match', '${match.stage} • ${match.formatLabel}'),
      (Icons.calendar_today_outlined, 'Date', Formatters.date(match.startTime)),
      (Icons.schedule, 'Time', '${Formatters.time(match.startTime)} (Local Time)'),
      (Icons.stadium_outlined, 'Venue', match.venue),
      (Icons.toll_outlined, 'Toss', match.toss ?? 'Not yet'),
      (
        Icons.sports_outlined,
        'Umpires',
        match.umpires.isEmpty ? 'To be announced' : match.umpires.join(', '),
      ),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        DetailsCard(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          child: Row(
            children: [
              Expanded(child: _TeamBlock(name: match.team1.name, flag: TeamFlag(team: match.team1, size: 48))),
              const Text(
                'vs',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Expanded(child: _TeamBlock(name: match.team2.name, flag: TeamFlag(team: match.team2, size: 48))),
            ],
          ),
        ),
        const SizedBox(height: 12),
        MatchStatusMessage(match: match),
        const SizedBox(height: 12),
        DetailsCard(
          child: Column(
            children: [
              for (var i = 0; i < rows.length; i++) ...[
                if (i > 0) const Divider(indent: 52),
                ListTile(
                  leading: Icon(rows[i].$1, color: AppColors.primary),
                  title: Text(
                    rows[i].$2,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  subtitle: Text(
                    rows[i].$3,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _TeamBlock extends StatelessWidget {
  const _TeamBlock({required this.name, required this.flag});

  final String name;
  final Widget flag;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        flag,
        const SizedBox(height: 8),
        Text(
          name,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
