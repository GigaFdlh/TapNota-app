import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/product_theme.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final String searchQuery;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.searchQuery,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        color: ProductTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ProductTheme.borderColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: GoogleFonts.inter(
          fontSize: 15,
          color: ProductTheme.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: 'Cari produk...',
          hintStyle: GoogleFonts.inter(
            fontSize: 15,
            color:  ProductTheme.textSecondary.withAlpha(153),
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: ProductTheme.textSecondary.withAlpha(128),
            size: 22,
          ),
          suffixIcon: searchQuery.isNotEmpty
              ?  IconButton(
                  icon:  Icon(
                    Icons.close_rounded,
                    color: ProductTheme.textSecondary. withAlpha(128),
                  ),
                  onPressed:  () {
                    HapticFeedback.lightImpact();
                    onClear();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding:  const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}