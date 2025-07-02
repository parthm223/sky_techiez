import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sky_techiez/controllers/theme_controller.dart';
import 'package:sky_techiez/theme/app_theme.dart';
import 'package:sky_techiez/widgets/theme_selector_widget.dart';

class ThemeSettingsScreen extends StatelessWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Settings'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Theme Preview Cards
            _buildThemePreviewSection(context),
            const SizedBox(height: 24),
            
            // Theme Selector
            const ThemeSelectorWidget(),
            const SizedBox(height: 24),
            
            // Current Theme Info
            Obx(() => _buildCurrentThemeInfo(context, themeController)),
            const SizedBox(height: 24),
            
            // Additional Settings
            _buildAdditionalSettings(context),
          ],
        ),
      ),
    );
  }

  Widget _buildThemePreviewSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Theme Preview',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildPreviewCard(context, true)),
            const SizedBox(width: 16),
            Expanded(child: _buildPreviewCard(context, false)),
          ],
        ),
      ],
    );
  }

  Widget _buildPreviewCard(BuildContext context, bool isDark) {
    final backgroundColor = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final cardColor = isDark ? AppColors.darkCardBackground : AppColors.lightCardBackground;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final secondaryTextColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          // Mini app bar
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.darkPrimary,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Center(
              child: Text(
                isDark ? 'Dark' : 'Light',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 20,
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      child: Container(
                        decoration: BoxDecoration(
                          color: textColor.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 60,
                    height: 8,
                    decoration: BoxDecoration(
                      color: secondaryTextColor.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppColors.darkPrimary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 30,
                        height: 8,
                        decoration: BoxDecoration(
                          color: textColor.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentThemeInfo(BuildContext context, ThemeController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Theme.of(context).primaryColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Theme',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${controller.getThemeModeText(controller.themeMode)} theme is active',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (controller.themeMode == AppThemeMode.system)
                  Text(
                    'Following ${controller.isDarkMode ? 'dark' : 'light'} system setting',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalSettings(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About Themes',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoItem(
            context,
            Icons.light_mode,
            'Light Theme',
            'Optimized for daytime use with bright backgrounds',
          ),
          const SizedBox(height: 12),
          _buildInfoItem(
            context,
            Icons.dark_mode,
            'Dark Theme',
            'Reduces eye strain in low-light conditions',
          ),
          const SizedBox(height: 12),
          _buildInfoItem(
            context,
            Icons.brightness_auto,
            'System Theme',
            'Automatically switches based on your device settings',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).iconTheme.color?.withOpacity(0.7),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
