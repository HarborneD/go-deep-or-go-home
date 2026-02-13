import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color backgroundBlack = Color(0xFF121212);
  static const Color organicDarkGreen = Color(0xFF1A2118);
  static const Color organicBrown = Color(0xFF2D241E);
  static const Color organicFlesh = Color(0xFFA67B5B);
  static const Color accentGold = Color(0xFFC7A008);
  static const Color textParchment = Color(0xFFE0D8C8);
  static const Color riskRed = Color(0xFF8B3A3A);
  static const Color safeGreen = Color(0xFF4A7A4A);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundBlack,
      colorScheme: const ColorScheme.dark(
        primary: accentGold,
        secondary: organicFlesh,
        surface: organicDarkGreen,
        background: backgroundBlack,
        onBackground: textParchment,
        onSurface: textParchment,
        error: riskRed,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.cormorantGaramond(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: accentGold,
        ),
        headlineMedium: GoogleFonts.cormorantGaramond(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textParchment,
        ),
        bodyLarge: GoogleFonts.lato(fontSize: 16, color: textParchment),
        bodyMedium: GoogleFonts.lato(
          fontSize: 14,
          color: textParchment.withOpacity(0.8),
        ),
        labelLarge: GoogleFonts.cinzel(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: organicDarkGreen,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentGold,
          foregroundColor: organicDarkGreen,
          textStyle: GoogleFonts.cinzel(fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      cardTheme: const CardThemeData(
        color: organicBrown,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          side: BorderSide(color: Color(0xFF3E3229), width: 1),
        ),
      ),
    );
  }
}
