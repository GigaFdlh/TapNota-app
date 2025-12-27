import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../models/models.dart';
import '../../../providers/cart_provider.dart';
import '../../../utils.dart';
import '../utils/cashier_theme.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final int index;
  final VoidCallback onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    required this.index,
    required this. onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder:  (context, cart, child) {
        int qtyInCart = 0;
        final cartIndex = cart.cartItems.indexWhere((i) => i.product.id == product.id);
        if (cartIndex >= 0) {
          qtyInCart = cart.cartItems[cartIndex].quantity;
        }

        final bool isInCart = qtyInCart > 0;

        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 400 + (index * 60)),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.easeOutCubic,
          builder:  (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 30 * (1 - value)),
              child: Opacity(opacity: value, child: child),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: CashierTheme.surfaceWhite,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isInCart
                    ? CashierTheme.tealFresh. withAlpha(102)
                    : CashierTheme.borderLight,
                width: isInCart ? 2 : 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: isInCart
                      ? CashierTheme.tealFresh.withAlpha(38)
                      : Colors.black.withAlpha(10),
                  blurRadius:  isInCart ? 20 : 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: _ProductImage(
                    product: product,
                    isInCart: isInCart,
                    qtyInCart: qtyInCart,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: _ProductInfo(
                    product: product,
                    isInCart:  isInCart,
                    onAddToCart: () {
                      HapticFeedback.mediumImpact();
                      onAddToCart();
                    },
                  ),
                ),
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
  final bool isInCart;
  final int qtyInCart;

  const _ProductImage({
    required this.product,
    required this.isInCart,
    required this.qtyInCart,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double. infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                CashierTheme.tealFresh.withAlpha(20),
                CashierTheme.deepIndigo.withAlpha(13),
              ],
              begin:  Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius:  const BorderRadius.vertical(
              top: Radius.circular(22),
            ),
          ),
          child: Center(
            child: product.imagePath != null
                ? ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius. circular(22),
                    ),
                    child: Image.file(
                      File(product. imagePath!),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      cacheWidth: 300,
                      errorBuilder: (c, e, s) => const _ProductIcon(),
                    ),
                  )
                : const _ProductIcon(),
          ),
        ),
        if (isInCart)
          Positioned(
            top: 10,
            right: 10,
            child: _QuantityBadge(qty: qtyInCart),
          ),
      ],
    );
  }
}

class _ProductIcon extends StatelessWidget {
  const _ProductIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CashierTheme.tealFresh. withAlpha(26),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.inventory_2_rounded,
        size: 36,
        color: CashierTheme.tealFresh. withAlpha(128),
      ),
    );
  }
}

class _QuantityBadge extends StatelessWidget {
  final int qty;

  const _QuantityBadge({required this.qty});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 250),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          gradient: CashierTheme.accentGradient,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: CashierTheme.accentSuccess.withAlpha(102),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.shopping_bag_rounded, size: 13, color: Colors.white),
            const SizedBox(width: 4),
            Text(
              "$qty",
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ✅ PERBAIKAN DI SINI - PRODUCT INFO
class _ProductInfo extends StatelessWidget {
  final Product product;
  final bool isInCart;
  final VoidCallback onAddToCart;

  const _ProductInfo({
    required this.product,
    required this.isInCart,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10), // ✅ Dikurangi dari 14 ke 10
      child: Column(
        crossAxisAlignment: CrossAxisAlignment. start,
        mainAxisAlignment:  MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min, // ✅ Tambahkan ini
        children: [
          // ✅ Text info product
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                product.name,
                maxLines: 1,
                overflow: TextOverflow. ellipsis,
                style:  GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 13, // ✅ Dikurangi dari 14 ke 13
                  color: CashierTheme.textPrimary,
                  letterSpacing: -0.3,
                  height: 1.2, // ✅ Tambahkan line height
                ),
              ),
              const SizedBox(height:  2), // ✅ Dikurangi dari 4 ke 2
              Text(
                formatRupiah(product.price),
                style: GoogleFonts.inter(
                  fontSize: 14, // ✅ Dikurangi dari 15 ke 14
                  fontWeight: FontWeight.bold,
                  color: CashierTheme.tealFresh,
                  height: 1.2, // ✅ Tambahkan line height
                ),
              ),
              Text(
                "per ${product.unit}",
                style: GoogleFonts.inter(
                  fontSize: 10, // ✅ Dikurangi dari 11 ke 10
                  color: CashierTheme.textMuted,
                  height: 1.2, // ✅ Tambahkan line height
                ),
              ),
            ],
          ),
          const SizedBox(height: 6), // ✅ Spacing tetap
          _AddButton(
            isInCart: isInCart,
            onTap: onAddToCart,
          ),
        ],
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final bool isInCart;
  final VoidCallback onTap;

  const _AddButton({
    required this. isInCart,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 34, // ✅ Dikurangi dari 38 ke 34
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius:  BorderRadius.circular(12),
          child: Ink(
            decoration: BoxDecoration(
              gradient: isInCart ?  CashierTheme.buttonGradient : null,
              color: isInCart ? null : CashierTheme.surfaceLight,
              borderRadius: BorderRadius.circular(12),
              border: isInCart
                  ?  null
                  : Border. all(
                      color: CashierTheme.tealFresh.withAlpha(128),
                      width: 1.5,
                    ),
            ),
            child: Center(
              child: Icon(
                isInCart ? Icons.add_rounded : Icons.add_shopping_cart_rounded,
                size: 18, // ✅ Dikurangi dari 20 ke 18
                color: isInCart ? Colors.white : CashierTheme.tealFresh,
              ),
            ),
          ),
        ),
      ),
    );
  }
}