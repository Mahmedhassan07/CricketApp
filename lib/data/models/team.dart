class Team {
  const Team({
    required this.id,
    required this.name,
    required this.shortName,
    this.flagCode,
    this.colorValue = 0xFF15803D,
  });

  final String id;

  /// Full name, e.g. "India".
  final String name;

  /// Short code shown on cards, e.g. "IND".
  final String shortName;

  /// ISO country code for the flag ("IN", "GB-ENG"). Null for teams
  /// without a country flag (e.g. West Indies); the UI shows initials.
  final String? flagCode;

  /// Fallback circle color (ARGB) used when there's no flag.
  final int colorValue;
}
