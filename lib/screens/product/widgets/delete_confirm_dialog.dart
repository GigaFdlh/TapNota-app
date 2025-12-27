import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../providers/product_provider.dart';
import '../utils/product_theme.dart';

class DeleteConfirmDialog extends StatelessWidget {
  final String productId;
  final String productName;

  const DeleteConfirmDialog({
    super.key,
    required this.productId,
    required this.productName,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ProductTheme.errorRed. withAlpha(26),
              borderRadius: BorderRadius.circular(10),
            ),
            child:  const Icon(
              Icons.warning_rounded,
              color: ProductTheme.errorRed,
              size: 22,
            ),
          ),
          const SizedBox(width:  12),
          Expanded(
            child: Text(
              'Hapus Produk? ',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: Text(
        "Yakin ingin menghapus '$productName'?",
        style: GoogleFonts.inter(
          fontSize: 13,
          color: ProductTheme.textSecondary. withAlpha(204),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Batal',
            style:  GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: ProductTheme.textSecondary,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Provider.of<ProductProvider>(context, listen:  false)
                .deleteProduct(productId);
            Navigator.pop(context);
            HapticFeedback.mediumImpact();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '✓ Produk berhasil dihapus',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
                backgroundColor: ProductTheme.errorRed,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                duration:  const Duration(seconds: 2),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: ProductTheme.errorRed,
            foregroundColor:  Colors.white,
            elevation: 0,
            shape:  RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Hapus',
            style:  GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}