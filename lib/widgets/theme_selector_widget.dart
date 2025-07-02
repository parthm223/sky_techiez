import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sky_techiez/controllers/theme_controller.dart';
import 'package:sky_techiez/theme/app_theme.dart';

class ThemeSelectorWidget extends StatelessWidget {
  const ThemeSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.palette,
                  color: AppColors.info,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Theme Settings',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Choose your preferred theme appearance',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
          ),
          const SizedBox(height: 20),
          Obx(() => Column(
                children: AppThemeMode.values.map((mode) {
                  final isSelected = themeController.themeMode == mode;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _buildThemeOption(
                      context,
                      mode,
                      isSelected,
                      themeController,
                    ),
                  );
                }).toList(),
              )),
        ],
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    AppThemeMode mode,
    bool isSelected,
    ThemeController controller,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => controller.changeTheme(mode),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).primaryColor.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).dividerColor.withOpacity(0.3),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).primaryColor.withOpacity(0.2)
                      : Theme.of(context).dividerColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  controller.getThemeModeIcon(mode),
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).iconTheme.color?.withOpacity(0.7),
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.getThemeModeText(mode),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : null,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _getThemeDescription(mode),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 12,
                          ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _getThemeDescription(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return 'Always use light theme';
      case AppThemeMode.dark:
        return 'Always use dark theme';
      case AppThemeMode.system:
        return 'Follow system settings';
    }
  }
}
