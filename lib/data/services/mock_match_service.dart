import '../models/batting_entry.dart';
import '../models/bowling_entry.dart';
import '../models/extras.dart';
import '../models/innings.dart';
import '../models/match.dart';
import '../models/over_summary.dart';
import '../models/player.dart';
import '../models/team.dart';
import 'match_service.dart';

/// Hard-coded matches for building the UI before the real API exists.
class MockMatchService implements MatchService {
  MockMatchService() : _matches = _buildMatches();

  final List<Match> _matches;

  /// Fake network latency so loading states get exercised.
  static const _latency = Duration(milliseconds: 300);

  @override
  Future<List<Match>> getMatches() async {
    await Future.delayed(_latency);
    return List.unmodifiable(_matches);
  }

  @override
  Future<Match?> getMatchById(String id) async {
    await Future.delayed(_latency);
    for (final m in _matches) {
      if (m.id == id) return m;
    }
    return null;
  }
}

// ---------------------------------------------------------------------------
// Teams
// ---------------------------------------------------------------------------

const _ind = Team(id: 'ind', name: 'India', shortName: 'IND', flagCode: 'IN');
const _pak =
    Team(id: 'pak', name: 'Pakistan', shortName: 'PAK', flagCode: 'PK');
const _aus =
    Team(id: 'aus', name: 'Australia', shortName: 'AUS', flagCode: 'AU');
const _eng =
    Team(id: 'eng', name: 'England', shortName: 'ENG', flagCode: 'GB-ENG');
const _sa =
    Team(id: 'sa', name: 'South Africa', shortName: 'SA', flagCode: 'ZA');
const _nz =
    Team(id: 'nz', name: 'New Zealand', shortName: 'NZ', flagCode: 'NZ');
const _sl = Team(id: 'sl', name: 'Sri Lanka', shortName: 'SL', flagCode: 'LK');
const _ban =
    Team(id: 'ban', name: 'Bangladesh', shortName: 'BAN', flagCode: 'BD');
const _wi = Team(
  id: 'wi',
  name: 'West Indies',
  shortName: 'WI',
  colorValue: 0xFF7B1E3A, // maroon
);

// ---------------------------------------------------------------------------
// Helpers to keep the data below compact
// ---------------------------------------------------------------------------

BattingEntry _bat(
  String name,
  int runs,
  int balls,
  int fours,
  int sixes, [
  String? dismissal,
  bool onStrike = false,
]) =>
    BattingEntry(
      playerName: name,
      runs: runs,
      balls: balls,
      fours: fours,
      sixes: sixes,
      dismissal: dismissal,
      onStrike: onStrike,
    );

/// [overs].[extraBalls] e.g. 3.2 overs → _bowl(name, 3, 2, ...)
BowlingEntry _bowl(
  String name,
  int overs,
  int extraBalls,
  int maidens,
  int runs,
  int wickets, {
  bool current = false,
}) =>
    BowlingEntry(
      playerName: name,
      balls: overs * 6 + extraBalls,
      maidens: maidens,
      runs: runs,
      wickets: wickets,
      isBowling: current,
    );

Player _p(String name, PlayerRole role, {bool c = false}) =>
    Player(name: name, role: role, isCaptain: c);

const _bt = PlayerRole.batter;
const _bw = PlayerRole.bowler;
const _ar = PlayerRole.allRounder;
const _wk = PlayerRole.wicketKeeper;

// ---------------------------------------------------------------------------
// Matches
// ---------------------------------------------------------------------------

List<Match> _buildMatches() {
  final now = DateTime.now();
  return [
    _indVsPak(now),
    _saVsNz(now),
    _ausVsEng(),
    _slVsBan(),
    _engVsWi(),
    _pakVsAus(),
  ];
}

/// LIVE – T20, India chasing 191.
Match _indVsPak(DateTime now) {
  final pakInnings = Innings(
    battingTeam: _pak,
    runs: 190,
    wickets: 7,
    balls: 120,
    batting: [
      _bat('Saim Ayub', 24, 16, 3, 1, 'c Tilak Varma b Bumrah'),
      _bat('Mohammad Rizwan', 41, 32, 4, 1, 'c Samson b Kuldeep Yadav'),
      _bat('Babar Azam', 38, 27, 4, 1, 'st Samson b Varun Chakravarthy'),
      _bat('Fakhar Zaman', 31, 17, 2, 3, 'c Hardik Pandya b Axar Patel'),
      _bat('Salman Ali Agha', 18, 11, 1, 1, 'run out (Tilak Varma)'),
      _bat('Khushdil Shah', 12, 8, 1, 1, 'c Abhishek Sharma b Bumrah'),
      _bat('Shadab Khan', 9, 5, 1, 0, 'b Hardik Pandya'),
      _bat('Mohammad Nawaz', 6, 3, 1, 0),
      _bat('Shaheen Afridi', 2, 1, 0, 0),
    ],
    extras: const Extras(legByes: 2, wides: 6, noBalls: 1),
    yetToBat: const ['Haris Rauf', 'Abrar Ahmed'],
    bowling: [
      _bowl('Jasprit Bumrah', 4, 0, 0, 28, 2),
      _bowl('Hardik Pandya', 3, 0, 0, 34, 1),
      _bowl('Axar Patel', 4, 0, 0, 36, 1),
      _bowl('Kuldeep Yadav', 4, 0, 0, 41, 1),
      _bowl('Varun Chakravarthy', 4, 0, 0, 33, 1),
      _bowl('Shivam Dube', 1, 0, 0, 16, 0),
    ],
  );

  final indInnings = Innings(
    battingTeam: _ind,
    runs: 178,
    wickets: 4,
    balls: 110,
    batting: [
      _bat('Abhishek Sharma', 32, 14, 4, 2, 'c Shaheen Afridi b Haris Rauf'),
      _bat('Shubman Gill', 27, 22, 3, 0, 'c Babar Azam b Abrar Ahmed'),
      _bat('Suryakumar Yadav', 46, 28, 5, 2, 'c Fakhar Zaman b Haris Rauf'),
      _bat('Tilak Varma', 21, 17, 2, 0, 'lbw b Abrar Ahmed'),
      _bat('Hardik Pandya', 33, 19, 2, 2, null, true),
      _bat('Sanju Samson', 13, 10, 1, 0),
    ],
    extras: const Extras(legByes: 1, wides: 4, noBalls: 1),
    yetToBat: const [
      'Shivam Dube',
      'Axar Patel',
      'Kuldeep Yadav',
      'Jasprit Bumrah',
      'Varun Chakravarthy',
    ],
    bowling: [
      _bowl('Shaheen Afridi', 4, 0, 0, 35, 0),
      _bowl('Haris Rauf', 3, 2, 0, 38, 2, current: true),
      _bowl('Abrar Ahmed', 4, 0, 0, 29, 2),
      _bowl('Mohammad Nawaz', 3, 0, 0, 30, 0),
      _bowl('Shadab Khan', 3, 0, 0, 31, 0),
      _bowl('Saim Ayub', 1, 0, 0, 14, 0),
    ],
    partnership: const Partnership(runs: 48, balls: 29),
    overs: const [
      OverSummary(
          number: 15, bowler: 'Shadab Khan', balls: ['1', '4', '1', '1', '0', '1']),
      OverSummary(
          number: 16, bowler: 'Abrar Ahmed', balls: ['1', '0', '1', '6', '1', '1']),
      OverSummary(
          number: 17,
          bowler: 'Mohammad Nawaz',
          balls: ['1', '1', '4', '0', '1', '2']),
      OverSummary(
          number: 18,
          bowler: 'Shaheen Afridi',
          balls: ['1', '6', '1', 'Wd', '2', '1', '0']),
      OverSummary(number: 19, bowler: 'Haris Rauf', balls: ['1', '4']),
    ],
  );

  return Match(
    id: 'ind-pak-t20wc',
    series: 'ICC T20 World Cup 2026',
    stage: 'Group Stage',
    format: MatchFormat.t20,
    status: MatchStatus.live,
    team1: _ind,
    team2: _pak,
    startTime: now.subtract(const Duration(hours: 3, minutes: 10)),
    venue: 'R. Premadasa Stadium, Colombo',
    toss: 'Pakistan won the toss and elected to bat',
    umpires: const ['Richard Illingworth', 'Kumar Dharmasena', 'Chris Gaffaney (TV)'],
    innings: [pakInnings, indInnings],
    team1Squad: [
      _p('Abhishek Sharma', _bt),
      _p('Shubman Gill', _bt),
      _p('Suryakumar Yadav', _bt, c: true),
      _p('Tilak Varma', _bt),
      _p('Sanju Samson', _wk),
      _p('Hardik Pandya', _ar),
      _p('Shivam Dube', _ar),
      _p('Axar Patel', _ar),
      _p('Kuldeep Yadav', _bw),
      _p('Jasprit Bumrah', _bw),
      _p('Varun Chakravarthy', _bw),
    ],
    team2Squad: [
      _p('Saim Ayub', _bt),
      _p('Mohammad Rizwan', _wk),
      _p('Babar Azam', _bt),
      _p('Fakhar Zaman', _bt),
      _p('Salman Ali Agha', _ar, c: true),
      _p('Khushdil Shah', _ar),
      _p('Shadab Khan', _ar),
      _p('Mohammad Nawaz', _ar),
      _p('Shaheen Afridi', _bw),
      _p('Haris Rauf', _bw),
      _p('Abrar Ahmed', _bw),
    ],
  );
}

/// LIVE – ODI, South Africa batting first.
Match _saVsNz(DateTime now) {
  final saInnings = Innings(
    battingTeam: _sa,
    runs: 168,
    wickets: 3,
    balls: 190,
    batting: [
      _bat('Ryan Rickelton', 18, 24, 3, 0, 'c Latham b Henry'),
      _bat('Aiden Markram', 64, 71, 7, 1, 'c Phillips b Santner'),
      _bat('Temba Bavuma', 52, 58, 5, 0, null, true),
      _bat('Rassie van der Dussen', 11, 16, 1, 0, 'lbw b Santner'),
      _bat('Tristan Stubbs', 15, 21, 1, 1),
    ],
    extras: const Extras(legByes: 3, wides: 5),
    yetToBat: const [
      'David Miller',
      'Marco Jansen',
      'Keshav Maharaj',
      'Kagiso Rabada',
      'Lungi Ngidi',
      'Tabraiz Shamsi',
    ],
    bowling: [
      _bowl('Matt Henry', 7, 0, 1, 32, 1),
      _bowl("Will O'Rourke", 6, 0, 0, 31, 0),
      _bowl('Lockie Ferguson', 6, 0, 0, 38, 0),
      _bowl('Mitchell Santner', 7, 0, 0, 29, 2),
      _bowl('Michael Bracewell', 4, 4, 0, 24, 0, current: true),
      _bowl('Rachin Ravindra', 1, 0, 0, 11, 0),
    ],
    partnership: const Partnership(runs: 34, balls: 35),
    overs: const [
      OverSummary(
          number: 29,
          bowler: 'Matt Henry',
          balls: ['1', '0', '0', '1', 'Wd', '2', '1']),
      OverSummary(
          number: 30,
          bowler: 'Michael Bracewell',
          balls: ['0', '1', '1', '4', '1', '1']),
      OverSummary(
          number: 31,
          bowler: 'Mitchell Santner',
          balls: ['1', '1', '0', '1', '2', '0']),
      OverSummary(
          number: 32, bowler: 'Michael Bracewell', balls: ['1', '0', '4', '1']),
    ],
  );

  return Match(
    id: 'sa-nz-odi2',
    series: 'New Zealand tour of South Africa',
    stage: '2nd ODI',
    format: MatchFormat.odi,
    status: MatchStatus.live,
    team1: _sa,
    team2: _nz,
    startTime: now.subtract(const Duration(hours: 2, minutes: 20)),
    venue: 'Kingsmead, Durban',
    toss: 'New Zealand won the toss and elected to field',
    umpires: const ['Adrian Holdstock', 'Paul Reiffel', 'Michael Gough (TV)'],
    innings: [saInnings],
    team1Squad: [
      _p('Ryan Rickelton', _wk),
      _p('Aiden Markram', _bt),
      _p('Temba Bavuma', _bt, c: true),
      _p('Rassie van der Dussen', _bt),
      _p('Tristan Stubbs', _bt),
      _p('David Miller', _bt),
      _p('Marco Jansen', _ar),
      _p('Keshav Maharaj', _bw),
      _p('Kagiso Rabada', _bw),
      _p('Lungi Ngidi', _bw),
      _p('Tabraiz Shamsi', _bw),
    ],
    team2Squad: [
      _p('Devon Conway', _bt),
      _p('Rachin Ravindra', _ar),
      _p('Kane Williamson', _bt),
      _p('Daryl Mitchell', _bt),
      _p('Tom Latham', _wk),
      _p('Glenn Phillips', _ar),
      _p('Mitchell Santner', _ar, c: true),
      _p('Michael Bracewell', _ar),
      _p('Matt Henry', _bw),
      _p('Lockie Ferguson', _bw),
      _p("Will O'Rourke", _bw),
    ],
  );
}

/// UPCOMING – ODI.
Match _ausVsEng() {
  return Match(
    id: 'aus-eng-odi1',
    series: 'ODI Series',
    stage: '1st Match',
    format: MatchFormat.odi,
    status: MatchStatus.upcoming,
    team1: _aus,
    team2: _eng,
    startTime: DateTime(2026, 11, 8, 9, 0),
    venue: 'Perth Stadium, Perth',
    team1Squad: [
      _p('Travis Head', _bt),
      _p('Mitchell Marsh', _ar, c: true),
      _p('Steve Smith', _bt),
      _p('Marnus Labuschagne', _bt),
      _p('Josh Inglis', _wk),
      _p('Glenn Maxwell', _ar),
      _p('Cameron Green', _ar),
      _p('Pat Cummins', _bw),
      _p('Mitchell Starc', _bw),
      _p('Adam Zampa', _bw),
      _p('Josh Hazlewood', _bw),
    ],
    team2Squad: [
      _p('Ben Duckett', _bt),
      _p('Jamie Smith', _wk),
      _p('Joe Root', _bt),
      _p('Harry Brook', _bt, c: true),
      _p('Jos Buttler', _wk),
      _p('Jacob Bethell', _ar),
      _p('Will Jacks', _ar),
      _p('Brydon Carse', _bw),
      _p('Jofra Archer', _bw),
      _p('Adil Rashid', _bw),
      _p('Mark Wood', _bw),
    ],
  );
}

/// UPCOMING – Test.
Match _slVsBan() {
  return Match(
    id: 'sl-ban-test2',
    series: 'Test Series',
    stage: '2nd Match',
    format: MatchFormat.test,
    status: MatchStatus.upcoming,
    team1: _sl,
    team2: _ban,
    startTime: DateTime(2026, 11, 12, 10, 0),
    venue: 'Galle International Stadium, Galle',
    team1Squad: [
      _p('Pathum Nissanka', _bt),
      _p('Oshada Fernando', _bt),
      _p('Dinesh Chandimal', _bt),
      _p('Kamindu Mendis', _ar),
      _p('Dhananjaya de Silva', _ar, c: true),
      _p('Kusal Mendis', _wk),
      _p('Milan Rathnayake', _bw),
      _p('Prabath Jayasuriya', _bw),
      _p('Asitha Fernando', _bw),
      _p('Vishwa Fernando', _bw),
      _p('Lahiru Kumara', _bw),
    ],
    team2Squad: [
      _p('Shadman Islam', _bt),
      _p('Mahmudul Hasan Joy', _bt),
      _p('Mominul Haque', _bt),
      _p('Najmul Hossain Shanto', _bt, c: true),
      _p('Mushfiqur Rahim', _bt),
      _p('Litton Das', _wk),
      _p('Mehidy Hasan Miraz', _ar),
      _p('Taijul Islam', _bw),
      _p('Nahid Rana', _bw),
      _p('Hasan Mahmud', _bw),
      _p('Taskin Ahmed', _bw),
    ],
  );
}

/// COMPLETED – T20I, England won by 17 runs.
Match _engVsWi() {
  final engInnings = Innings(
    battingTeam: _eng,
    runs: 204,
    wickets: 6,
    balls: 120,
    batting: [
      _bat('Phil Salt', 48, 26, 6, 2, 'c Pooran b Shepherd'),
      _bat('Jos Buttler', 27, 19, 3, 1, 'c Hope b Akeal Hosein'),
      _bat('Jacob Bethell', 15, 12, 1, 1, 'b Motie'),
      _bat('Harry Brook', 52, 30, 4, 3, 'c Rutherford b Alzarri Joseph'),
      _bat('Liam Livingstone', 22, 14, 1, 2, 'c Chase b Shepherd'),
      _bat('Sam Curran', 9, 8, 1, 0, 'run out (Hetmyer)'),
      _bat('Will Jacks', 18, 9, 1, 1),
      _bat('Brydon Carse', 4, 2, 0, 0),
    ],
    extras: const Extras(byes: 1, legByes: 2, wides: 5, noBalls: 1),
    yetToBat: const ['Jofra Archer', 'Adil Rashid', 'Saqib Mahmood'],
    bowling: [
      _bowl('Alzarri Joseph', 4, 0, 0, 39, 1),
      _bowl('Akeal Hosein', 4, 0, 0, 31, 1),
      _bowl('Romario Shepherd', 4, 0, 0, 44, 2),
      _bowl('Gudakesh Motie', 4, 0, 0, 36, 1),
      _bowl('Jason Holder', 3, 0, 0, 33, 0),
      _bowl('Roston Chase', 1, 0, 0, 18, 0),
    ],
  );

  final wiInnings = Innings(
    battingTeam: _wi,
    runs: 187,
    wickets: 9,
    balls: 120,
    batting: [
      _bat('Brandon King', 31, 20, 4, 1, 'c Buttler b Archer'),
      _bat('Shai Hope', 44, 29, 4, 2, 'c Brook b Rashid'),
      _bat('Nicholas Pooran', 38, 22, 2, 3, 'c Salt b Carse'),
      _bat('Shimron Hetmyer', 6, 7, 0, 0, 'lbw b Rashid'),
      _bat('Sherfane Rutherford', 21, 13, 1, 2, 'c Jacks b Curran'),
      _bat('Roston Chase', 8, 6, 1, 0, 'b Archer'),
      _bat('Jason Holder', 12, 8, 0, 1, 'c Bethell b Mahmood'),
      _bat('Romario Shepherd', 9, 6, 1, 0, 'c Livingstone b Archer'),
      _bat('Akeal Hosein', 2, 3, 0, 0, 'run out (Brook)'),
      _bat('Gudakesh Motie', 4, 4, 1, 0),
      _bat('Alzarri Joseph', 1, 2, 0, 0),
    ],
    extras: const Extras(legByes: 3, wides: 7, noBalls: 1),
    bowling: [
      _bowl('Jofra Archer', 4, 0, 0, 29, 3),
      _bowl('Saqib Mahmood', 4, 0, 0, 38, 1),
      _bowl('Brydon Carse', 4, 0, 0, 41, 1),
      _bowl('Adil Rashid', 4, 0, 0, 27, 2),
      _bowl('Sam Curran', 3, 0, 0, 34, 1),
      _bowl('Will Jacks', 1, 0, 0, 15, 0),
    ],
  );

  return Match(
    id: 'eng-wi-t20i3',
    series: 'West Indies tour of England',
    stage: '3rd T20I',
    format: MatchFormat.t20,
    status: MatchStatus.completed,
    team1: _eng,
    team2: _wi,
    startTime: DateTime(2026, 9, 28, 18, 30),
    venue: 'Trent Bridge, Nottingham',
    toss: 'West Indies won the toss and elected to field',
    result: 'England won by 17 runs',
    umpires: const ['Michael Gough', 'Alex Wharf', 'Joel Wilson (TV)'],
    innings: [engInnings, wiInnings],
    team1Squad: [
      _p('Phil Salt', _bt),
      _p('Jos Buttler', _wk),
      _p('Jacob Bethell', _ar),
      _p('Harry Brook', _bt, c: true),
      _p('Liam Livingstone', _ar),
      _p('Sam Curran', _ar),
      _p('Will Jacks', _ar),
      _p('Brydon Carse', _bw),
      _p('Jofra Archer', _bw),
      _p('Adil Rashid', _bw),
      _p('Saqib Mahmood', _bw),
    ],
    team2Squad: [
      _p('Brandon King', _bt),
      _p('Shai Hope', _wk, c: true),
      _p('Nicholas Pooran', _bt),
      _p('Shimron Hetmyer', _bt),
      _p('Sherfane Rutherford', _bt),
      _p('Roston Chase', _ar),
      _p('Jason Holder', _ar),
      _p('Romario Shepherd', _ar),
      _p('Akeal Hosein', _bw),
      _p('Gudakesh Motie', _bw),
      _p('Alzarri Joseph', _bw),
    ],
  );
}

/// COMPLETED – T20I, Australia won by 6 wickets.
Match _pakVsAus() {
  final pakInnings = Innings(
    battingTeam: _pak,
    runs: 158,
    wickets: 8,
    balls: 120,
    batting: [
      _bat('Saim Ayub', 12, 10, 2, 0, 'c Inglis b Hazlewood'),
      _bat('Sahibzada Farhan', 34, 27, 3, 1, 'c Maxwell b Zampa'),
      _bat('Mohammad Haris', 19, 14, 2, 1, 'b Starc'),
      _bat('Fakhar Zaman', 28, 21, 2, 1, 'c Head b Zampa'),
      _bat('Salman Ali Agha', 23, 19, 2, 0, 'c Green b Ellis'),
      _bat('Hasan Nawaz', 7, 8, 0, 0, 'lbw b Maxwell'),
      _bat('Khushdil Shah', 14, 10, 1, 1, 'c Marsh b Hazlewood'),
      _bat('Faheem Ashraf', 6, 6, 0, 0, 'c Stoinis b Ellis'),
      _bat('Shaheen Afridi', 3, 3, 0, 0),
      _bat('Haris Rauf', 2, 2, 0, 0),
    ],
    extras: const Extras(legByes: 4, wides: 6),
    yetToBat: const ['Abrar Ahmed'],
    bowling: [
      _bowl('Mitchell Starc', 4, 0, 0, 31, 1),
      _bowl('Josh Hazlewood', 4, 0, 0, 27, 2),
      _bowl('Nathan Ellis', 4, 0, 0, 35, 2),
      _bowl('Adam Zampa', 4, 0, 0, 30, 2),
      _bowl('Glenn Maxwell', 3, 0, 0, 22, 1),
      _bowl('Marcus Stoinis', 1, 0, 0, 9, 0),
    ],
  );

  final ausInnings = Innings(
    battingTeam: _aus,
    runs: 161,
    wickets: 4,
    balls: 111,
    batting: [
      _bat('Travis Head', 41, 22, 5, 2, 'c Fakhar Zaman b Shaheen Afridi'),
      _bat('Mitchell Marsh', 26, 21, 2, 1, 'c Mohammad Haris b Abrar Ahmed'),
      _bat('Josh Inglis', 37, 28, 4, 1, 'st Mohammad Haris b Abrar Ahmed'),
      _bat('Cameron Green', 12, 11, 1, 0, 'c Salman Ali Agha b Haris Rauf'),
      _bat('Glenn Maxwell', 24, 16, 1, 2),
      _bat('Tim David', 14, 13, 1, 1),
    ],
    extras: const Extras(legByes: 2, wides: 4, noBalls: 1),
    yetToBat: const [
      'Marcus Stoinis',
      'Nathan Ellis',
      'Mitchell Starc',
      'Adam Zampa',
      'Josh Hazlewood',
    ],
    bowling: [
      _bowl('Shaheen Afridi', 4, 0, 0, 33, 1),
      _bowl('Haris Rauf', 3, 3, 0, 37, 1),
      _bowl('Abrar Ahmed', 4, 0, 0, 26, 2),
      _bowl('Faheem Ashraf', 3, 0, 0, 28, 0),
      _bowl('Saim Ayub', 2, 0, 0, 17, 0),
      _bowl('Khushdil Shah', 2, 0, 0, 18, 0),
    ],
  );

  return Match(
    id: 'pak-aus-t20i2',
    series: 'Australia tour of Pakistan',
    stage: '2nd T20I',
    format: MatchFormat.t20,
    status: MatchStatus.completed,
    team1: _pak,
    team2: _aus,
    startTime: DateTime(2026, 10, 2, 19, 0),
    venue: 'Gaddafi Stadium, Lahore',
    toss: 'Australia won the toss and elected to field',
    result: 'Australia won by 6 wickets (9 balls left)',
    umpires: const ['Ahsan Raza', 'Joel Wilson', 'Sharfuddoula (TV)'],
    innings: [pakInnings, ausInnings],
    team1Squad: [
      _p('Saim Ayub', _bt),
      _p('Sahibzada Farhan', _bt),
      _p('Mohammad Haris', _wk),
      _p('Fakhar Zaman', _bt),
      _p('Salman Ali Agha', _ar, c: true),
      _p('Hasan Nawaz', _bt),
      _p('Khushdil Shah', _ar),
      _p('Faheem Ashraf', _ar),
      _p('Shaheen Afridi', _bw),
      _p('Haris Rauf', _bw),
      _p('Abrar Ahmed', _bw),
    ],
    team2Squad: [
      _p('Travis Head', _bt),
      _p('Mitchell Marsh', _ar, c: true),
      _p('Josh Inglis', _wk),
      _p('Cameron Green', _ar),
      _p('Glenn Maxwell', _ar),
      _p('Tim David', _bt),
      _p('Marcus Stoinis', _ar),
      _p('Nathan Ellis', _bw),
      _p('Mitchell Starc', _bw),
      _p('Adam Zampa', _bw),
      _p('Josh Hazlewood', _bw),
    ],
  );
}
