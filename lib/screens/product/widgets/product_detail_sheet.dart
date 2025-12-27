import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/models.dart';
import '../../../utils.dart';
import '../utils/product_theme.dart';

class ProductDetailSheet extends StatelessWidget {
  final Product product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProductDetailSheet({
    super.key,
    required this. product,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: ProductTheme.cardColor,
        borderRadius: BorderRadius. vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 36,
            height:  4,
            decoration: BoxDecoration(
              color: ProductTheme.borderColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ProductImage(product: product),
                  const SizedBox(height:  28),
                  _ProductInfo(product: product),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          _ActionButtons(onEdit: onEdit, onDelete:  onDelete),
        ],
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  final Product product;

  const _ProductImage({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        gradient: ProductTheme.softGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ProductTheme.borderColor,
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: product.imagePath != null
            ?  Image.file(
                File(product.imagePath!),
                fit: BoxFit.cover,
              )
            : Center(
                child: ShaderMask(
                  shaderCallback: (bounds) =>
                      ProductTheme.mainGradient.createShader(bounds),
                  child: Text(
                    product.name. isNotEmpty
                        ? product.name[0].toUpperCase()
                        : '?',
                    style: GoogleFonts.poppins(
                      fontSize:  80,
                      fontWeight: FontWeight.bold,
                      color: Colors. white,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class _ProductInfo extends StatelessWidget {
  final Product product;

  const _ProductInfo({required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment. start,
        children: [
          Text(
            product.name,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: ProductTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration:  BoxDecoration(
              gradient: ProductTheme.mainGradient,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: ProductTheme.tealFresh.withAlpha(51),
                  blurRadius:  10,
                ),
              ],
            ),
            child: Text(
              formatRupiah(product.price),
              style: GoogleFonts. poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
          _DetailItem(
            icon: Icons.scale_rounded,
            label: 'Satuan',
            value: product. unit,
          ),
          const SizedBox(height: 16),
          _DetailItem(
            icon: Icons.tag_rounded,
            label: 'ID Produk',
            value:  '#${product.id. substring(0, 8)}',
          ),
        ],
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ProductTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ProductTheme.borderColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          ShaderMask(
            shaderCallback: (bounds) =>
                ProductTheme.mainGradient.createShader(bounds),
            child: Icon(icon, size: 20, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: ProductTheme.textSecondary. withAlpha(179),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height:  2),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: ProductTheme.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ActionButtons({
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: ProductTheme.cardColor,
        boxShadow: [
          BoxShadow(
            color:  Colors.black.withAlpha(20),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton. icon(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_rounded, size: 18),
              label: Text(
                'Hapus',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: ProductTheme.errorRed,
                side: BorderSide(
                  color: ProductTheme.errorRed.withAlpha(102),
                  width: 1.5,
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
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
                    color: ProductTheme.tealFresh. withAlpha(76),
                    blurRadius:  10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_rounded, size: 18, color: Colors.white),
                label: Text(
                  'Edit Produk',
                  style:  GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight. w700,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}