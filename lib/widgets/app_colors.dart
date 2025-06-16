import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_models/theme_controller.dart';

class AppColors {
  static ThemeController get _controller => Get.find<ThemeController>();

  // Main colors that can be customized
  static Color get primary => _controller.primaryColor;
  static Color get secondary => _controller.secondaryColor;

  // Semantic colors
  static Color get danger => const Color(0xFFD32F2F);
  static Color get success => const Color(0xFF388E3C);
  static Color get warning => const Color(0xFFFFC107);
  static Color get info => const Color(0xFF1976D2);

  // Background colors
  static Color get background => _controller.isDark ? _darkBackground : _lightBackground;
  static Color get surface => _controller.isDark ? _darkSurface : _lightSurface;
  static Color get cardBackground => _controller.isDark ? _darkCardBackground : _lightCardBackground;

  // Text colors
  static Color get textPrimary => _controller.isDark ? _darkTextPrimary : _lightTextPrimary;
  static Color get textSecondary => _controller.isDark ? _darkTextSecondary : _lightTextSecondary;
  static Color get textDisabled => _controller.isDark ? _darkTextDisabled : _lightTextDisabled;

  // Border colors
  static Color get border => _controller.isDark ? _darkBorder : _lightBorder;
  static Color get divider => _controller.isDark ? _darkDivider : _lightDivider;

  // Icon colors
  static Color get icon => _controller.isDark ? _darkIcon : _lightIcon;

  // Light theme colors
  static const Color _lightBackground = Color(0xFFF5F7FA);
  static const Color _lightSurface = Color(0xFFFFFFFF);
  static const Color _lightCardBackground = Color(0xFFFFFFFF);
  static const Color _lightTextPrimary = Color(0xFF333333);
  static const Color _lightTextSecondary = Color(0xFF757575);
  static const Color _lightTextDisabled = Color(0xFFBDBDBD);
  static const Color _lightBorder = Color(0xFFE0E0E0);
  static const Color _lightDivider = Color(0xFFEEEEEE);
  static const Color _lightIcon = Color(0xFF616161);

  // Dark theme colors
  static const Color _darkBackground = Color(0xFF121212);
  static const Color _darkSurface = Color(0xFF1E1E1E);
  static const Color _darkCardBackground = Color(0xFF1E1E1E);
  static const Color _darkTextPrimary = Color(0xFFE0E0E0);
  static const Color _darkTextSecondary = Color(0xFFB0B0B0);
  static const Color _darkTextDisabled = Color(0xFF757575);
  static const Color _darkBorder = Color(0xFF333333);
  static const Color _darkDivider = Color(0xFF424242);
  static const Color _darkIcon = Color(0xFFE0E0E0);

  // Additional helper methods
  static ColorScheme get colorScheme => _controller.isDark
      ? const ColorScheme.dark().copyWith(
    primary: primary,
    secondary: secondary,
  )
      : const ColorScheme.light().copyWith(
    primary: primary,
    secondary: secondary,
  );

  static ThemeData get themeData => _controller.isDark ? _darkTheme : _lightTheme;

  static final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primary,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: background,
    cardColor: cardBackground,
    dividerColor: divider,
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: textPrimary),
      bodyMedium: TextStyle(color: textPrimary),
      bodySmall: TextStyle(color: textSecondary),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primary,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: Colors.white,
    ),
  );

  static final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primary,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: background,
    cardColor: cardBackground,
    dividerColor: divider,
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: textPrimary),
      bodyMedium: TextStyle(color: textPrimary),
      bodySmall: TextStyle(color: textSecondary),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: surface,
      elevation: 0,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primary,
    ),
  );
}
