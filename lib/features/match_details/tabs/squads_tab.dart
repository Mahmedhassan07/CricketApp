import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/placeholder_view.dart';
import '../../../core/widgets/team_flag.dart';
import '../../../data/models/match.dart';
import '../../../data/models/player.dart';
import '../../../data/models/team.dart';
import '../widgets/details_card.dart';

class SquadsTab extends StatelessWidget {
  const SquadsTab({super.key, required this.match});

  final Match match;

  @override
  Widget build(BuildContext context) {
    if (match.team1Squad.isEmpty && match.team2Squad.isEmpty) {
      return const PlaceholderView(
        icon: Icons.groups_outlined,
        title: 'Squads not announced',
      );
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _SquadCard(team: match.team1, players: match.team1Squad),
        const SizedBox(height: 12),
        _SquadCard(team: match.team2, players: match.team2Squad),
      ],
    );
  }
}

class _SquadCard extends StatelessWidget {
  const _SquadCard({required this.team, required this.players});

  final Team team;
  final List<Player> players;

  @override
  Widget build(BuildContext context) {
    return DetailsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: AppColors.surfaceAlt,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                TeamFlag(team: team, size: 28),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    team.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                ),
                Text(
                  '${players.length} players',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          for (var i = 0; i < players.length; i++) ...[
            if (i > 0) const Divider(indent: 14, endIndent: 14),
            _PlayerRow(player: players[i]),
          ],
        ],
      ),
    );
  }
}

class _PlayerRow extends StatelessWidget {
  const _PlayerRow({required this.player});

  final Player player;

  @override
  Widget build(BuildContext context) {
    final tags = [
      if (player.isCaptain) 'c',
      if (player.role == PlayerRole.wicketKeeper) 'wk',
    ];
    final initials = player.name
        .split(' ')
        .where((w) => w.isNotEmpty)
        .take(2)
        .map((w) => w[0])
        .join();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 17,
            backgroundColor: AppColors.primarySoft,
            child: Text(
              initials,
              style: const TextStyle(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text.rich(
              TextSpan(children: [
                TextSpan(
                  text: player.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                if (tags.isNotEmpty)
                  TextSpan(
                    text: ' (${tags.join(' & ')})',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
              ]),
            ),
          ),
          Text(
            player.roleLabel,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
