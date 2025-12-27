import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/settings_theme.dart';
import 'dialog_text_field.dart';

class SingleFieldDialog extends StatelessWidget {
  final String title;
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final Future<void> Function() onSave;
  final int maxLines;
  final TextInputType? keyboardType;

  const SingleFieldDialog({
    super.key,
    required this.title,
    required this.label,
    required this.icon,
    required this.controller,
    required this. onSave,
    this. maxLines = 1,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(
        title,
        style: GoogleFonts. poppins(fontWeight: FontWeight.bold),
      ),
      content: DialogTextField(
        controller: controller,
        label: label,
        icon: icon,
        maxLines: maxLines,
        keyboardType: keyboardType,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "Batal",
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
        ),
        ElevatedButton(
          onPressed:  () async {
            await onSave();
            if (context.mounted) Navigator.pop(context);
          },
          style:  ElevatedButton.styleFrom(
            backgroundColor: SettingsTheme.tealFresh,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            "Simpan",
            style: GoogleFonts.inter(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}