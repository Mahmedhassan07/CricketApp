class OverSummary {
  const OverSummary({
    required this.number,
    required this.bowler,
    required this.balls,
  });

  /// 1-based over number (the over in progress at 18.2 is over 19).
  final int number;
  final String bowler;

  /// Ball-by-ball outcomes: "0"-"6", "W" (wicket), "Wd" (wide), "Nb" (no ball).
  final List<String> balls;

  int get runs => balls.fold(0, (sum, ball) {
        if (ball == 'Wd' || ball == 'Nb') return sum + 1;
        return sum + (int.tryParse(ball) ?? 0);
      });
}
