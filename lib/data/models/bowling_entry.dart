class BowlingEntry {
  const BowlingEntry({
    required this.playerName,
    required this.balls,
    required this.runs,
    required this.wickets,
    this.maidens = 0,
    this.isBowling = false,
  });

  final String playerName;

  /// Legal deliveries bowled (3.2 overs = 20 balls).
  final int balls;
  final int maidens;
  final int runs;
  final int wickets;

  /// True for the bowler bowling the current over.
  final bool isBowling;

  /// Overs in cricket notation, e.g. "3.2".
  String get overs => '${balls ~/ 6}.${balls % 6}';

  double get economy => balls == 0 ? 0 : runs * 6 / balls;
}
