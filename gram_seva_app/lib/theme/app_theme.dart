import 'package:flutter/material.dart';

/// GramSeva design system - deep teal + leaf green + saffron + warm
/// ivory, replacing the old pure black/white/grey palette. Tokens and
/// rationale come from the Manus UI/UX handoff
/// (GramSeva_design_system_reference.md).
class AppColors {
  static const deepTeal = Color(0xFF0E5A5A);
  static const teal700 = Color(0xFF0A4545);
  static const teal100 = Color(0xFFDDF2EF);
  static const leafGreen = Color(0xFF4C9A6A);
  static const green700 = Color(0xFF287A50);
  static const saffron = Color(0xFFE58A3A);
  static const saffron700 = Color(0xFFB96722);
  static const urgentCoral = Color(0xFFEF6B5B);
  static const warmIvory = Color(0xFFFFF9F0);
  static const sand = Color(0xFFF1E5D5);
  static const ink = Color(0xFF173B3B);
  static const slate = Color(0xFF5F7075);
  static const mist = Color(0xFFEEF3F2);
  static const error = Color(0xFFB42318);
  static const white = Color(0xFFFFFFFF);
  static const cardBorder = Color(0xFFD9E4E1);

  // Aliases so any screen still written against the old grayscale names
  // keeps compiling untouched while the rest of the app migrates to the
  // tokens above.
  static const black = ink;
  static const secondaryGrey = slate;
  static const mutedGrey = slate;
  static const borderGrey = cardBorder;
  static const surfaceGrey = mist;
}

class AppRadius {
  static const card = 20.0;
  static const control = 14.0;
  static const pill = 999.0;
}

class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const xxl = 24.0;
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.warmIvory,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.deepTeal,
        brightness: Brightness.light,
        primary: AppColors.deepTeal,
        onPrimary: AppColors.white,
        secondary: AppColors.saffron,
        onSecondary: AppColors.white,
        surface: AppColors.white,
        error: AppColors.error,
      ),
      // No custom fontFamily override: the platform's default font stack
      // already carries Noto Sans fallbacks for Devanagari/Telugu glyphs,
      // which is what keeps हिंदी and తెలుగు text rendering correctly.
      // Pinning a single custom family risks breaking that fallback chain.
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.warmIvory,
        foregroundColor: AppColors.ink,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(color: AppColors.ink, fontSize: 18, fontWeight: FontWeight.w700),
        iconTheme: IconThemeData(color: AppColors.ink),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w700, fontSize: 32),
        titleLarge: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w700, fontSize: 28),
        titleMedium: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w700, fontSize: 22),
        titleSmall: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w700, fontSize: 18),
        bodyLarge: TextStyle(color: AppColors.ink, fontSize: 16),
        bodyMedium: TextStyle(color: AppColors.slate, fontSize: 14),
        bodySmall: TextStyle(color: AppColors.slate, fontSize: 12),
        labelLarge: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w700, fontSize: 12),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.saffron,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.mist,
          disabledForegroundColor: AppColors.slate,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.control)),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          minimumSize: const Size.fromHeight(48),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.deepTeal,
          side: const BorderSide(color: AppColors.deepTeal, width: 1.2),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.control)),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          minimumSize: const Size.fromHeight(48),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.deepTeal,
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        hintStyle: const TextStyle(color: AppColors.slate, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.control),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.control),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.control),
          borderSide: const BorderSide(color: AppColors.deepTeal, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.control),
          borderSide: const BorderSide(color: AppColors.error, width: 1.2),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
          side: const BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.cardBorder, thickness: 1),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.deepTeal,
        unselectedItemColor: AppColors.slate,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
        unselectedLabelStyle: TextStyle(fontSize: 11),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.ink,
        contentTextStyle: const TextStyle(color: AppColors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.control)),
      ),
    );
  }
}
