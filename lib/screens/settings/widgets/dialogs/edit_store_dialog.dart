import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../providers/settings_provider.dart';
import '../../utils/settings_theme.dart';
import 'dialog_text_field.dart';

class EditStoreDialog extends StatefulWidget {
  final Function(String) onSuccess;

  const EditStoreDialog({super.key, required this. onSuccess});

  @override
  State<EditStoreDialog> createState() => _EditStoreDialogState();
}

class _EditStoreDialogState extends State<EditStoreDialog> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    _nameController = TextEditingController(text: settings.storeName);
    _addressController = TextEditingController(text: settings.storeAddress);
    _phoneController = TextEditingController(text: settings.storePhone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (_nameController.text.isNotEmpty &&
        _addressController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty) {
      final settings = Provider.of<SettingsProvider>(context, listen: false);
      await settings.updateStoreName(_nameController.text);
      await settings.updateStoreAddress(_addressController.text);
      await settings.updateStorePhone(_phoneController.text);

      if (mounted) {
        Navigator.pop(context);
        widget.onSuccess("Profil toko berhasil diperbarui!");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(
        "Edit Profil Toko",
        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DialogTextField(
              controller: _nameController,
              label: "Nama Toko",
              icon: Icons.store_rounded,
            ),
            const SizedBox(height: 16),
            DialogTextField(
              controller: _addressController,
              label: "Alamat Toko",
              icon: Icons. location_on_rounded,
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            DialogTextField(
              controller: _phoneController,
              label: "Nomor Telepon",
              icon: Icons.phone_rounded,
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
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
          onPressed: _handleSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: SettingsTheme.tealFresh,
            foregroundColor: Colors. white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius. circular(12),
            ),
          ),
          child: Text(
            "Simpan",
            style:  GoogleFonts.inter(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}