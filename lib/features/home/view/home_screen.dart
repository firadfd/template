import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:file_uploader/core/utils/app_size_class.dart';
import 'package:file_uploader/core/theme/app_colors.dart';
import 'package:file_uploader/core/widgets/skeleton_item.dart';
import 'package:file_uploader/core/widgets/custom_text.dart';
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
                padding: EdgeInsets.all(getRadius(32)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: getRadius(64), color: colors.error),
                    SizedBox(height: getHeight(16)),
                    CustomText(
                      text: controller.errorMsg.value,
                      color: colors.error,
                      textAlign: TextAlign.center,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: getHeight(24)),
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
                vertical: getHeight(16),
              ),
              itemCount: controller.posts.length + (controller.isMoreLoading.value ? 1 : 0),
              separatorBuilder: (context, index) => SizedBox(height: getHeight(12)),
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
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(getRadius(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: getRadius(40),
                    height: getRadius(40),
                    decoration: BoxDecoration(
                      gradient: colors.primaryGradient,
                      borderRadius: BorderRadius.circular(getRadius(10)),
                    ),
                    child: Center(
                      child: CustomText(
                        text: "${item.id}",
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(width: getWidth(12)),
                  Expanded(
                    child: CustomText(
                      text: item.title ?? 'No Title',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
              SizedBox(height: getHeight(12)),
              CustomText(
                text: item.body ?? 'No Description',
                color: colors.textSecondary,
                fontSize: 14,
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
