import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Logo image + "Cricket Live" wordmark.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 1.0, this.stacked = true});

  /// Scale factor: 1.0 = header size.
  final double size;

  /// true = "Cricket" over "Live" (as in the Home header).
  final bool stacked;

  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(
      fontSize: 20 * size,
      height: 1.05,
      fontWeight: FontWeight.w800,
      color: AppColors.textPrimary,
    );
    //final liveStyle = titleStyle.copyWith(color: AppColors.primaryLight);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _LogoMark(size: 44 * size),
        SizedBox(width: 8 * size),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: 'Wicketly', style: titleStyle),
            ],
          ),
        ),
      ],
    );
  }
}

/// The stumps-and-ball logo image (transparent PNG).
class _LogoMark extends StatelessWidget {
  const _LogoMark({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/app_logo.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
