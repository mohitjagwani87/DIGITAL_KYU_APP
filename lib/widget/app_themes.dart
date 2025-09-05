import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// This file contains theme-related constants and styles used throughout the app.
/// Centralizing these styles makes it easier to maintain a consistent look and feel.

class AppColors {
  // Primary colors
  static final Color primary = Colors.blue.shade800;
  static final Color secondary = Colors.green.shade700;
  static final Color accent = Colors.purple.shade700;

  // Background colors
  static final Color lightBackground = Colors.grey.shade50;
  static final Color cardBackground = Colors.white;

  // Text colors
  static final Color textPrimary = Colors.black87;
  static final Color textSecondary = Colors.grey.shade700;
  static final Color textLight = Colors.grey.shade500;

  // Service card colors
  static final Color gstServiceBg = Colors.blue.shade50;
  static final Color itrServiceBg = Colors.amber.shade50;
  static final Color companyServiceBg = Colors.purple.shade50;
  static final Color ipServiceBg = Colors.indigo.shade50;
  static final Color certificationServiceBg = Colors.teal.shade50;
  static final Color legalServiceBg = Colors.brown.shade50;

  // Status colors
  static final Color success = Colors.green.shade600;
  static final Color error = Colors.red.shade600;
  static final Color warning = Colors.orange.shade600;
  static final Color info = Colors.blue.shade600;
}

class AppTextStyles {
  // Headings
  static final TextStyle heading1 = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static final TextStyle heading2 = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static final TextStyle heading3 = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static final TextStyle heading4 = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  // Body text
  static final TextStyle bodyLarge = GoogleFonts.poppins(
    fontSize: 16,
    color: AppColors.textPrimary,
  );

  static final TextStyle bodyMedium = GoogleFonts.poppins(
    fontSize: 14,
    color: AppColors.textPrimary,
  );

  static final TextStyle bodySmall = GoogleFonts.poppins(
    fontSize: 12,
    color: AppColors.textSecondary,
  );

  // Button text
  static final TextStyle buttonText = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // Card text
  static final TextStyle cardTitle = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle cardSubtitle = GoogleFonts.poppins(
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  static final TextStyle cardAction = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
  );
}

class AppDecorations {
  // Card decorations
  static BoxDecoration cardDecoration = BoxDecoration(
    color: AppColors.cardBackground,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.1),
        spreadRadius: 1,
        blurRadius: 6,
        offset: const Offset(0, 3),
      ),
    ],
  );

  // Feature card decorations
  static BoxDecoration featureCardDecoration(Color bgColor) => BoxDecoration(
    color: bgColor,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.1),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );

  // Button decorations
  static BoxDecoration primaryButtonDecoration = BoxDecoration(
    color: AppColors.primary,
    borderRadius: BorderRadius.circular(8),
  );

  // Icon container decorations
  static BoxDecoration iconContainerDecoration(Color bgColor) =>
      BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12));
}

/// This theme can be used as the main theme for the app
ThemeData appTheme() {
  return ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.lightBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: AppColors.primary,
      elevation: 0,
      titleTextStyle: AppTextStyles.heading3,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.primary),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.primary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.error),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return null;
      }),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return null;
      }),
    ),
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
    ),
  );
}
