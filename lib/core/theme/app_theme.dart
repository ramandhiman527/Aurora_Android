import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.lightPrimary,
      scaffoldBackgroundColor: AppColors.lightBackground,
      cardColor: AppColors.lightSurface,
      dividerColor: AppColors.lightBorder,
      
      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightPrimary,
        secondary: AppColors.lightSecondary,
        surface: AppColors.lightSurface,
        background: AppColors.lightBackground,
        error: AppColors.error,
        onPrimary: AppColors.lightSurface,
        onSecondary: AppColors.lightPrimary,
        onSurface: AppColors.lightTextPrimary,
        onBackground: AppColors.lightTextPrimary,
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: AppTypography.getDisplay(color: AppColors.lightTextPrimary),
        headlineLarge: AppTypography.getHeading1(color: AppColors.lightTextPrimary),
        headlineMedium: AppTypography.getHeading2(color: AppColors.lightTextPrimary),
        titleLarge: AppTypography.getHeading3(color: AppColors.lightTextPrimary),
        bodyLarge: AppTypography.getBodyLarge(color: AppColors.lightTextPrimary),
        bodyMedium: AppTypography.getBodyMedium(color: AppColors.lightTextSecondary),
        bodySmall: AppTypography.getBodySmall(color: AppColors.lightTextMuted),
        labelLarge: AppTypography.getButtonText(color: AppColors.lightSurface),
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppColors.lightPrimary),
        titleTextStyle: AppTypography.getHeading2(color: AppColors.lightTextPrimary),
        centerTitle: true,
      ),

      // Card Theme
      cardTheme: CardTheme(
        color: AppColors.lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.lightBorder, width: 1),
        ),
      ),

      // Button Theme
      buttonTheme: const ButtonThemeData(
        buttonColor: AppColors.lightPrimary,
        textTheme: ButtonTextTheme.primary,
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButtonStyleFrom(
          backgroundColor: AppColors.lightPrimary,
          foregroundColor: AppColors.lightSurface,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Pill-shaped buttons
          ),
          textStyle: AppTypography.getButtonText(color: AppColors.lightSurface),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
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
          borderSide: const BorderSide(color: AppColors.lightPrimary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        labelStyle: AppTypography.getBodyMedium(color: AppColors.lightTextSecondary),
        hintStyle: AppTypography.getBodyMedium(color: AppColors.lightTextMuted),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.lightSurface,
        selectedItemColor: AppColors.lightPrimary,
        unselectedItemColor: AppColors.lightTextMuted,
        elevation: 10,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.darkPrimary,
      scaffoldBackgroundColor: AppColors.darkBackground,
      cardColor: AppColors.darkSurface,
      dividerColor: AppColors.darkBorder,
      
      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkPrimary,
        secondary: AppColors.darkSecondary,
        surface: AppColors.darkSurface,
        background: AppColors.darkBackground,
        error: AppColors.error,
        onPrimary: AppColors.darkBackground,
        onSecondary: AppColors.darkPrimary,
        onSurface: AppColors.darkTextPrimary,
        onBackground: AppColors.darkTextPrimary,
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: AppTypography.getDisplay(color: AppColors.darkTextPrimary),
        headlineLarge: AppTypography.getHeading1(color: AppColors.darkTextPrimary),
        headlineMedium: AppTypography.getHeading2(color: AppColors.darkTextPrimary),
        titleLarge: AppTypography.getHeading3(color: AppColors.darkTextPrimary),
        bodyLarge: AppTypography.getBodyLarge(color: AppColors.darkTextPrimary),
        bodyMedium: AppTypography.getBodyMedium(color: AppColors.darkTextSecondary),
        bodySmall: AppTypography.getBodySmall(color: AppColors.darkTextMuted),
        labelLarge: AppTypography.getButtonText(color: AppColors.darkPrimary),
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppColors.darkPrimary),
        titleTextStyle: AppTypography.getHeading2(color: AppColors.darkTextPrimary),
        centerTitle: true,
      ),

      // Card Theme
      cardTheme: CardTheme(
        color: AppColors.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.darkBorder, width: 1),
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButtonStyleFrom(
          backgroundColor: AppColors.darkPrimary,
          foregroundColor: AppColors.darkBackground,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: AppTypography.getButtonText(color: AppColors.darkBackground),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
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
          borderSide: const BorderSide(color: AppColors.darkPrimary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        labelStyle: AppTypography.getBodyMedium(color: AppColors.darkTextSecondary),
        hintStyle: AppTypography.getBodyMedium(color: AppColors.darkTextMuted),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: AppColors.darkPrimary,
        unselectedItemColor: AppColors.darkTextMuted,
        elevation: 10,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  // Custom static styles helper for standard styling properties
  static ButtonStyle elevatedStyle(BuildContext context) => 
    Theme.of(context).elevatedButtonTheme.style!;
    
  static ButtonStyle outlineStyle(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    return OutlinedButton.styleFrom(
      foregroundColor: color,
      side: BorderSide(color: color, width: 1.5),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      textStyle: AppTypography.getButtonText(color: color),
    );
  }
}
// Helper extension to make standard buttons readable
extension ElevatedButtonStyleFrom on ElevatedButton {
  static ButtonStyle styleFrom({
    required Color backgroundColor,
    required Color foregroundColor,
    required double elevation,
    required EdgeInsetsGeometry padding,
    required OutlinedBorder shape,
    required TextStyle textStyle,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation,
      padding: padding,
      shape: shape,
      textStyle: textStyle,
    );
  }
}
