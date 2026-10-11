import 'batting_entry.dart';
import 'bowling_entry.dart';
import 'extras.dart';
import 'over_summary.dart';
import 'team.dart';

class Partnership {
  const Partnership({required this.runs, required this.balls});

  final int runs;
  final int balls;
}

class Innings {
  const Innings({
    required this.battingTeam,
    required this.runs,
    required this.wickets,
    required this.balls,
    required this.batting,
    required this.bowling,
    this.extras = const Extras(),
    this.yetToBat = const [],
    this.overs = const [],
    this.partnership,
  });

  final Team battingTeam;
  final int runs;
  final int wickets;

  /// Legal deliveries bowled in the innings.
  final int balls;

  final List<BattingEntry> batting;
  final List<BowlingEntry> bowling;
  final Extras extras;
  final List<String> yetToBat;

  /// Recent overs in chronological order (may be empty).
  final List<OverSummary> overs;

  /// Current partnership (only for an innings in progress).
  final Partnership? partnership;

  /// "18.2"
  String get oversText => '${balls ~/ 6}.${balls % 6}';

  /// "178/4"
  String get scoreText => '$runs/$wickets';

  double get runRate => balls == 0 ? 0 : runs * 6 / balls;

  List<BattingEntry> get currentBatters =>
      batting.where((b) => b.isNotOut).toList();

  BowlingEntry? get currentBowler {
    for (final b in bowling) {
      if (b.isBowling) return b;
    }
    return null;
  }
}
