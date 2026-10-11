import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Round chip for one delivery: "0", "4", "6", "W", "Wd", "Nb"...
class BallChip extends StatelessWidget {
  const BallChip({super.key, required this.ball, this.size = 30});

  final String ball;
  final double size;

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg) = switch (ball) {
      'W' => (AppColors.wicket, Colors.white),
      '4' => (AppColors.four, Colors.white),
      '6' => (AppColors.six, Colors.white),
      'Wd' || 'Nb' => (const Color(0xFFFEF3C7), const Color(0xFFB45309)),
      '0' => (AppColors.completedSoft, AppColors.textSecondary),
      _ => (AppColors.primarySoft, AppColors.primaryDark),
    };

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Text(
        ball,
        style: TextStyle(
          color: fg,
          fontWeight: FontWeight.w700,
          fontSize: ball.length > 1 ? size * 0.36 : size * 0.45,
        ),
      ),
    );
  }
}
