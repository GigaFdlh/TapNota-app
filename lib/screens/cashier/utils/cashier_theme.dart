import 'package:flutter/material.dart';

class CashierTheme {
  // Signature Gradient Colors
  static const Color tealFresh = Color(0xFF43C197);
  static const Color deepIndigo = Color(0xFF1C1554);

  // Surface Colors
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF8FAFC);
  static const Color surfaceGray = Color(0xFFF9FAFB);

  // Text Colors
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textMuted = Color(0xFF9CA3AF);

  // Accent Colors
  static const Color accentSuccess = Color(0xFF10B981);
  static const Color accentError = Color(0xFFEF4444);
  static const Color accentWarning = Color(0xFFF59E0B);

  // Border & Divider
  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFE5E7EB);

  // Signature Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [tealFresh, deepIndigo],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient softGradient = LinearGradient(
    colors: [Color(0xFF43C197), Color(0xFF2D7A9C), Color(0xFF1C1554)],
    begin: Alignment.topCenter,
    end: Alignment. bottomCenter,
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    colors: [tealFresh, Color(0xFF38A583)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accentSuccess, Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}