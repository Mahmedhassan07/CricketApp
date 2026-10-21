import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
//import '../../../core/utils/formatters.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../core/widgets/team_flag.dart';
import '../../../data/models/match.dart';
import '../../../data/models/team.dart';
import '../../match_details/match_details_screen.dart';

/// Match card used on Home and in the Matches tab.
/// Live/completed cards show scores; upcoming cards show date and time.
class MatchCard extends StatelessWidget {
  const MatchCard({super.key, required this.match});

  final Match match;

  void _open(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => MatchDetailsScreen(match: match)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isUpcoming = match.status == MatchStatus.upcoming;
    final statusText = match.statusText;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _open(context),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  StatusBadge(status: match.status),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '${match.series}  •  ${match.stage}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              isUpcoming ? _UpcomingBody(match: match) : _ScoreBody(match: match),
              if (!isUpcoming && statusText != null) ...[
                const SizedBox(height: 12),
                _StatusStrip(text: statusText),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ScoreBody extends StatelessWidget {
  const _ScoreBody({required this.match});

  final Match match;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TeamColumn(team: match.team1),
        Expanded(child: _TeamScore(match: match, team: match.team1)),
        const _VsChip(),
        Expanded(child: _TeamScore(match: match, team: match.team2)),
        _TeamColumn(team: match.team2),
      ],
    );
  }
}

class _TeamScore extends StatelessWidget {
  const _TeamScore({required this.match, required this.team});

  final Match match;
  final Team team;

  @override
  Widget build(BuildContext context) {
    final innings = match.inningsFor(team);
    if (innings == null) {
      return const Text(
        'Yet to bat',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 13, color: AppColors.textMuted),
      );
    }
    return Column(
      children: [
        Text(
          innings.scoreText,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 2),
        Text(
          '(${innings.oversText} ov)',
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _UpcomingBody extends StatelessWidget {
  const _UpcomingBody({required this.match});

  final Match match;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TeamColumn(team: match.team1),
        Expanded(
          child: Column(
            children: [
              // Text(
              //   Formatters.date(match.startTime),
              //   style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              // ),
              const SizedBox(height: 2),
              // Text(
              //   Formatters.time(match.startTime),
              //   style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
              // ),
              const SizedBox(height: 2),
              // const Text(
              //   '(Local Time)',
              //   style: TextStyle(fontSize: 11, color: AppColors.textMuted),
              // ),
            ],
          ),
        ),
        const _VsChip(),
        const Spacer(),
        _TeamColumn(team: match.team2),
        const SizedBox(width: 4),
        const Icon(Icons.chevron_right, color: AppColors.textMuted),
      ],
    );
  }
}

class _TeamColumn extends StatelessWidget {
  const _TeamColumn({required this.team});

  final Team team;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      child: Column(
        children: [
          TeamFlag(team: team, size: 42),
          const SizedBox(height: 6),
          Text(
            team.shortName,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _VsChip extends StatelessWidget {
  const _VsChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.surfaceAlt,
        shape: BoxShape.circle,
      ),
      child: const Text(
        'vs',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _StatusStrip extends StatelessWidget {
  const _StatusStrip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryDark,
        ),
      ),
    );
  }
}
