import 'package:flutter/material.dart';

import '../../data/models/match.dart';
import '../theme/app_colors.dart';

/// Pill badge: "● LIVE", "● UPCOMING", "● COMPLETED".
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final MatchStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, fg, bg) = switch (status) {
      MatchStatus.live => ('LIVE', AppColors.live, AppColors.liveSoft),
      MatchStatus.upcoming =>
        ('UPCOMING', AppColors.upcoming, AppColors.upcomingSoft),
      MatchStatus.completed =>
        ('COMPLETED', AppColors.completed, AppColors.completedSoft),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: fg, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
