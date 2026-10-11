import 'innings.dart';
import 'player.dart';
import 'team.dart';

enum MatchStatus { live, upcoming, completed }

enum MatchFormat { t20, odi, test }

class Match {
  const Match({
    required this.id,
    required this.series,
    required this.stage,
    required this.format,
    required this.status,
    required this.team1,
    required this.team2,
    required this.startTime,
    required this.venue,
    this.toss,
    this.result,
    this.umpires = const [],
    this.innings = const [],
    this.team1Squad = const [],
    this.team2Squad = const [],
  });

  final String id;

  /// "ICC T20 World Cup 2026"
  final String series;

  /// "Group Stage", "1st Match"...
  final String stage;

  final MatchFormat format;
  final MatchStatus status;
  final Team team1;
  final Team team2;
  final DateTime startTime;
  final String venue;

  /// "Pakistan won the toss and elected to bat"
  final String? toss;

  /// Final result for completed matches, e.g. "England won by 17 runs".
  final String? result;

  final List<String> umpires;

  /// Innings in the order they were played.
  final List<Innings> innings;

  final List<Player> team1Squad;
  final List<Player> team2Squad;

  /// "IND v PAK"
  String get shortTitle => '${team1.shortName} v ${team2.shortName}';

  String get formatLabel => switch (format) {
        MatchFormat.t20 => 'T20',
        MatchFormat.odi => 'ODI',
        MatchFormat.test => 'Test',
      };

  /// Overs per side for limited-overs matches, null for Tests.
  int? get maxOvers => switch (format) {
        MatchFormat.t20 => 20,
        MatchFormat.odi => 50,
        MatchFormat.test => null,
      };

  Innings? get currentInnings => innings.isEmpty ? null : innings.last;

  /// Most recent innings batted by [team], if any.
  Innings? inningsFor(Team team) {
    for (final inn in innings.reversed) {
      if (inn.battingTeam.id == team.id) return inn;
    }
    return null;
  }

  /// True when the second side is chasing in a limited-overs match.
  bool get isChasing =>
      status == MatchStatus.live && maxOvers != null && innings.length == 2;

  int? get target => maxOvers != null && innings.length >= 2
      ? innings.first.runs + 1
      : null;

  int? get runsNeeded => isChasing ? target! - innings[1].runs : null;

  int? get ballsRemaining =>
      isChasing ? maxOvers! * 6 - innings[1].balls : null;

  double? get requiredRunRate {
    final runs = runsNeeded;
    final balls = ballsRemaining;
    if (runs == null || balls == null || balls == 0) return null;
    return runs * 6 / balls;
  }

  /// One-line status: chase equation, toss or result.
  String? get statusText {
    switch (status) {
      case MatchStatus.completed:
        return result;
      case MatchStatus.upcoming:
        return null;
      case MatchStatus.live:
        if (isChasing) {
          return '${innings[1].battingTeam.name} need $runsNeeded runs '
              'in $ballsRemaining balls';
        }
        return toss;
    }
  }
}
