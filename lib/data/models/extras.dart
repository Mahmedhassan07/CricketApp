class Extras {
  const Extras({
    this.byes = 0,
    this.legByes = 0,
    this.wides = 0,
    this.noBalls = 0,
    this.penalty = 0,
  });

  final int byes;
  final int legByes;
  final int wides;
  final int noBalls;
  final int penalty;

  int get total => byes + legByes + wides + noBalls + penalty;

  /// "b 0, lb 2, w 6, nb 1, p 0"
  String get breakdown =>
      'b $byes, lb $legByes, w $wides, nb $noBalls, p $penalty';
}
