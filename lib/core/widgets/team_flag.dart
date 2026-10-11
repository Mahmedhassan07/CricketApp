import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

import '../../data/models/team.dart';
import '../theme/app_colors.dart';

/// Round team flag. Uses the country_flags package when the team has a
/// [Team.flagCode]; otherwise shows the team's initials (e.g. West Indies).
class TeamFlag extends StatelessWidget {
  const TeamFlag({super.key, required this.team, this.size = 44});

  final Team team;
  final double size;

  @override
  Widget build(BuildContext context) {
    final code = team.flagCode;
    final Widget flag = code == null
        ? _InitialsFlag(team: team, size: size)
        : CountryFlag.fromCountryCode(
            code,
            theme: ImageTheme(width: size, height: size, shape: const Circle()),
          );

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border),
      ),
      child: flag,
    );
  }
}

class _InitialsFlag extends StatelessWidget {
  const _InitialsFlag({required this.team, required this.size});

  final Team team;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(team.colorValue),
      ),
      child: Text(
        team.shortName,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: size * 0.3,
        ),
      ),
    );
  }
}
