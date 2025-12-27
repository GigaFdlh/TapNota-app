import 'package:flutter/material.dart';

class ProductTheme {
  // Signature Gradient Colors
  static const tealFresh = Color(0xFF43C197);
  static const deepIndigo = Color(0xFF1C1554);

  // UI Colors
  static const backgroundColor = Color(0xFFF5FBFA);
  static const cardColor = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF0D1B18);
  static const textSecondary = Color(0xFF5A6B68);
  static const borderColor = Color(0xFFDEEBE8);

  // Accent Colors
  static const successGreen = Color(0xFF10B981);
  static const warningOrange = Color(0xFFF59E0B);
  static const errorRed = Color(0xFFEF4444);

  // Main Gradient
  static const mainGradient = LinearGradient(
    colors: [tealFresh, deepIndigo],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Soft Gradient
  static const softGradient = LinearGradient(
    colors: [
      Color(0xFFF0FBF8),
      Color(0xFFF5FBFA),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Input Decoration Builder
  static InputDecoration buildInputDecoration({
    String? hintText,
    String? prefix,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
        fontSize: 14,
        color:  Color(0x805A6B68), // textSecondary 50%
      ),
      prefixText: prefix,
      prefixStyle: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      filled: true,
      fillColor: backgroundColor,
      border: OutlineInputBorder(
        borderRadius:  BorderRadius.circular(12),
        borderSide: const BorderSide(
          color:  borderColor,
          width: 1.2,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: borderColor,
          width: 1.2,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: tealFresh,
          width:  2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
    );
  }
}