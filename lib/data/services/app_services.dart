import 'match_service.dart';

/// Very small service locator. Set once in main() and read from screens:
///
///   AppServices.matches.getMatches()
class AppServices {
  AppServices._();

  static late MatchService matches;
}
