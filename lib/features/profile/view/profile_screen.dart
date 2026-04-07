import 'package:file_uploader/core/storage/storage_service.dart';
import 'package:file_uploader/core/theme/app_colors.dart';
import 'package:file_uploader/core/utils/app_size_class.dart';
import 'package:file_uploader/core/utils/settings_util.dart';
import 'package:file_uploader/core/widgets/custom_button.dart';
import 'package:file_uploader/core/widgets/custom_text.dart';
import 'package:file_uploader/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return SingleChildScrollView(
      padding: EdgeInsets.all(getRadius(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, colors),
          SizedBox(height: getHeight(32)),
          _buildSettingsSection(context, colors),
          SizedBox(height: getHeight(32)),
          CustomButton(
            text: 'logout'.tr,
            icon: Icons.logout_rounded,
            color: colors.error.withOpacity(0.1),
            textColor: colors.error,
            onPressed: () async {
              await Get.find<StorageService>().clearAuth();
              Get.offAllNamed(AppRoutes.login);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppColorScheme colors) {
    return Container(
      padding: EdgeInsets.all(getRadius(20)),
      decoration: BoxDecoration(
        gradient: colors.primaryGradient,
        borderRadius: BorderRadius.circular(getRadius(20)),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: getRadius(70),
            height: getRadius(70),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: Icon(Icons.person, size: getRadius(40), color: colors.primary),
          ),
          SizedBox(width: getWidth(16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  text: "John Doe", 
                  fontSize: 20, 
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                CustomText(
                  text: "johndoe@example.com",
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context, AppColorScheme colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: getWidth(4), bottom: getHeight(12)),
          child: CustomText(
            text: 'settings_title'.tr,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        _buildSettingCard(
          context,
          colors,
          icon: Icons.brightness_6_rounded,
          title: 'theme'.tr,
          child: Obx(() => DropdownButton<String>(
                value: SettingsUtil.currentTheme.value,
                icon: Icon(Icons.keyboard_arrow_down_rounded, color: colors.primary),
                underline: const SizedBox(),
                borderRadius: BorderRadius.circular(12),
                dropdownColor: Theme.of(context).cardColor,
                items: [
                  DropdownMenuItem(value: 'system', child: CustomText(text: 'theme_auto'.tr)),
                  DropdownMenuItem(value: 'light', child: CustomText(text: 'theme_light'.tr)),
                  DropdownMenuItem(value: 'dark', child: CustomText(text: 'theme_dark'.tr)),
                ],
                onChanged: (String? theme) {
                  if (theme != null) SettingsUtil.changeTheme(theme);
                },
              )),
        ),
        SizedBox(height: getHeight(16)),
        _buildSettingCard(
          context,
          colors,
          icon: Icons.language_rounded,
          title: 'language'.tr,
          child: Obx(() => DropdownButton<String>(
                value: SettingsUtil.currentLanguage.value,
                icon: Icon(Icons.keyboard_arrow_down_rounded, color: colors.primary),
                underline: const SizedBox(),
                borderRadius: BorderRadius.circular(12),
                dropdownColor: Theme.of(context).cardColor,
                items: [
                  DropdownMenuItem(value: 'en', child: CustomText(text: 'lang_en'.tr)),
                  DropdownMenuItem(value: 'ar', child: CustomText(text: 'lang_ar'.tr)),
                  DropdownMenuItem(value: 'bn', child: CustomText(text: 'lang_bn'.tr)),
                ],
                onChanged: (String? lang) {
                  if (lang != null) SettingsUtil.changeLanguage(lang);
                },
              )),
        ),
      ],
    );
  }

  Widget _buildSettingCard(
    BuildContext context, 
    AppColorScheme colors, {
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: getWidth(16), vertical: getHeight(8)),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(getRadius(16)),
        border: Border.all(color: colors.outline.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(getRadius(8)),
            decoration: BoxDecoration(
              color: colors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: colors.primary, size: getRadius(22)),
          ),
          SizedBox(width: getWidth(16)),
          Expanded(
            child: CustomText(
              text: title,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          child,
        ],
      ),
    );
  }
}
