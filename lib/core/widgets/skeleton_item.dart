import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../utils/app_size_class.dart';
import '../theme/app_colors.dart';

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
          borderRadius: BorderRadius.circular(getRadius(12)),
        ),
        child: Padding(
          padding: EdgeInsets.all(getRadius(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: getRadius(20),
                  ),
                  SizedBox(width: getWidth(12)),
                  Expanded(
                    child: Container(
                      height: getHeight(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(getRadius(4)),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: getHeight(12)),
              Container(
                height: getHeight(14),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(getRadius(4)),
                ),
              ),
              SizedBox(height: getHeight(8)),
              Container(
                height: getHeight(14),
                width: getWidth(200),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(getRadius(4)),
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
        vertical: getHeight(16),
      ),
      itemCount: itemCount,
      separatorBuilder: (context, index) => SizedBox(height: getHeight(12)),
      itemBuilder: (context, index) => const SkeletonItem(),
    );
  }
}
