import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/cashier_theme.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:  [
                  CashierTheme.tealFresh.withAlpha(26),
                  CashierTheme.deepIndigo.withAlpha(13),
                ],
                begin:  Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 64,
              color: CashierTheme.textMuted.withAlpha(153),
            ),
          ),
          const SizedBox(height:  24),
          Text(
            "Produk tidak ditemukan",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: CashierTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Coba kata kunci lain",
            style: GoogleFonts.inter(
              fontSize: 14,
              color: CashierTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}