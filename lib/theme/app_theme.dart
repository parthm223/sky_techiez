import 'package:flutter/material.dart';

class AppColors {
  // Main colors from the website
  static const Color darkBackground = Color(0xFF121212);
  static const Color primaryBlue = Color(0xFF3366FF);
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  // Additional colors
  static const Color darkGrey = Color(0xFF333333);
  static const Color grey = Color(0xFF666666);
  static const Color lightGrey = Color(0xFF1E1E1E);
  static const Color cardBackground = Color(0xFF1A1A1A);
}

class AppTheme {
  static ThemeData darkTheme() {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: AppColors.darkBackground,
      primaryColor: AppColors.primaryBlue,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryBlue,
        secondary: AppColors.primaryBlue,
        surface: AppColors.cardBackground,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onSurface: AppColors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(
          color: AppColors.white,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: AppColors.white),
        displayMedium: TextStyle(color: AppColors.white),
        displaySmall: TextStyle(color: AppColors.white),
        headlineLarge: TextStyle(color: AppColors.white),
        headlineMedium: TextStyle(color: AppColors.white),
        headlineSmall: TextStyle(color: AppColors.white),
        titleLarge: TextStyle(color: AppColors.white),
        titleMedium: TextStyle(color: AppColors.white),
        titleSmall: TextStyle(color: AppColors.white),
        bodyLarge: TextStyle(color: AppColors.white),
        bodyMedium: TextStyle(color: AppColors.white),
        bodySmall: TextStyle(color: AppColors.white),
        labelLarge: TextStyle(color: AppColors.white),
        labelMedium: TextStyle(color: AppColors.white),
        labelSmall: TextStyle(color: AppColors.white),
      ),
      cardTheme: CardTheme(
        color: AppColors.cardBackground,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightGrey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primaryBlue),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: const TextStyle(color: AppColors.grey),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryBlue,
          side: const BorderSide(color: AppColors.primaryBlue),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryBlue,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkBackground,
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: AppColors.grey,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.lightGrey,
        thickness: 1,
      ),
    );
  }
}
