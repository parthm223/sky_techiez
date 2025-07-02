import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

enum AppThemeMode { light, dark, system }

class ThemeController extends GetxController {
  static const String _themeKey = 'theme_mode';
  final _storage = GetStorage();
  
  // Observable theme mode
  final _themeMode = AppThemeMode.system.obs;
  
  // Observable for system brightness
  final _systemBrightness = Brightness.dark.obs;
  
  AppThemeMode get themeMode => _themeMode.value;
  Brightness get systemBrightness => _systemBrightness.value;
  
  // Get current effective theme
  bool get isDarkMode {
    switch (_themeMode.value) {
      case AppThemeMode.light:
        return false;
      case AppThemeMode.dark:
        return true;
      case AppThemeMode.system:
        return _systemBrightness.value == Brightness.dark;
    }
  }
  
  // Get Flutter ThemeMode for GetMaterialApp
  ThemeMode get flutterThemeMode {
    switch (_themeMode.value) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }
  
  @override
  void onInit() {
    super.onInit();
    _loadThemeFromStorage();
    _listenToSystemBrightness();
  }
  
  void _loadThemeFromStorage() {
    final savedTheme = _storage.read(_themeKey);
    if (savedTheme != null) {
      _themeMode.value = AppThemeMode.values.firstWhere(
        (mode) => mode.toString() == savedTheme,
        orElse: () => AppThemeMode.system,
      );
    }
    
    // Get initial system brightness
    _systemBrightness.value = WidgetsBinding.instance.platformDispatcher.platformBrightness;
  }
  
  void _listenToSystemBrightness() {
    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged = () {
      _systemBrightness.value = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      if (_themeMode.value == AppThemeMode.system) {
        _updateSystemUI();
      }
    };
  }
  
  Future<void> changeTheme(AppThemeMode themeMode) async {
    _themeMode.value = themeMode;
    await _storage.write(_themeKey, themeMode.toString());
    
    // Update system UI
    _updateSystemUI();
    
    // Haptic feedback
    HapticFeedback.lightImpact();
    
    // Show feedback
    _showThemeChangeSnackbar(themeMode);
  }
  
  void _updateSystemUI() {
    final isDark = isDarkMode;
    
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: isDark 
            ? const Color(0xFF0A0E1A) 
            : const Color(0xFFFFFFFF),
        systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
    );
  }
  
  void _showThemeChangeSnackbar(AppThemeMode mode) {
    String message;
    IconData icon;
    
    switch (mode) {
      case AppThemeMode.light:
        message = 'Light theme activated';
        icon = Icons.light_mode;
        break;
      case AppThemeMode.dark:
        message = 'Dark theme activated';
        icon = Icons.dark_mode;
        break;
      case AppThemeMode.system:
        message = 'System theme activated';
        icon = Icons.brightness_auto;
        break;
    }
    
    Get.snackbar(
      'Theme Changed',
      message,
      icon: Icon(icon, color: Colors.white),
      backgroundColor: isDarkMode 
          ? const Color(0xFF3366FF).withOpacity(0.9)
          : const Color(0xFF3366FF).withOpacity(0.9),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      snackPosition: SnackPosition.TOP,
    );
  }
  
  String getThemeModeText(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
      case AppThemeMode.system:
        return 'System';
    }
  }
  
  IconData getThemeModeIcon(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return Icons.light_mode;
      case AppThemeMode.dark:
        return Icons.dark_mode;
      case AppThemeMode.system:
        return Icons.brightness_auto;
    }
  }
}
