import 'package:flutter/material.dart';

class DashboardTheme {
  // Primary Gradient Colors (Teal → Indigo)
  static const gradientTeal = Color(0xFF43C197);
  static const gradientIndigo = Color(0xFF1C1554);

  // Secondary Colors
  static const gradientTealLight = Color(0xFF5DD9AD);
  static const gradientIndigoLight = Color(0xFF2D2470);

  // UI Colors
  static const backgroundColor = Color(0xFFF5F7FA);
  static const cardColor = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF1C1554);
  static const textSecondary = Color(0xFF64748B);
  static const borderColor = Color(0xFFE2E8F0);

  // Accent Colors
  static const accentGreen = Color(0xFF10B981);
  static const accentOrange = Color(0xFFF59E0B);
  static const accentRed = Color(0xFFEF4444);

  // Primary Gradient
  static const primaryGradient = LinearGradient(
    colors: [gradientTeal, gradientIndigo],
    begin:  Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Soft Gradient
  static const softGradient = LinearGradient(
    colors: [gradientTealLight, gradientTeal],
    begin: Alignment. topLeft,
    end:  Alignment.bottomRight,
  );

  // Light Gradient for backgrounds
  static LinearGradient get lightGradient => LinearGradient(
        colors: [
          gradientTeal.withAlpha(26),
          gradientIndigo. withAlpha(13),
        ],
        begin:  Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  // Transaction Gradient
  static const transactionGradient = LinearGradient(
    colors: [Color(0xFF43C197), Color(0xFF2D9B7A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Product Gradient
  static const productGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF1C1554)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}