import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/models.dart';
import '../../../providers/cart_provider.dart';
import '../../../utils.dart';
import '../utils/cashier_theme.dart';

class CartItemTile extends StatelessWidget {
  final CartItem item;
  final int index;
  final CartProvider cart;
  final Function(CartItem) onRemoveItem;

  const CartItemTile({
    super.key,
    required this.item,
    required this.index,
    required this. cart,
    required this.onRemoveItem,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 250 + (index * 40)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(20 * (1 - value), 0),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: CashierTheme.surfaceLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: CashierTheme.borderLight, width: 1.5),
        ),
        child: Row(
          children: [
            _ProductImage(imagePath: item.product.imagePath),
            const SizedBox(width: 14),
            Expanded(
              child: _ProductInfo(
                name: item.product.name,
                price: item.product.price,
                subtotal: item.subtotal,
              ),
            ),
            _QuantityControls(
              quantity: item. quantity,
              onDecrease: () {
                HapticFeedback.lightImpact();
                if (item.quantity == 1) {
                  onRemoveItem(item);
                } else {
                  cart.decreaseItem(item. product. id);
                }
              },
              onIncrease: () {
                HapticFeedback. lightImpact();
                cart.addToCart(item. product);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  final String?  imagePath;

  const _ProductImage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            CashierTheme.tealFresh.withAlpha(26),
            CashierTheme.deepIndigo.withAlpha(13),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: imagePath != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.file(
                File(imagePath!),
                fit: BoxFit. cover,
                cacheWidth:  120,
              ),
            )
          : Icon(
              Icons. inventory_2_rounded,
              color: CashierTheme. tealFresh.withAlpha(128),
              size: 26,
            ),
    );
  }
}

class _ProductInfo extends StatelessWidget {
  final String name;
  final int price;
  final int subtotal;

  const _ProductInfo({
    required this.name,
    required this.price,
    required this.subtotal,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color:  CashierTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          formatRupiah(price),
          style: GoogleFonts.inter(
            color: CashierTheme.textSecondary,
            fontSize: 13,
          ),
        ),
        const SizedBox(height:  2),
        Text(
          formatRupiah(subtotal),
          style: GoogleFonts. inter(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: CashierTheme.tealFresh,
          ),
        ),
      ],
    );
  }
}

class _QuantityControls extends StatelessWidget {
  final int quantity;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  const _QuantityControls({
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CashierTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: CashierTheme.borderLight, width: 1.5),
      ),
      child: Row(
        children: [
          _QuantityButton(
            icon: quantity == 1
                ? Icons.delete_outline_rounded
                : Icons.remove_rounded,
            color: quantity == 1
                ? CashierTheme. accentError
                : CashierTheme.textPrimary,
            onTap: onDecrease,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              "$quantity",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: CashierTheme.textPrimary,
              ),
            ),
          ),
          _QuantityButton(
            icon: Icons.add_rounded,
            color: CashierTheme.tealFresh,
            onTap: onIncrease,
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuantityButton({
    required this.icon,
    required this. color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, size: 18, color: color),
        ),
      ),
    );
  }
}