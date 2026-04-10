import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:file_uploader/core/core.dart';
import 'package:file_uploader/core/storage/storage_service.dart';
import 'package:file_uploader/core/utils/settings_util.dart';
import 'package:file_uploader/routes/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return SingleChildScrollView(
      padding: EdgeInsets.all(getRadius(AppDimensions.paddingL)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, colors),
          SizedBox(height: getHeight(AppDimensions.spaceXXL)),
          _buildSettingsSection(context, colors),
          SizedBox(height: getHeight(AppDimensions.spaceXXL)),
          CustomButton(
            text: AppStrings.logout.tr,
            icon: Icons.logout_rounded,
            color: colors.error.withValues(alpha: 0.1),
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
      padding: EdgeInsets.all(getRadius(AppDimensions.paddingXL)),
      decoration: BoxDecoration(
        gradient: colors.primaryGradient,
        borderRadius: BorderRadius.circular(getRadius(AppDimensions.radiusXL)),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: getRadius(AppDimensions.avatarSize),
            height: getRadius(AppDimensions.avatarSize),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: AppDimensions.borderWidthExtraThick),
            ),
            child: Icon(Icons.person, size: getRadius(AppDimensions.iconXL), color: colors.primary),
          ),
          SizedBox(width: getWidth(AppDimensions.spaceL)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'John Doe',
                  fontSize: AppDimensions.fontXXL,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                CustomText(
                  text: 'johndoe@example.com',
                  fontSize: AppDimensions.fontS,
                  color: Colors.white.withValues(alpha: 0.8),
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
          padding: EdgeInsets.only(left: getWidth(AppDimensions.paddingXS), bottom: getHeight(AppDimensions.spaceM)),
          child: CustomText(
            text: AppStrings.settingsTitle.tr,
            fontSize: AppDimensions.fontXL,
            fontWeight: FontWeight.bold,
          ),
        ),
        _buildSettingCard(
          context,
          colors,
          icon: Icons.brightness_6_rounded,
          title: AppStrings.theme.tr,
          child: Obx(() => DropdownButton<String>(
                value: SettingsUtil.currentTheme.value,
                icon: Icon(Icons.keyboard_arrow_down_rounded, color: colors.primary),
                underline: const SizedBox(),
                borderRadius: BorderRadius.circular(getRadius(AppDimensions.radiusL)),
                dropdownColor: Theme.of(context).cardColor,
                items: [
                  DropdownMenuItem(value: 'system', child: CustomText(text: AppStrings.themeAuto.tr)),
                  DropdownMenuItem(value: 'light', child: CustomText(text: AppStrings.themeLight.tr)),
                  DropdownMenuItem(value: 'dark', child: CustomText(text: AppStrings.themeDark.tr)),
                ],
                onChanged: (String? theme) {
                  if (theme != null) SettingsUtil.changeTheme(theme);
                },
              )),
        ),
        SizedBox(height: getHeight(AppDimensions.spaceL)),
        _buildSettingCard(
          context,
          colors,
          icon: Icons.language_rounded,
          title: AppStrings.language.tr,
          child: Obx(() => DropdownButton<String>(
                value: SettingsUtil.currentLanguage.value,
                icon: Icon(Icons.keyboard_arrow_down_rounded, color: colors.primary),
                underline: const SizedBox(),
                borderRadius: BorderRadius.circular(getRadius(AppDimensions.radiusL)),
                dropdownColor: Theme.of(context).cardColor,
                items: [
                  DropdownMenuItem(value: 'en', child: CustomText(text: AppStrings.langEn.tr)),
                  DropdownMenuItem(value: 'ar', child: CustomText(text: AppStrings.langAr.tr)),
                  DropdownMenuItem(value: 'bn', child: CustomText(text: AppStrings.langBn.tr)),
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
      padding: EdgeInsets.symmetric(horizontal: getWidth(AppDimensions.paddingL), vertical: getHeight(AppDimensions.paddingS)),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(getRadius(AppDimensions.radiusXL)),
        border: Border.all(color: colors.outline.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(getRadius(AppDimensions.paddingS)),
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: Icon(icon, color: colors.primary, size: getRadius(AppDimensions.radiusXXL)),
          ),
          SizedBox(width: getWidth(AppDimensions.spaceL)),
          Expanded(
            child: CustomText(
              text: title,
              fontSize: AppDimensions.fontM,
              fontWeight: FontWeight.w500,
            ),
          ),
          child,
        ],
      ),
    );
  }
}
