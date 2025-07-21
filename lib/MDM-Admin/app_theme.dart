import 'package:flutter/material.dart';

class AppTheme {
  // تعريف الألوان
  static const Color primaryColor = Color(0xFF2C3E50);
  static const Color accentColor = Color(0xFF3498DB);
  static const Color successColor = Color(0xFF2ECC71);
  static const Color dangerColor = Color(0xFFE74C3C);
  static const Color lightGray = Color(0xFFECF0F1);
  static const Color darkText = Color(0xFF333333);
  static const Color lightText = Color(0xFF7F8C8D);

  // تعريف الخطوط
  static const String fontFamily = 'Roboto';

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      
      // نظام الألوان
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        surface: Colors.white,
        background: lightGray,
        error: dangerColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: darkText,
        onBackground: darkText,
        onError: Colors.white,
      ),

      // شريط التطبيق
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: fontFamily,
        ),
      ),

      // الأزرار المرفوعة
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: fontFamily,
          ),
        ),
      ),

      // الأزرار النصية
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentColor,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: fontFamily,
          ),
        ),
      ),

      // البطاقات
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.white,
      ),

      // مربعات الحوار

      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: darkText,
          fontFamily: fontFamily,
        ),
        contentTextStyle: const TextStyle(
          fontSize: 16,
          color: darkText,
          fontFamily: fontFamily,
        ),
      ),

      // شريط التنبيهات
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentTextStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: fontFamily,
        ),
      ),

      // مؤشر التحميل
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: accentColor,
      ),

      // الفواصل
      dividerTheme: const DividerThemeData(
        color: primaryColor,
        thickness: 2,
        indent: 20,
        endIndent: 20,
      ),

      // النصوص
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: darkText,
          fontFamily: fontFamily,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: darkText,
          fontFamily: fontFamily,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: darkText,
          fontFamily: fontFamily,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: darkText,
          fontFamily: fontFamily,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: darkText,
          fontFamily: fontFamily,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: darkText,
          fontFamily: fontFamily,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: darkText,
          fontFamily: fontFamily,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: lightText,
          fontFamily: fontFamily,
        ),
      ),
    );
  }

  // ألوان مخصصة للحالات المختلفة
  static const Map<String, Color> statusColors = {
    'success': successColor,
    'error': dangerColor,
    'warning': Color(0xFFF39C12),
    'info': accentColor,
  };

  // أحجام الخطوط المخصصة
  static const Map<String, double> fontSizes = {
    'small': 12.0,
    'medium': 14.0,
    'large': 16.0,
    'xlarge': 18.0,
    'xxlarge': 20.0,
    'title': 24.0,
  };

  // المسافات المعيارية
  static const Map<String, double> spacing = {
    'xs': 4.0,
    'sm': 8.0,
    'md': 16.0,
    'lg': 24.0,
    'xl': 32.0,
    'xxl': 48.0,
  };

  // نصف أقطار الحدود
  static const Map<String, double> borderRadius = {
    'small': 8.0,
    'medium': 12.0,
    'large': 16.0,
    'xlarge': 24.0,
  };
}

