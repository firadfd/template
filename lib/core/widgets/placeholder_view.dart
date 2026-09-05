import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../utils/app_size_class.dart';

/// A neutral placeholder for tabs that have not been built yet.
///
/// Replace these with your own feature screens. See `lib/features/auth` for a
/// complete vertical slice: binding -> controller -> repository -> view.
class PlaceholderView extends StatelessWidget {
  final String title;
  final IconData icon;

  const PlaceholderView({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.background,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: hPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: getRadius(56), color: colors.textHint),
              SizedBox(height: getHeight(AppDimensions.spaceL)),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: getSp(AppDimensions.fontL),
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
