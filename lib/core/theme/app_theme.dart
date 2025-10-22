import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFFD32F2F);
  static const Color onPrimary = Colors.white;
  static const Color surface = Color(0xFFFAFAFA);
  static const Color onSurface = Color(0xFF1F1F1F);
  static const Color accent = Color(0xFFB71C1C);
  static const Color border = Color(0xFFE0E0E0);
}

class AppTextStyles {
  AppTextStyles._();

  static const double baseFontSize = 16;

  static const TextStyle headline = TextStyle(
    fontSize: baseFontSize + 6,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
  );

  static const TextStyle body = TextStyle(
    fontSize: baseFontSize,
    color: AppColors.onSurface,
  );

  static const TextStyle caption = TextStyle(
    fontSize: baseFontSize - 2,
    color: AppColors.onSurface,
  );
}

class AppSizes {
  AppSizes._();

  static const double iconSmall = 20;
  static const double iconMedium = 28;
  static const double iconLarge = 36;
  static const double cornerRadius = 12;
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData(
      colorSchemeSeed: AppColors.primary,
      useMaterial3: true,
      fontFamily: null,
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.surface,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        secondary: AppColors.accent,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 0,
        titleTextStyle: AppTextStyles.headline.copyWith(
          color: AppColors.onPrimary,
        ),
        iconTheme: const IconThemeData(color: AppColors.onPrimary),
      ),
      textTheme: TextTheme(
        headlineSmall: AppTextStyles.headline,
        bodyMedium: AppTextStyles.body,
        bodyLarge: AppTextStyles.body.copyWith(fontSize: AppTextStyles.baseFontSize + 2),
        labelSmall: AppTextStyles.caption,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.onSurface.withOpacity(0.55),
        selectedIconTheme: const IconThemeData(size: AppSizes.iconMedium),
        unselectedIconTheme: const IconThemeData(size: AppSizes.iconSmall),
        showUnselectedLabels: true,
        elevation: 8,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.cornerRadius),
          ),
          textStyle: AppTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.cornerRadius),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.cornerRadius),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
