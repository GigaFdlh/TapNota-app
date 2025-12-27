import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/settings_theme.dart';

class DialogTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final int maxLines;
  final TextInputType?  keyboardType;

  const DialogTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.maxLines = 1,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      textCapitalization: TextCapitalization. words,
      style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: SettingsTheme.tealFresh),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: SettingsTheme.borderLight,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: SettingsTheme.borderLight,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius:  BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: SettingsTheme.tealFresh,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: SettingsTheme.surfaceLight,
      ),
    );
  }
}