import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:get/get.dart';

import 'package:file_uploader/core/core.dart';
import 'package:file_uploader/core/widgets/empty_view.dart';
import '../model/home_model.dart';
import '../controller/home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.background,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxCWidth),
          child: Obx(() {
            if (controller.errorMsg.isNotEmpty && controller.posts.isEmpty) {
              return _buildErrorView(controller, colors);
            }

            if (controller.posts.isEmpty && !controller.isLoading.value) {
              return const EmptyView(message: 'No posts available.');
            }

            return Skeletonizer(
              enabled: controller.isLoading.value,
              child: RefreshIndicator(
                onRefresh: controller.refreshData,
                child: ListView.separated(
                  controller: controller.scrollController,
                  padding: EdgeInsets.all(getRadius(AppDimensions.paddingL)),
                  itemCount: controller.isLoading.value ? 6 : (controller.posts.length + (controller.isMoreLoading.value ? 1 : 0)),
                  separatorBuilder: (context, index) => SizedBox(height: getHeight(AppDimensions.spaceM)),
                  itemBuilder: (context, index) {
                    if (controller.isLoading.value) {
                      return const _CardItemSkeleton();
                    }

                    if (index >= controller.posts.length) {
                      return const _CardItemSkeleton();
                    }

                    final item = controller.posts[index];
                    return _CardItem(item: item, colors: colors);
                  },
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildErrorView(HomeController controller, AppColorScheme colors) {
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
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: getWidth(AppDimensions.paddingXXL),
                  vertical: getHeight(AppDimensions.paddingM),
                ),
              ),
              child: Text('retry'.tr),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardItemSkeleton extends StatelessWidget {
  const _CardItemSkeleton();

  @override
  Widget build(BuildContext context) {
    return _CardItem(
      item: HomeModel(
        id: 1,
        title: 'This is a skeleton title placeholder that spans two lines',
        body: 'This is a much longer body text for the skeleton placeholder to ensure the layout looks realistic while loading.',
      ),
      colors: context.appColors,
    );
  }
}

class _CardItem extends StatelessWidget {
  final HomeModel item;
  final AppColorScheme colors;

  const _CardItem({required this.item, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(getRadius(AppDimensions.radiusL)),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(getRadius(AppDimensions.radiusL)),
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
                          text: "${item.id ?? 0}",
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: AppDimensions.fontS,
                        ),
                      ),
                    ),
                    SizedBox(width: getWidth(AppDimensions.spaceM)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: item.title ?? 'No Title',
                            fontWeight: FontWeight.bold,
                            fontSize: AppDimensions.fontL,
                            maxLines: 2,
                            color: colors.textPrimary,
                          ),
                          if (item.userId != null)
                            Padding(
                              padding: EdgeInsets.only(top: getHeight(4)),
                              child: CustomText(
                                text: 'User ID: ${item.userId}',
                                fontSize: AppDimensions.fontXS,
                                color: colors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: colors.textHint, size: getRadius(20)),
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
      ),
    );
  }
}
