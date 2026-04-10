import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../utils/app_size_class.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';

class SkeletonItem extends StatelessWidget {
  const SkeletonItem({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Shimmer.fromColors(
      baseColor: colors.surfaceVariant,
      highlightColor: colors.elevatedSurface,
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(getRadius(AppDimensions.radiusL)),
        ),
        child: Padding(
          padding: EdgeInsets.all(getRadius(AppDimensions.paddingL)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: getRadius(AppDimensions.paddingXL),
                  ),
                  SizedBox(width: getWidth(AppDimensions.spaceM)),
                  Expanded(
                    child: Container(
                      height: getHeight(AppDimensions.paddingL),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(getRadius(AppDimensions.paddingXS)),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: getHeight(AppDimensions.spaceM)),
              Container(
                height: getHeight(AppDimensions.fontS),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(getRadius(AppDimensions.paddingXS)),
                ),
              ),
              SizedBox(height: getHeight(AppDimensions.spaceS)),
              Container(
                height: getHeight(AppDimensions.fontS),
                width: getWidth(AppDimensions.skeletonWidthLarge),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(getRadius(AppDimensions.paddingXS)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SkeletonListView extends StatelessWidget {
  final int itemCount;

  const SkeletonListView({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(
        horizontal: hPadding,
        vertical: getHeight(AppDimensions.paddingL),
      ),
      itemCount: itemCount,
      separatorBuilder: (context, index) => SizedBox(height: getHeight(AppDimensions.spaceM)),
      itemBuilder: (context, index) => const SkeletonItem(),
    );
  }
}
