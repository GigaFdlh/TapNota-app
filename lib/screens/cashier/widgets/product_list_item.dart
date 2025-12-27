import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../models/models.dart';
import '../../../providers/cart_provider.dart';
import '../../../utils.dart';
import '../utils/cashier_theme.dart';

class ProductListItem extends StatelessWidget {
  final Product product;
  final int index;
  final VoidCallback onAddToCart;

  const ProductListItem({
    super.key,
    required this.product,
    required this.index,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        int qtyInCart = 0;
        final cartIndex = cart.cartItems.indexWhere((i) => i.product.id == product.id);
        if (cartIndex >= 0) {
          qtyInCart = cart.cartItems[cartIndex].quantity;
        }

        final bool isInCart = qtyInCart > 0;

        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 300 + (index * 50)),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Opacity(opacity: value, child: child),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: CashierTheme.surfaceWhite,
              borderRadius: BorderRadius. circular(20),
              border:  Border.all(
                color: isInCart
                    ? CashierTheme.tealFresh.withAlpha(102)
                    : CashierTheme.borderLight,
                width: isInCart ? 2 : 1.5,
              ),
              boxShadow:  [
                BoxShadow(
                  color: Colors.black.withAlpha(8),
                  blurRadius:  10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                _ProductImage(product: product),
                const SizedBox(width: 14),
                Expanded(
                  child: _ProductInfo(product: product),
                ),
                isInCart
                    ? _QuantityBadge(qty: qtyInCart)
                    : _AddButton(onTap: () {
                        HapticFeedback.mediumImpact();
                        onAddToCart();
                      }),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProductImage extends StatelessWidget {
  final Product product;

  const _ProductImage({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:  [
            CashierTheme.tealFresh.withAlpha(26),
            CashierTheme.deepIndigo.withAlpha(13),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: product.imagePath != null
          ?  ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(
                File(product.imagePath!),
                fit: BoxFit.cover,
                cacheWidth: 128,
              ),
            )
          : Icon(
              Icons.inventory_2_rounded,
              color: CashierTheme.tealFresh.withAlpha(128),
              size: 28,
            ),
    );
  }
}

class _ProductInfo extends StatelessWidget {
  final Product product;

  const _ProductInfo({required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: CashierTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          formatRupiah(product.price),
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: CashierTheme. tealFresh,
          ),
        ),
        Text(
          "per ${product. unit}",
          style: GoogleFonts.inter(
            fontSize: 11,
            color: CashierTheme.textMuted,
          ),
        ),
      ],
    );
  }
}

class _QuantityBadge extends StatelessWidget {
  final int qty;

  const _QuantityBadge({required this.qty});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: CashierTheme.accentGradient,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color:  CashierTheme.accentSuccess.withAlpha(77),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.check_rounded, size: 16, color:  Colors.white),
          const SizedBox(width: 6),
          Text(
            "$qty",
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap:  onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: CashierTheme.primaryGradient,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color:  CashierTheme.tealFresh.withAlpha(102),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.add_rounded,
            color: Colors.white,
            size: 22,
          ),
        ),
      ),
    );
  }
}