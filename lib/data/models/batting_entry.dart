class BattingEntry {
  const BattingEntry({
    required this.playerName,
    required this.runs,
    required this.balls,
    this.fours = 0,
    this.sixes = 0,
    this.dismissal,
    this.onStrike = false,
  });

  final String playerName;
  final int runs;
  final int balls;
  final int fours;
  final int sixes;

  /// How the batter got out, e.g. "c Rizwan b Shaheen Afridi".
  /// Null means not out (still batting, or not out at the end).
  final String? dismissal;

  /// True for the batter currently facing (shown with a *).
  final bool onStrike;

  bool get isNotOut => dismissal == null;

  double get strikeRate => balls == 0 ? 0 : runs * 100 / balls;
}
