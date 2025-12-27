import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../providers/cart_provider.dart';
import '../../../utils.dart';
import '../utils/cashier_theme.dart';

class FloatingCartBar extends StatelessWidget {
  final Animation<double> bounceAnimation;
  final VoidCallback onTap;
  final VoidCallback onCheckout;

  const FloatingCartBar({
    super.key,
    required this.bounceAnimation,
    required this.onTap,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        if (cart.cartItems.isEmpty) return const SizedBox. shrink();

        return AnimatedBuilder(
          animation: bounceAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: bounceAnimation.value,
              child: child,
            );
          },
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 400),
            tween: Tween(begin: 0.0, end: 1.0),
            curve: Curves.easeOutCubic,
            builder:  (context, value, child) {
              return Transform.translate(
                offset: Offset(0, 80 * (1 - value)),
                child:  Opacity(opacity: value, child:  child),
              );
            },
            child: Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: CashierTheme.primaryGradient,
                borderRadius: BorderRadius.circular(28),
                boxShadow:  [
                  BoxShadow(
                    color: CashierTheme.deepIndigo.withAlpha(102),
                    blurRadius:  24,
                    offset: const Offset(0, 12),
                  ),
                  BoxShadow(
                    color: CashierTheme. tealFresh.withAlpha(51),
                    blurRadius:  16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white.withAlpha(51),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius. circular(28),
                    ),
                    child: SafeArea(
                      top: false,
                      child:  Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _CartSummary(
                            itemCount: cart.cartItems.length,
                            totalAmount: cart.totalAmount,
                            onTap: onTap,
                          ),
                          const SizedBox(height: 16),
                          _CheckoutButton(onPressed: onCheckout),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CartSummary extends StatelessWidget {
  final int itemCount;
  final int totalAmount;
  final VoidCallback onTap;

  const _CartSummary({
    required this.itemCount,
    required this.totalAmount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),
        decoration:  BoxDecoration(
          color:  Colors.white. withAlpha(38),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.white.withAlpha(51),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(51),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.shopping_bag_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width:  14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$itemCount Item",
                    style: GoogleFonts.inter(
                      color: Colors.white. withAlpha(217),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    formatRupiah(totalAmount),
                    style: GoogleFonts.poppins(
                      color:  Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(51),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.keyboard_arrow_up_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckoutButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _CheckoutButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child:  ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: CashierTheme.deepIndigo,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.payments_rounded, size: 22),
            const SizedBox(width: 10),
            Text(
              "Bayar Sekarang",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}