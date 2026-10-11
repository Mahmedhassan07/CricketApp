import '../models/match.dart';

/// Contract between the UI and wherever match data comes from.
///
/// Screens only depend on this interface. To switch from mock data to a
/// live score API, write an `ApiMatchService implements MatchService` and
/// register it in main.dart (see [AppServices]).
abstract class MatchService {
  Future<List<Match>> getMatches();

  Future<Match?> getMatchById(String id);
}
