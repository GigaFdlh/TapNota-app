// lib/screens/product/widgets/product_card.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/models.dart';
import '../../../utils.dart';
import '../utils/product_theme.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  const ProductCard({
    super.key,
    required this. product,
    required this.index,
    required this.onTap,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration:  Duration(milliseconds:  400 + (index * 60)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves. easeOutCubic,
      builder: (context, value, child) {
        return Transform. scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Hero(
        tag: 'product_${product.id}',
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              onTap();
            },
            borderRadius:  BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                color: ProductTheme.cardColor,
                borderRadius: BorderRadius. circular(20),
                border:  Border.all(
                  color: ProductTheme.borderColor,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color:  Colors.black.withAlpha(13),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child:  Column(
                crossAxisAlignment:  CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Stack(
                      children: [
                        _ProductImage(product: product),
                        _EditButton(onEdit: onEdit),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: _ProductInfo(product: product),
                  ),
                ],
              ),
            ),
          ),
        ),
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
      decoration: const BoxDecoration(
        gradient: ProductTheme.softGradient,
        borderRadius: BorderRadius. only(
          topLeft:  Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Center(
        child: product.imagePath != null
            ?  ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Image.file(
                  File(product.imagePath!),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (c, e, s) => _PlaceholderIcon(product: product),
                ),
              )
            : _PlaceholderIcon(product:  product),
      ),
    );
  }
}

class _PlaceholderIcon extends StatelessWidget {
  final Product product;

  const _PlaceholderIcon({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: ProductTheme.softGradient,
      ),
      child: Center(
        child: ShaderMask(
          shaderCallback:  (bounds) =>
              ProductTheme.mainGradient.createShader(bounds),
          child: Text(
            product.name. isNotEmpty ? product.name[0].toUpperCase() : '?',
            style: GoogleFonts.poppins(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _EditButton extends StatelessWidget {
  final VoidCallback onEdit;

  const _EditButton({required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 8,
      right: 8,
      child: Container(
        decoration:  BoxDecoration(
          color:  Colors.white.withAlpha(242),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(26),
              blurRadius: 8,
            ),
          ],
        ),
        child: InkWell(
          onTap: () {
            HapticFeedback.mediumImpact();
            onEdit();
          },
          borderRadius: BorderRadius.circular(10),
          child: const Padding(
            padding: EdgeInsets.all(8),
            child: Icon(
              Icons.edit_rounded,
              size: 16,
              color: ProductTheme.tealFresh,
            ),
          ),
        ),
      ),
    );
  }
}

// ✅ PERBAIKAN DI SINI - UNIT DI SAMPING HARGA
class _ProductInfo extends StatelessWidget {
  final Product product;

  const _ProductInfo({required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets. all(12),
      child: Column(
        crossAxisAlignment:  CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment. spaceBetween,
        children: [
          // ✅ Nama produk
          Flexible(
            child: Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: ProductTheme.textPrimary,
                height: 1.3,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // ✅ HARGA DAN UNIT DALAM 1 ROW
          Row(
            children: [
              // Harga (flex lebih besar)
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: ProductTheme.mainGradient,
                    borderRadius:  BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: ProductTheme.tealFresh.withAlpha(51),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    formatRupiah(product.price),
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              // ✅ Unit badge (flex lebih kecil)
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: ProductTheme.tealFresh. withAlpha(26),
                    borderRadius: BorderRadius.circular(10),
                    border: Border. all(
                      color: ProductTheme.tealFresh. withAlpha(77),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getUnitIcon(product.unit),
                        size: 12,
                        color: ProductTheme.tealFresh,
                      ),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(
                          product.unit,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: ProductTheme.tealFresh,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ✅ HELPER UNTUK ICON UNIT
  IconData _getUnitIcon(String unit) {
    final unitLower = unit. toLowerCase();

    if (unitLower.contains('pcs') || unitLower.contains('buah')) {
      return Icons.inventory_2_rounded;
    } else if (unitLower.contains('kg') || unitLower.contains('gram')) {
      return Icons.scale_rounded;
    } else if (unitLower.contains('liter') || unitLower.contains('ml')) {
      return Icons.local_drink_rounded;
    } else if (unitLower.contains('box') ||
        unitLower.contains('dus') ||
        unitLower.contains('pack') ||
        unitLower.contains('bungkus')) {
      return Icons.inventory_rounded;
    } else if (unitLower.contains('lusin') || unitLower.contains('dozen')) {
      return Icons.grid_view_rounded;
    }

    return Icons.label_rounded; // Default icon
  }
}