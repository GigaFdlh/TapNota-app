import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../providers/cart_provider.dart';
import '../../../models/models.dart';
import '../utils/cashier_theme.dart';
import 'cart_item_tile.dart';

class CartDetailSheet extends StatelessWidget {
  final Function(BuildContext) onClearCart;
  final Function(BuildContext, CartItem) onRemoveItem;

  const CartDetailSheet({
    super.key,
    required this.onClearCart,
    required this.onRemoveItem,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.92,
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color:  CashierTheme.surfaceWhite,
            borderRadius:  BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: CashierTheme.borderLight,
                  borderRadius: BorderRadius. circular(10),
                ),
              ),
              const SizedBox(height:  24),
              _CartHeader(onClearCart: () => onClearCart(context)),
              const SizedBox(height: 16),
              Divider(color: CashierTheme.divider, height: 1),
              Expanded(
                child: Consumer<CartProvider>(
                  builder: (context, cart, child) {
                    return ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      itemCount: cart.cartItems.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (ctx, i) {
                        final item = cart.cartItems[i];
                        return CartItemTile(
                          item: item,
                          index: i,
                          cart: cart,
                          onRemoveItem: (item) => onRemoveItem(context, item),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CartHeader extends StatelessWidget {
  final VoidCallback onClearCart;

  const _CartHeader({required this.onClearCart});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:  [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Keranjang Belanja",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: CashierTheme.textPrimary,
                ),
              ),
              const SizedBox(height:  2),
              Text(
                "Detail pesanan Anda",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: CashierTheme.textSecondary,
                ),
              ),
            ],
          ),
          TextButton. icon(
            onPressed: () {
              HapticFeedback.mediumImpact();
              onClearCart();
            },
            icon: const Icon(Icons. delete_outline_rounded, size: 18),
            label: const Text("Hapus"),
            style: TextButton.styleFrom(
              foregroundColor: CashierTheme.accentError,
            ),
          ),
        ],
      ),
    );
  }
}