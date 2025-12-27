import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/product_theme.dart';

class EmptyStateWidget extends StatelessWidget {
  final String searchQuery;

  const EmptyStateWidget({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: ProductTheme.mainGradient. scale(0.2),
              shape: BoxShape. circle,
            ),
            child: ShaderMask(
              shaderCallback: (bounds) =>
                  ProductTheme.mainGradient.createShader(bounds),
              child: const Icon(
                Icons.inventory_2_rounded,
                size: 60,
                color:  Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            searchQuery.isNotEmpty
                ?  'Produk tidak ditemukan'
                : 'Belum ada produk',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: ProductTheme.textPrimary,
            ),
          ),
          const SizedBox(height:  8),
          Text(
            searchQuery.isNotEmpty
                ?  'Coba kata kunci lain'
                :  'Tambahkan produk pertama Anda',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: ProductTheme.textSecondary.withAlpha(179),
            ),
          ),
        ],
      ),
    );
  }
}