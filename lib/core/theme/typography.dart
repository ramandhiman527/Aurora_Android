import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  AppTypography._();

  // Primary Font: Clean Sans-Serif (Inter)
  // Secondary Font: Editorial Serif (Playfair Display) for Headers

  static TextStyle getDisplay({required Color color}) {
    return GoogleFonts.playfairDisplay(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: color,
      letterSpacing: -0.5,
    );
  }

  static TextStyle getHeading1({required Color color}) {
    return GoogleFonts.playfairDisplay(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: color,
      letterSpacing: -0.2,
    );
  }

  static TextStyle getHeading2({required Color color}) {
    return GoogleFonts.playfairDisplay(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }

  static TextStyle getHeading3({required Color color}) {
    return GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: color,
      letterSpacing: 0.1,
    );
  }

  static TextStyle getBodyLarge({required Color color}) {
    return GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: color,
      letterSpacing: 0.2,
    );
  }

  static TextStyle getBodyMedium({required Color color}) {
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: color,
      letterSpacing: 0.1,
    );
  }

  static TextStyle getBodySmall({required Color color}) {
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: color,
    );
  }

  static TextStyle getButtonText({required Color color}) {
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: color,
      letterSpacing: 1.2, // Uppercase / high spacing fashion vibe
    );
  }

  static TextStyle getCaption({required Color color}) {
    return GoogleFonts.inter(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: color,
      letterSpacing: 0.5,
    );
  }
}
