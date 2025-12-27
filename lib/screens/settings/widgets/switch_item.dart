import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/settings_theme.dart';

class SwitchItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isLast;

  const SwitchItem({
    super. key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical:  14),
          child: Row(
            children: [
              Icon(
                icon,
                size:  22,
                color: SettingsTheme.textSecondary.withAlpha(179),
              ),
              const SizedBox(width: 14),
              Expanded(
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: SettingsTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: SettingsTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: SettingsTheme. tealFresh,
                activeTrackColor: SettingsTheme.tealFresh. withAlpha(128),
              ),
            ],
          ),
        ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets. only(left: 52),
            child: Divider(
              height: 1,
              thickness: 1,
              color: SettingsTheme.divider,
            ),
          ),
      ],
    );
  }
}