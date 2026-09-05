import 'package:flutter/material.dart';

import '../../../../core/config/env_config.dart';
import '../../../../core/core.dart';

/// Shown only when `--dart-define=MOCK_AUTH=true` is active, so it is obvious
/// that the credentials below are not being checked against anything.
/// Renders nothing otherwise.
class MockAuthNotice extends StatelessWidget {
  const MockAuthNotice({super.key});

  @override
  Widget build(BuildContext context) {
    if (!EnvConfig.useMockAuth) return const SizedBox.shrink();

    final colors = context.appColors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(getWidth(AppDimensions.paddingM)),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(getRadius(AppDimensions.radiusM)),
        border: Border.all(color: colors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.construction_rounded,
            size: getRadius(18),
            color: colors.primary,
          ),
          SizedBox(width: getWidth(AppDimensions.spaceS)),
          Expanded(
            child: Text(
              'Mock auth is on. Any email and password will sign you in.',
              style: TextStyle(
                fontSize: getSp(AppDimensions.fontXS),
                color: colors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
