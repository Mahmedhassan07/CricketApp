import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// "Cricket Live" wordmark with a ball icon.
/// To use a real logo later, replace [_LogoMark] with Image.asset(...).
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
    final liveStyle = titleStyle.copyWith(color: AppColors.primaryLight);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _LogoMark(size: 40 * size),
        SizedBox(width: 8 * size),
        stacked
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Cricket', style: titleStyle),
                  Text('Live', style: liveStyle),
                ],
              )
            : Text.rich(TextSpan(children: [
                TextSpan(text: 'Cricket ', style: titleStyle),
                TextSpan(text: 'Live', style: liveStyle),
              ])),
      ],
    );
  }
}

class _LogoMark extends StatelessWidget {
  const _LogoMark({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryLight, AppColors.primaryDark],
        ),
      ),
      child: Icon(Icons.sports_cricket, color: Colors.white, size: size * 0.6),
    );
  }
}
