import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/settings_theme.dart';

class OptionDialog extends StatelessWidget {
  final String title;
  final List<(String, String)> options;
  final String currentValue;
  final Future<void> Function(String) onSelect;

  const OptionDialog({
    super.key,
    required this.title,
    required this.options,
    required this.currentValue,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape:  RoundedRectangleBorder(borderRadius: BorderRadius. circular(24)),
      title: Text(
        title,
        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: options.map((option) {
          return _OptionItem(
            text: option.$1,
            value: option.$2,
            isSelected: currentValue == option.$2,
            onTap: () async {
              await onSelect(option.$2);
              if (context.mounted) Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }
}

class _OptionItem extends StatelessWidget {
  final String text;
  final String value;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionItem({
    required this.text,
    required this.value,
    required this. isSelected,
    required this. onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? SettingsTheme. tealFresh. withAlpha(26)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? SettingsTheme. tealFresh
              : SettingsTheme.borderLight,
          width: 1.5,
        ),
      ),
      child: ListTile(
        title: Text(
          text,
          style: GoogleFonts.inter(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected
                ? SettingsTheme. tealFresh
                : SettingsTheme.textPrimary,
          ),
        ),
        trailing: isSelected
            ? const Icon(
                Icons.check_circle_rounded,
                color: SettingsTheme.tealFresh,
              )
            : null,
        onTap:  onTap,
      ),
    );
  }
}