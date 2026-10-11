enum PlayerRole { batter, bowler, allRounder, wicketKeeper }

class Player {
  const Player({
    required this.name,
    required this.role,
    this.isCaptain = false,
  });

  final String name;
  final PlayerRole role;
  final bool isCaptain;

  String get roleLabel => switch (role) {
        PlayerRole.batter => 'Batter',
        PlayerRole.bowler => 'Bowler',
        PlayerRole.allRounder => 'All-rounder',
        PlayerRole.wicketKeeper => 'Wicket-keeper',
      };
}
