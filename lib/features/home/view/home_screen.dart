import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:file_uploader/core/core.dart';
import 'package:file_uploader/core/widgets/empty_view.dart';
import '../controller/home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    final colors = context.appColors;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxCWidth),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const SkeletonListView(itemCount: 8);
          }

          if (controller.errorMsg.isNotEmpty && controller.posts.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(getRadius(AppDimensions.paddingXXL)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: getRadius(AppDimensions.spaceMassive), color: colors.error),
                    SizedBox(height: getHeight(AppDimensions.spaceL)),
                    CustomText(
                      text: controller.errorMsg.value,
                      color: colors.error,
                      textAlign: TextAlign.center,
                      fontSize: AppDimensions.fontL,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: getHeight(AppDimensions.spaceXL)),
                    ElevatedButton(
                      onPressed: controller.refreshData,
                      child: Text('retry'.tr),
                    ),
                  ],
                ),
              ),
            );
          }

          if (controller.posts.isEmpty) {
            return const EmptyView(message: 'No posts available.');
          }

          return RefreshIndicator(
            onRefresh: controller.refreshData,
            child: ListView.separated(
              controller: controller.scrollController,
              padding: EdgeInsets.symmetric(
                horizontal: hPadding,
                vertical: getHeight(AppDimensions.paddingL),
              ),
              itemCount: controller.posts.length + (controller.isMoreLoading.value ? 1 : 0),
              separatorBuilder: (context, index) => SizedBox(height: getHeight(AppDimensions.spaceM)),
              itemBuilder: (context, index) {
                if (index >= controller.posts.length) {
                  return const SkeletonItem();
                }

                final item = controller.posts[index];
                return _CardItem(item: item, colors: colors);
              },
            ),
          );
        }),
      ),
    );
  }
}

class _CardItem extends StatelessWidget {
  final dynamic item;
  final AppColorScheme colors;

  const _CardItem({required this.item, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        child: Padding(
          padding: EdgeInsets.all(getRadius(AppDimensions.paddingL)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: getRadius(AppDimensions.iconXXL),
                    height: getRadius(AppDimensions.iconXXL),
                    decoration: BoxDecoration(
                      gradient: colors.primaryGradient,
                      borderRadius: BorderRadius.circular(getRadius(AppDimensions.radiusM)),
                    ),
                    child: Center(
                      child: CustomText(
                        text: "${item.id}",
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: AppDimensions.fontS,
                      ),
                    ),
                  ),
                  SizedBox(width: getWidth(AppDimensions.spaceM)),
                  Expanded(
                    child: CustomText(
                      text: item.title ?? 'No Title',
                      fontWeight: FontWeight.bold,
                      fontSize: AppDimensions.fontL,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
              SizedBox(height: getHeight(AppDimensions.spaceM)),
              CustomText(
                text: item.body ?? 'No Description',
                color: colors.textSecondary,
                fontSize: AppDimensions.fontS,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
