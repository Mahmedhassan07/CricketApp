import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/placeholder_view.dart';
import '../../../data/models/innings.dart';
import '../../../data/models/match.dart';
import '../widgets/ball_chip.dart';
import '../widgets/details_card.dart';
import '../widgets/stat_table.dart';

class LiveTab extends StatelessWidget {
  const LiveTab({super.key, required this.match});

  final Match match;

  @override
  Widget build(BuildContext context) {
    final innings = match.currentInnings;
    if (match.status == MatchStatus.upcoming || innings == null) {
      return const PlaceholderView(
        icon: Icons.schedule_rounded,
        title: "Match hasn't started yet",
        message: 'Live score will appear here once play begins.',
      );
    }

    if (match.status == MatchStatus.completed) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          MatchStatusMessage(match: match),
          const SizedBox(height: 12),
          for (final inn in match.innings) ...[
            _ScoreSummary(match: match, innings: inn),
            const SizedBox(height: 12),
          ],
        ],
      );
    }

    final bowler = innings.currentBowler;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        MatchStatusMessage(match: match),
        const SizedBox(height: 12),
        _ScoreSummary(match: match, innings: innings),
        const SizedBox(height: 12),
        _PartnershipCard(innings: innings),
        const SizedBox(height: 12),
        DetailsCard(
          child: StatTable.batting(
            rows: [
              for (final b in innings.currentBatters)
                StatRows.batter(b, live: true, markStriker: true),
            ],
          ),
        ),
        if (bowler != null) ...[
          const SizedBox(height: 12),
          DetailsCard(
            child: StatTable.bowling(rows: [StatRows.bowler(bowler)]),
          ),
        ],
      ],
    );
  }
}

/// Team + big score on the left, CRR / RRR / TAR on the right.
class _ScoreSummary extends StatelessWidget {
  const _ScoreSummary({required this.match, required this.innings});

  final Match match;
  final Innings innings;

  @override
  Widget build(BuildContext context) {
    final isChaseInnings =
        match.innings.length >= 2 && identical(innings, match.innings[1]);
    final rrr = match.isChasing ? match.requiredRunRate : null;
    final target = isChaseInnings ? match.target : null;

    return DetailsCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  innings.battingTeam.shortName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text.rich(
                  TextSpan(children: [
                    TextSpan(
                      text: '${innings.runs}-${innings.wickets}',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextSpan(
                      text: '  (${innings.oversText})',
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
          _RateColumn(label: 'CRR', value: Formatters.decimal(innings.runRate)),
          _RateColumn(
            label: 'RRR',
            value: rrr == null ? '-' : Formatters.decimal(rrr),
          ),
          _RateColumn(label: 'TAR', value: target?.toString() ?? '-'),
        ],
      ),
    );
  }
}

class _RateColumn extends StatelessWidget {
  const _RateColumn({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 54,
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

/// "P'SHIP 48(29)" with a MORE toggle revealing last wicket and this over.
class _PartnershipCard extends StatefulWidget {
  const _PartnershipCard({required this.innings});

  final Innings innings;

  @override
  State<_PartnershipCard> createState() => _PartnershipCardState();
}

class _PartnershipCardState extends State<_PartnershipCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final innings = widget.innings;
    final p = innings.partnership;
    final dismissed = innings.batting.where((b) => !b.isNotOut).toList();
    final lastWicket = dismissed.isEmpty ? null : dismissed.last;
    final thisOver = innings.overs.isEmpty ? null : innings.overs.last;

    return DetailsCard(
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 10, 12),
              child: Row(
                children: [
                  const Text(
                    "P'SHIP ",
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    p == null ? '-' : '${p.runs}(${p.balls})',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  Text(
                    _expanded ? 'LESS' : 'MORE',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (lastWicket != null)
                    _InfoLine(
                      label: 'Last wkt',
                      value: '${lastWicket.playerName} '
                          '${lastWicket.runs}(${lastWicket.balls}) - '
                          '${lastWicket.dismissal}',
                    ),
                  if (thisOver != null) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const SizedBox(
                          width: 72,
                          child: Text(
                            'This over',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              for (final ball in thisOver.balls)
                                BallChip(ball: ball, size: 26),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 72,
          child: Text(
            label,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
        ),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 13))),
      ],
    );
  }
}
