// lib/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  // الألوان الأساسية - يمكنك تغيير اللون الرئيسي هنا
  static const Color primaryColor = Color.fromARGB(255, 98, 154, 181); // اللون الأساسي

  // درجات اللون الأساسي
  static const Color primaryLight = Color.fromARGB(255, 138, 184, 211);
  static const Color primaryDark = Color.fromARGB(255, 68, 127, 152);
  static const Color primaryVeryLight = Color.fromARGB(255, 218, 235, 245);
  static const Color primaryShadow = Color.fromARGB(50, 98, 154, 181);

  // الألوان المساعدة
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE74C3C);
  static const Color warning = Color(0xFFFFA726);
  static const Color info = Color(0xFF2196F3);

  // ألوان الخلفيات
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF1F3F4);
  static const Color cardBackground = Colors.white;

  // ألوان النصوص
  static const Color textPrimary = Color(0xFF202124);
  static const Color textSecondary = Color(0xFF5F6368);
  static const Color textHint = Color(0xFF9AA0A6);
  static const Color textOnPrimary = Colors.white;

  // ألوان الحدود والأشكال
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFEEEEEE);
  static const Color shadow = Color(0x1A000000);

  // المخططات المتدرجة
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryColor, primaryDark],
  );

  static const LinearGradient primaryLightGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryLight, primaryColor],
  );

  // الأنماط النصية
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    fontFamily: 'Tajawal',
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    fontFamily: 'Tajawal',
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    fontFamily: 'Tajawal',
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    color: textPrimary,
    fontFamily: 'Tajawal',
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    color: textSecondary,
    fontFamily: 'Tajawal',
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    color: textHint,
    fontFamily: 'Tajawal',
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textOnPrimary,
    fontFamily: 'Tajawal',
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: textHint,
    fontFamily: 'Tajawal',
  );

  // الظلال
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: shadow,
      blurRadius: 10,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get buttonShadow => [
    BoxShadow(
      color: primaryShadow,
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get floatingButtonShadow => [
    BoxShadow(
      color: primaryShadow,
      blurRadius: 12,
      offset: const Offset(0, 6),
    ),
  ];

  // إنشاء الثيم الرئيسي للتطبيق
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: background,

      // ألوان الثيم
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: primaryLight,
        tertiary: primaryDark,
        surface: surface,
        error: error,
        onPrimary: textOnPrimary,
        onSecondary: textOnPrimary,
        onSurface: textPrimary,
        onError: Colors.white,
      ),

      // أنماط التطبيقات
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        foregroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: primaryColor,
          fontFamily: 'Tajawal',
        ),
        iconTheme: IconThemeData(color: primaryColor),
      ),

      // أنماط البطاقات
      cardTheme: CardTheme(
        color: cardBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        shadowColor: shadow,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // أنماط الحقول النصية
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: error, width: 2),
        ),
        labelStyle: const TextStyle(color: textSecondary),
        floatingLabelStyle: TextStyle(color: primaryColor),
        hintStyle: const TextStyle(color: textHint),
        errorStyle: const TextStyle(color: error, fontSize: 12),
        prefixIconColor: textSecondary,
        suffixIconColor: textSecondary,
        // focusedPrefixIconColor: primaryColor,
        // focusedSuffixIconColor: primaryColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),

      // أنماط الأزرار
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: textOnPrimary,
          elevation: 2,
          shadowColor: primaryShadow,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: buttonText,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: buttonText.copyWith(color: primaryColor),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          textStyle: buttonText.copyWith(color: primaryColor),
        ),
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: textOnPrimary,
        elevation: 4,
        highlightElevation: 8,
        shape: CircleBorder(),
      ),

      // أنماط الحوارات
      dialogTheme: DialogTheme(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titleTextStyle: headlineSmall,
        contentTextStyle: bodyMedium,
      ),

      // أنماط القوائم
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tileColor: surface,
        selectedTileColor: primaryVeryLight,
        iconColor: primaryColor,
        textColor: textPrimary,
        subtitleTextStyle: bodyMedium,
      ),

      // مؤشر التقدم
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryColor,
        circularTrackColor: primaryVeryLight,
      ),

      // مؤشر الـ Cursor
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: primaryColor,
        selectionColor: primaryColor.withOpacity(0.3),
        selectionHandleColor: primaryColor,
      ),

      // أشكال متنوعة
      dividerTheme: const DividerThemeData(
        color: divider,
        thickness: 1,
        space: 1,
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: textPrimary,
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      tabBarTheme: const TabBarTheme(
        labelColor: primaryColor,
        unselectedLabelColor: textHint,
        indicatorColor: primaryColor,
        dividerColor: Colors.transparent,
      ),

      // أنماط الإشعارات
      badgeTheme: const BadgeThemeData(
        backgroundColor: error,
        textColor: Colors.white,
      ),

      // أنماط الشفرة (للـ Material 3)
      chipTheme: ChipThemeData(
        backgroundColor: surfaceVariant,
        disabledColor: divider,
        selectedColor: primaryVeryLight,
        secondarySelectedColor: primaryColor,
        labelStyle: bodyMedium,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  // أنماط مخصصة للاستخدام المتكرر
  static BoxDecoration get gradientBackground => BoxDecoration(
    gradient: primaryGradient,
  );

  static BoxDecoration get cardDecoration => BoxDecoration(
    color: cardBackground,
    borderRadius: BorderRadius.circular(16),
    boxShadow: cardShadow,
  );

  static BoxDecoration get inputDecoration => BoxDecoration(
    color: surface,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: border),
  );
}