import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/batting_entry.dart';
import '../../../data/models/bowling_entry.dart';
import '../../../data/models/match.dart';
import 'stat_table.dart';

/// Rounded bordered container used for every section in Match Details.
class DetailsCard extends StatelessWidget {
  const DetailsCard({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}

/// Chase equation / toss / result line shown at the top of Live & Scorecard.
class MatchStatusMessage extends StatelessWidget {
  const MatchStatusMessage({super.key, required this.match});

  final Match match;

  @override
  Widget build(BuildContext context) {
    final (text, color, bg) = switch (match.status) {
      MatchStatus.live when match.isChasing =>
        (match.statusText!, AppColors.live, AppColors.liveSoft),
      MatchStatus.live =>
        (match.statusText ?? 'Match in progress', AppColors.primaryDark, AppColors.primarySoft),
      MatchStatus.completed =>
        (match.result ?? 'Match completed', AppColors.primaryDark, AppColors.primarySoft),
      MatchStatus.upcoming => (
          'Match starts ${Formatters.date(match.startTime)} at '
              '${Formatters.time(match.startTime)}',
          AppColors.upcoming,
          AppColors.upcomingSoft,
        ),
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall + 2),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 14),
      ),
    );
  }
}

/// Converts model entries into table rows.
class StatRows {
  StatRows._();

  static StatRow batter(BattingEntry b, {required bool live, bool markStriker = false}) {
    final name = markStriker && b.onStrike ? '${b.playerName}*' : b.playerName;
    return StatRow(
      name: name,
      subtitle: b.dismissal ?? (live ? 'batting' : 'not out'),
      values: [
        '${b.runs}',
        '${b.balls}',
        '${b.fours}',
        '${b.sixes}',
      ],
    );
  }

  static StatRow bowler(BowlingEntry b) => StatRow(
        name: b.playerName,
        values: [
          b.overs,
          '${b.maidens}',
          '${b.runs}',
          '${b.wickets}',
        ],
      );
}
