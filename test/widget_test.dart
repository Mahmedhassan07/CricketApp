import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_first_app/data/models/match.dart';
import 'package:my_first_app/data/services/app_services.dart';
import 'package:my_first_app/data/services/mock_match_service.dart';
import 'package:my_first_app/features/match_details/match_details_screen.dart';
import 'package:my_first_app/features/matches/matches_screen.dart';
import 'package:my_first_app/main.dart';

void main() {
  setUp(() => AppServices.matches = MockMatchService());

  group('Mock data', () {
    test('has 2 live, 2 upcoming and 2 completed matches', () async {
      final matches = await MockMatchService().getMatches();
      int count(MatchStatus s) => matches.where((m) => m.status == s).length;
      expect(count(MatchStatus.live), 2);
      expect(count(MatchStatus.upcoming), 2);
      expect(count(MatchStatus.completed), 2);
    });

    test('every scorecard adds up', () async {
      final matches = await MockMatchService().getMatches();
      for (final m in matches) {
        for (final inn in m.innings) {
          final label = '${m.id} / ${inn.battingTeam.name}';
          final batRuns = inn.batting.fold(0, (s, b) => s + b.runs);
          expect(batRuns + inn.extras.total, inn.runs, reason: '$label runs');

          final bowlBalls = inn.bowling.fold(0, (s, b) => s + b.balls);
          expect(bowlBalls, inn.balls, reason: '$label balls');

          final conceded = inn.bowling.fold(0, (s, b) => s + b.runs);
          expect(conceded + inn.extras.byes + inn.extras.legByes, inn.runs,
              reason: '$label runs conceded');

          final outs = inn.batting.where((b) => !b.isNotOut).length;
          expect(outs, inn.wickets, reason: '$label wickets');
        }
      }
    });

    test('India need 13 runs in 10 balls', () async {
      final m = await MockMatchService().getMatchById('ind-pak-t20wc');
      expect(m!.statusText, 'India need 13 runs in 10 balls');
    });
  });

  testWidgets('login -> home -> match details', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const CricketLiveApp());
    expect(find.text('Continue as guest'), findsOneWidget);

    await tester.tap(find.text('Continue as guest'));
    await tester.pumpAndSettle();

    expect(find.text('Matches'), findsWidgets);
    expect(find.text('India need 13 runs in 10 balls'), findsOneWidget);

    await tester.tap(find.text('India need 13 runs in 10 balls'));
    await tester.pumpAndSettle();

    expect(find.text('IND v PAK'), findsOneWidget);
    expect(find.text('Hardik Pandya*'), findsOneWidget); // Live tab, striker

    await tester.tap(find.text('Scorecard'));
    await tester.pumpAndSettle();
    expect(find.text('Yet to bat'), findsOneWidget);
  });

  testWidgets('every tab of every match renders without overflow',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2400); // 360 x 800 dp
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    final matches = await tester.runAsync(MockMatchService().getMatches);
    for (final match in matches!) {
      await tester.pumpWidget(
        MaterialApp(home: MatchDetailsScreen(match: match)),
      );
      final controller =
          DefaultTabController.of(tester.element(find.byType(TabBarView)));
      for (var i = 0; i < controller.length; i++) {
        controller.animateTo(i);
        await tester.pumpAndSettle();
      }
    }

    // Matches tab with every filter.
    await tester.pumpWidget(const MaterialApp(home: MatchesScreen()));
    await tester.pumpAndSettle();
    // "All" is the initial filter, already rendered above.
    for (final f in ['Live', 'Upcoming', 'Completed']) {
      final chip = find.widgetWithText(ChoiceChip, f);
      await tester.ensureVisible(chip);
      await tester.pumpAndSettle();
      await tester.tap(chip);
      await tester.pumpAndSettle();
    }
  });
}
