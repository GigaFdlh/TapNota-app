import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/settings_theme.dart';

class SettingsFooter extends StatelessWidget {
  const SettingsFooter({super. key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: SettingsTheme.surfaceWhite,
            borderRadius: BorderRadius. circular(20),
            border:  Border.all(
              color: SettingsTheme.borderLight,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color:  Colors.black.withAlpha(8),
                blurRadius:  10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: SettingsTheme.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: SettingsTheme.tealFresh.withAlpha(77),
                      blurRadius:  16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.favorite_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(height:  12),
              Text(
                "TapNota v1.0.0",
                style: GoogleFonts.poppins(
                  fontSize:  16,
                  fontWeight: FontWeight.bold,
                  color: SettingsTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Made with ❤️ for UMKM Indonesia",
                textAlign: TextAlign.center,
                style: GoogleFonts. inter(
                  fontSize: 13,
                  color: SettingsTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "© 2025 TapNota. All rights reserved.",
          style: GoogleFonts.inter(
            fontSize: 12,
            color:  SettingsTheme.textMuted,
          ),
        ),
      ],
    );
  }
}