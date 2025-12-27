import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/models.dart';
import '../../../providers/product_provider.dart';
import '../utils/product_theme.dart';
import '../utils/image_picker_helper.dart';

class ProductFormDialog extends StatefulWidget {
  final Product? productToEdit;

  const ProductFormDialog({super.key, this.productToEdit});

  @override
  State<ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<ProductFormDialog> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  String? _selectedImagePath;
  String _selectedUnit = 'Pcs';

  String? _nameError;
  String? _priceError;

  bool _hasAttemptedSubmit = false;

  static const int _minNameLength = 3;
  static const int _maxNameLength = 50;
  static const int _minPrice = 100;
  static const int _maxPrice = 100000000;

  final List<String> _unitOptions = [
    'Pcs',
    'Box',
    'Dus',
    'Kg',
    'Pack',
    'Lusin',
    'Liter',
    'Bungkus',
  ];

  bool get _isEditing => widget.productToEdit != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: _isEditing ? widget.productToEdit!.name : '',
    );

    if (_isEditing) {
      _priceController = TextEditingController(
        text: widget.productToEdit!.price.toString(),
      );
    } else {
      _priceController = TextEditingController();
    }

    _selectedImagePath = _isEditing ? widget.productToEdit!.imagePath : null;
    _selectedUnit = _isEditing ? widget.productToEdit!.unit : 'Pcs';

    _nameController.addListener(_validateName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  void _validateName() {
    if (!_hasAttemptedSubmit) return;

    setState(() {
      final name = _nameController.text.trim();

      if (name.isEmpty) {
        _nameError = 'Nama produk wajib diisi';
      } else if (name.length < _minNameLength) {
        _nameError = 'Minimal $_minNameLength karakter';
      } else if (name.length > _maxNameLength) {
        _nameError = 'Maksimal $_maxNameLength karakter';
      } else {
        _nameError = null;
      }
    });
  }

  bool _validateAll() {
    _hasAttemptedSubmit = true;

    final name = _nameController.text.trim();
    final priceText = _priceController.text.trim();

    bool isValid = true;

    if (name.isEmpty) {
      setState(() => _nameError = 'Nama produk wajib diisi');
      isValid = false;
    } else if (name.length < _minNameLength) {
      setState(() => _nameError = 'Minimal $_minNameLength karakter');
      isValid = false;
    } else if (name.length > _maxNameLength) {
      setState(() => _nameError = 'Maksimal $_maxNameLength karakter');
      isValid = false;
    } else {
      setState(() => _nameError = null);
    }

    if (priceText.isEmpty) {
      setState(() => _priceError = 'Harga wajib diisi');
      isValid = false;
    } else {
      final price = int.tryParse(priceText);

      if (price == null) {
        setState(() => _priceError = 'Harga harus berupa angka');
        isValid = false;
      } else if (price < _minPrice) {
        setState(() => _priceError = 'Minimal Rp ${_formatNumber(_minPrice)}');
        isValid = false;
      } else if (price > _maxPrice) {
        setState(() => _priceError = 'Maksimal Rp ${_formatNumber(_maxPrice)}');
        isValid = false;
      } else {
        setState(() => _priceError = null);
      }
    }

    return isValid;
  }

  Future<void> _pickImage(ImageSource source) async {
    final path = await ImagePickerHelper.pickImage(source);
    if (path != null) {
      setState(() => _selectedImagePath = path);
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (sheetContext) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: ProductTheme.borderColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                _ImageSourceOption(
                  icon: Icons.camera_alt_rounded,
                  title: 'Ambil Foto',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _pickImage(ImageSource.camera);
                  },
                ),
                _ImageSourceOption(
                  icon: Icons.photo_library_rounded,
                  title: 'Pilih dari Galeri',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
    );
  }

  void _handleSubmit() {
    if (!_validateAll()) {
      HapticFeedback.heavyImpact();
      return;
    }

    final name = _nameController.text.trim();
    final price = int.parse(_priceController.text.trim());

    if (_isEditing) {
      Provider.of<ProductProvider>(context, listen: false).editProduct(
        widget.productToEdit!.id,
        name,
        price,
        _selectedImagePath,
        _selectedUnit,
      );
    } else {
      Provider.of<ProductProvider>(
        context,
        listen: false,
      ).addProduct(name, price, _selectedImagePath, _selectedUnit);
    }

    Navigator.pop(context);
    HapticFeedback.mediumImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isEditing
              ? '✓ Produk berhasil diupdate'
              : '✓ Produk berhasil ditambahkan',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        backgroundColor: ProductTheme.successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      decoration: const BoxDecoration(
        color: ProductTheme.cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: ProductTheme.borderColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Text(
                _isEditing ? 'Edit Produk' : 'Tambah Produk',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: ProductTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 24),

              _ImagePicker(
                imagePath: _selectedImagePath,
                onTap: _showImageSourceSheet,
                onRemove: () => setState(() => _selectedImagePath = null),
              ),
              const SizedBox(height: 20),

              _FormField(
                label: 'Nama Produk',
                controller: _nameController,
                hintText: 'Contoh: Indomie Goreng',
                errorText: _nameError,
                maxLength: _maxNameLength,
                helperText:
                    '${_nameController.text.length}/$_maxNameLength karakter',
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _FormField(
                      label: 'Harga',
                      controller: _priceController,
                      hintText: '5000',
                      prefix: 'Rp ',
                      keyboardType: TextInputType.number,
                      errorText: _priceError,
                      helperText:
                          'Minim Rp ${_formatNumber(_minPrice)} Max Rp ${_formatNumber(_maxPrice)}',

                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(9),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _UnitDropdown(
                      label: 'Satuan',
                      value: _selectedUnit,
                      items: _unitOptions,
                      onChanged: (value) {
                        setState(() => _selectedUnit = value!);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(
                          color: ProductTheme.borderColor,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Batal',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: ProductTheme.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: ProductTheme.mainGradient,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: ProductTheme.tealFresh.withAlpha(76),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          _isEditing ? 'Simpan Perubahan' : 'Tambah Produk',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImagePicker extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _ImagePicker({
    required this.imagePath,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: ProductTheme.softGradient,
          border: Border.all(color: ProductTheme.borderColor, width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        child:
            imagePath != null
                ? ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(File(imagePath!), fit: BoxFit.cover),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(153),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: InkWell(
                            onTap: onRemove,
                            borderRadius: BorderRadius.circular(10),
                            child: const Padding(
                              padding: EdgeInsets.all(6),
                              child: Icon(
                                Icons.close_rounded,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ShaderMask(
                      shaderCallback:
                          (bounds) =>
                              ProductTheme.mainGradient.createShader(bounds),
                      child: const Icon(
                        Icons.add_photo_alternate_rounded,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Tambah Foto Produk',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: ProductTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '(Opsional)',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: ProductTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}

class _ImageSourceOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ImageSourceOption({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: ProductTheme.mainGradient,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
      title: Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
      onTap: onTap,
    );
  }
}

class _FormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hintText;
  final String? prefix;
  final TextInputType? keyboardType;
  final String? errorText;
  final String? helperText;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;

  const _FormField({
    required this.label,
    required this.controller,
    required this.hintText,
    this.prefix,
    this.keyboardType,
    this.errorText,
    this.helperText,
    this.maxLength,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: ProductTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLength: maxLength,
          inputFormatters: inputFormatters,
          style: GoogleFonts.inter(
            fontSize: 15,
            color: ProductTheme.textPrimary,
          ),
          decoration: ProductTheme.buildInputDecoration(
            hintText: hintText,
            prefix: prefix,
          ).copyWith(
            errorText: errorText,
            helperText: helperText,
            helperStyle: GoogleFonts.inter(
              fontSize: 11,
              color: ProductTheme.textSecondary,
            ),
            errorStyle: GoogleFonts.inter(
              fontSize: 11,
              color: ProductTheme.errorRed,
            ),
            counterText: '',
          ),
        ),
      ],
    );
  }
}

class _UnitDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _UnitDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: ProductTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          style: GoogleFonts.inter(
            fontSize: 15,
            color: ProductTheme.textPrimary,
          ),
          decoration: ProductTheme.buildInputDecoration(),
          items:
              items.map((String unit) {
                return DropdownMenuItem<String>(value: unit, child: Text(unit));
              }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
