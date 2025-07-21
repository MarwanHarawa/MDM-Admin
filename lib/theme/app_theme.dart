import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // الألوان الأساسية المحسنة
  static const Color primaryColor = Color(0xFF1A237E);      // أزرق غامق أنيق
  static const Color primaryLight = Color(0xFF3F51B5);      // أزرق فاتح
  static const Color accentColor = Color(0xFF00BCD4);       // سماوي جذاب
  static const Color successColor = Color(0xFF4CAF50);      // أخضر للنجاح
  static const Color warningColor = Color(0xFFFF9800);      // برتقالي للتحذير
  static const Color dangerColor = Color(0xFFF44336);       // أحمر للخطر
  static const Color backgroundColor = Color(0xFFF8F9FA);   // خلفية فاتحة
  static const Color surfaceColor = Color(0xFFFFFFFF);      // لون السطح
  static const Color cardColor = Color(0xFFFFFFFF);         // لون الكاردات
  static const Color dividerColor = Color(0xFFE0E0E0);      // لون الفواصل
  
  // ألوان النصوص
  static const Color textPrimary = Color(0xFF212121);       // نص أساسي
  static const Color textSecondary = Color(0xFF757575);     // نص ثانوي
  static const Color textHint = Color(0xFFBDBDBD);          // نص التلميح
  static const Color textOnPrimary = Color(0xFFFFFFFF);     // نص على الأساسي
  
  // التدرجات اللونية
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [accentColor, Color(0xFF26C6DA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // الظلال
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];
  
  static List<BoxShadow> elevatedShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.12),
      blurRadius: 15,
      offset: const Offset(0, 6),
    ),
  ];

  // سمة التطبيق الرئيسية
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Cairo',
      
      // نظام الألوان
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        primaryContainer: primaryLight,
        secondary: accentColor,
        secondaryContainer: Color(0xFFE0F7FA),
        surface: surfaceColor,
        background: backgroundColor,
        error: dangerColor,
        onPrimary: textOnPrimary,
        onSecondary: textOnPrimary,
        onSurface: textPrimary,
        onBackground: textPrimary,
        onError: textOnPrimary,
      ),

      // شريط التطبيق
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: textPrimary,
          fontFamily: 'Cairo',
        ),
        iconTheme: const IconThemeData(
          color: textPrimary,
          size: 24,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),

      // الأزرار المرفوعة
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: textOnPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          shadowColor: primaryColor.withOpacity(0.3),
          textStyle: const TextStyle(
            fontSize: 16, 
            fontWeight: FontWeight.w600,
            fontFamily: 'Cairo',
          ),
        ),
      ),

      // الأزرار المحددة
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          side: const BorderSide(color: primaryColor, width: 2),
          textStyle: const TextStyle(
            fontSize: 16, 
            fontWeight: FontWeight.w600,
            fontFamily: 'Cairo',
          ),
        ),
      ),

      // أزرار النص
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(
            fontSize: 16, 
            fontWeight: FontWeight.w600,
            fontFamily: 'Cairo',
          ),
        ),
      ),

      // البطاقات
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: cardColor,
        shadowColor: Colors.black.withOpacity(0.1),
      ),

      // حقول الإدخال
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: dividerColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: dividerColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: dangerColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintStyle: const TextStyle(
          color: textHint,
          fontSize: 16,
          fontFamily: 'Cairo',
        ),
        labelStyle: const TextStyle(
          color: textSecondary,
          fontSize: 16,
          fontFamily: 'Cairo',
        ),
      ),

      // شريط التنبيهات
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentTextStyle: const TextStyle(
          fontSize: 16, 
          fontWeight: FontWeight.w500,
          fontFamily: 'Cairo',
        ),
        actionTextColor: accentColor,
      ),

      // مؤشر التحميل
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: accentColor,
        linearTrackColor: Color(0xFFE0E0E0),
        circularTrackColor: Color(0xFFE0E0E0),
      ),

      // الحوارات
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: surfaceColor,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textPrimary,
          fontFamily: 'Cairo',
        ),
        contentTextStyle: const TextStyle(
          fontSize: 16,
          color: textSecondary,
          fontFamily: 'Cairo',
        ),
      ),

      // القوائم المنسدلة
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: const TextStyle(
          fontSize: 16,
          color: textPrimary,
          fontFamily: 'Cairo',
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surfaceColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: dividerColor, width: 1),
          ),
        ),
      ),

      // أنماط النصوص
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textPrimary,
          fontFamily: 'Cairo',
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textPrimary,
          fontFamily: 'Cairo',
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textPrimary,
          fontFamily: 'Cairo',
        ),
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: textPrimary,
          fontFamily: 'Cairo',
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          fontFamily: 'Cairo',
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          fontFamily: 'Cairo',
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          fontFamily: 'Cairo',
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textPrimary,
          fontFamily: 'Cairo',
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textPrimary,
          fontFamily: 'Cairo',
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: textPrimary,
          fontFamily: 'Cairo',
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: textSecondary,
          fontFamily: 'Cairo',
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: textSecondary,
          fontFamily: 'Cairo',
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textPrimary,
          fontFamily: 'Cairo',
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textSecondary,
          fontFamily: 'Cairo',
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: textHint,
          fontFamily: 'Cairo',
        ),
      ),
    );
  }
}

// فئة للثوابت المتعلقة بالتصميم
class AppConstants {
  // المسافات
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;
  
  // أنصاف الأقطار
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 20.0;
  
  // الارتفاعات
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;
  
  // مدة الرسوم المتحركة
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration animationDurationSlow = Duration(milliseconds: 500);
  static const Duration animationDurationFast = Duration(milliseconds: 150);
}

