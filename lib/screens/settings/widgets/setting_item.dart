import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/settings_theme.dart';

class SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color textColor;
  final bool isLast;

  const SettingItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.textColor = SettingsTheme.textPrimary,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              onTap();
            },
            borderRadius: BorderRadius.vertical(
              top: isLast ? Radius.zero : const Radius.circular(20),
              bottom: isLast ? const Radius.circular(20) : Radius.zero,
            ),
            child:  Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical:  14),
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 22,
                    color: SettingsTheme.textSecondary. withAlpha(179),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style:  GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style:  GoogleFonts.inter(
                            fontSize: 13,
                            color: SettingsTheme.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: SettingsTheme.textMuted,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (! isLast)
          Padding(
            padding: const EdgeInsets.only(left: 52),
            child:  Divider(
              height: 1,
              thickness: 1,
              color:  SettingsTheme.divider,
            ),
          ),
      ],
    );
  }
}