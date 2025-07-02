import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sky_techiez/controllers/theme_controller.dart';

class ThemeToggleButton extends StatelessWidget {
  final bool showLabel;
  final double iconSize;
  
  const ThemeToggleButton({
    super.key,
    this.showLabel = false,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    
    return Obx(() {
      final currentMode = themeController.themeMode;
      final nextMode = _getNextThemeMode(currentMode);
      
      if (showLabel) {
        return TextButton.icon(
          onPressed: () => themeController.changeTheme(nextMode),
          icon: Icon(
            themeController.getThemeModeIcon(currentMode),
            size: iconSize,
          ),
          label: Text(themeController.getThemeModeText(currentMode)),
        );
      }
      
      return IconButton(
        onPressed: () => themeController.changeTheme(nextMode),
        icon: Icon(
          themeController.getThemeModeIcon(currentMode),
          size: iconSize,
        ),
        tooltip: 'Switch to ${themeController.getThemeModeText(nextMode)} theme',
      );
    });
  }
  
  AppThemeMode _getNextThemeMode(AppThemeMode current) {
    switch (current) {
      case AppThemeMode.light:
        return AppThemeMode.dark;
      case AppThemeMode.dark:
        return AppThemeMode.system;
      case AppThemeMode.system:
        return AppThemeMode.light;
    }
  }
}
