import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../models/models.dart';
import '../../../../providers/cart_provider.dart';
import '../../utils/cashier_theme.dart';

class ConfirmationDialogs {
  static void showClearCartConfirmation(
    BuildContext context,
    BuildContext sheetContext,
  ) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        icon: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: CashierTheme.accentError. withAlpha(26),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.warning_rounded,
            color: CashierTheme.accentError,
            size: 36,
          ),
        ),
        title: Text(
          "Hapus Semua? ",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Semua item di keranjang akan dihapus",
          textAlign: TextAlign.center,
          style: GoogleFonts. inter(
            fontSize: 14,
            color: CashierTheme.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(
              "Batal",
              style:  GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<CartProvider>(context, listen: false).clearCart();
              Navigator.pop(dialogCtx);
              Navigator.pop(sheetContext);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: CashierTheme.accentError,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "Hapus",
              style:  GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  static void showRemoveItemConfirmation(
    BuildContext context,
    CartItem item,
    CartProvider cart,
  ) {
    showDialog(
      context:  context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius:  BorderRadius.circular(24)),
        title: Text(
          "Hapus Item? ",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Hapus ${item.product.name} dari keranjang?",
          style: GoogleFonts.inter(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(
              "Batal",
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              cart.decreaseItem(item.product.id);
              Navigator.pop(dialogCtx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: CashierTheme.accentError,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius:  BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "Hapus",
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}