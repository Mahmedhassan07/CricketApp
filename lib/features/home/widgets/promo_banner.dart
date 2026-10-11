import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

/// "Big Matches, Bigger Moments" banner with the batsman background image.
class PromoBanner extends StatelessWidget {
  const PromoBanner({
    super.key,
    this.image = const AssetImage('assets/images/home_banner.png'),
  });

  /// Background picture. The batsman sits on the right of the image, so it
  /// is anchored right and the text goes on the plain left side.
  final ImageProvider image;

  @override
  Widget build(BuildContext context) {
    return Container(
      // Grows with the text on narrow screens / large font settings.
      constraints: const BoxConstraints(minHeight: 150),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(color: AppColors.border),
        color: AppColors.mint, // shown while the image loads
        image: DecorationImage(
          image: image,
          fit: BoxFit.cover,
          alignment: Alignment.centerRight,
        ),
      ),
      child: const Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.fromLTRB(18, 18, 120, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Live Cricket',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Big Matches\nBigger Moments',
                style: TextStyle(
                  fontSize: 21,
                  height: 1.15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Stay updated with the latest matches, scores and more.',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
