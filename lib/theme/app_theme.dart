import 'package:flutter/material.dart';

class AppColors {
  // Light Theme Colors
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCardBackground = Color(0xFFFFFFFF);
  static const Color lightPrimary = Color(0xFF3366FF);
  static const Color lightSecondary = Color(0xFF1E40AF);
  static const Color lightAccent = Color(0xFF60A5FA);
  static const Color lightText = Color(0xFF1F2937);
  static const Color lightTextSecondary = Color(0xFF6B7280);
  static const Color lightBorder = Color(0xFFE5E7EB);

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF0A0E1A);
  static const Color darkSurface = Color(0xFF1F2937);
  static const Color darkCardBackground = Color(0xFF111827);
  static const Color darkPrimary = Color(0xFF3366FF);
  static const Color darkSecondary = Color(0xFF1E40AF);
  static const Color darkAccent = Color(0xFF60A5FA);
  static const Color darkText = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);
  static const Color darkBorder = Color(0xFF374151);

  // Legacy colors for backward compatibility
  static const Color primaryBlue = Color(0xFF3366FF);
  static const Color secondaryBlue = Color(0xFF1E40AF);
  static const Color accentBlue = Color(0xFF60A5FA);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color darkGrey = Color(0xFF1F2937);
  static const Color grey = Color(0xFF6B7280);
  static const Color lightGrey = Color(0xFF374151);
  static const Color cardBackground = Color(0xFF111827);
  static const Color surfaceColor = Color(0xFF1F2937);

  // Common Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Gradients
  static const List<Color> primaryGradient = [
    Color(0xFF3366FF),
    Color(0xFF1E40AF),
  ];

  static const List<Color> lightCardGradient = [
    Color(0xFFFFFFFF),
    Color(0xFFF8FAFC),
  ];

  static const List<Color> darkCardGradient = [
    Color(0xFF1F2937),
    Color(0xFF111827),
  ];

  static const List<Color> cardGradient = [
    Color(0xFF1F2937),
    Color(0xFF111827),
  ];

  // Chat bubble colors
  static const Color userMessageBackground = Color(0xFF3366FF);
  static const Color supportMessageBackground = Color(0xFF333333);
  static const Color systemMessageBackground = Color(0xFF444444);
}

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData.light().copyWith(
      scaffoldBackgroundColor: AppColors.lightBackground,
      primaryColor: AppColors.lightPrimary,
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightPrimary,
        secondary: AppColors.lightAccent,
        surface: AppColors.lightSurface,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onSurface: AppColors.lightText,
        error: AppColors.error,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        iconTheme: IconThemeData(
          color: AppColors.white,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge:
            TextStyle(color: AppColors.lightText, fontWeight: FontWeight.bold),
        displayMedium:
            TextStyle(color: AppColors.lightText, fontWeight: FontWeight.w600),
        displaySmall:
            TextStyle(color: AppColors.lightText, fontWeight: FontWeight.w500),
        headlineLarge:
            TextStyle(color: AppColors.lightText, fontWeight: FontWeight.bold),
        headlineMedium:
            TextStyle(color: AppColors.lightText, fontWeight: FontWeight.w600),
        headlineSmall:
            TextStyle(color: AppColors.lightText, fontWeight: FontWeight.w500),
        titleLarge:
            TextStyle(color: AppColors.lightText, fontWeight: FontWeight.w600),
        titleMedium:
            TextStyle(color: AppColors.lightText, fontWeight: FontWeight.w500),
        titleSmall:
            TextStyle(color: AppColors.lightText, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(color: AppColors.lightText, height: 1.5),
        bodyMedium: TextStyle(color: AppColors.lightText, height: 1.4),
        bodySmall: TextStyle(color: AppColors.lightTextSecondary, height: 1.3),
        labelLarge:
            TextStyle(color: AppColors.lightText, fontWeight: FontWeight.w500),
        labelMedium: TextStyle(color: AppColors.lightText),
        labelSmall: TextStyle(color: AppColors.lightTextSecondary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightCardBackground,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: const TextStyle(color: AppColors.lightTextSecondary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightPrimary,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.lightPrimary,
          side: const BorderSide(color: AppColors.lightPrimary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.lightPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.lightSurface,
        selectedItemColor: AppColors.lightPrimary,
        unselectedItemColor: AppColors.lightTextSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.lightBorder,
        thickness: 1,
        space: 1,
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: AppColors.darkBackground,
      primaryColor: AppColors.darkPrimary,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkPrimary,
        secondary: AppColors.darkAccent,
        surface: AppColors.darkSurface,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onSurface: AppColors.darkText,
        error: AppColors.error,
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        iconTheme: IconThemeData(
          color: AppColors.white,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge:
            TextStyle(color: AppColors.darkText, fontWeight: FontWeight.bold),
        displayMedium:
            TextStyle(color: AppColors.darkText, fontWeight: FontWeight.w600),
        displaySmall:
            TextStyle(color: AppColors.darkText, fontWeight: FontWeight.w500),
        headlineLarge:
            TextStyle(color: AppColors.darkText, fontWeight: FontWeight.bold),
        headlineMedium:
            TextStyle(color: AppColors.darkText, fontWeight: FontWeight.w600),
        headlineSmall:
            TextStyle(color: AppColors.darkText, fontWeight: FontWeight.w500),
        titleLarge:
            TextStyle(color: AppColors.darkText, fontWeight: FontWeight.w600),
        titleMedium:
            TextStyle(color: AppColors.darkText, fontWeight: FontWeight.w500),
        titleSmall:
            TextStyle(color: AppColors.darkText, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(color: AppColors.darkText, height: 1.5),
        bodyMedium: TextStyle(color: AppColors.darkText, height: 1.4),
        bodySmall: TextStyle(color: AppColors.darkTextSecondary, height: 1.3),
        labelLarge:
            TextStyle(color: AppColors.darkText, fontWeight: FontWeight.w500),
        labelMedium: TextStyle(color: AppColors.darkText),
        labelSmall: TextStyle(color: AppColors.darkTextSecondary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCardBackground,
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.darkPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: const TextStyle(color: AppColors.darkTextSecondary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkPrimary,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.darkPrimary,
          side: const BorderSide(color: AppColors.darkPrimary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.darkPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkBackground,
        selectedItemColor: AppColors.darkPrimary,
        unselectedItemColor: AppColors.darkTextSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 20,
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.darkBorder.withOpacity(0.3),
        thickness: 1,
        space: 1,
      ),
    );
  }
}
