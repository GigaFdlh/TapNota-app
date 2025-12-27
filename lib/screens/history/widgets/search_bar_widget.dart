import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/history_theme.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius. circular(16),
          border: Border.all(color: HistoryTheme.borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          style: GoogleFonts.inter(fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Cari transaksi...',
            hintStyle: GoogleFonts.inter(
              color: HistoryTheme.textSecondary,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: HistoryTheme.textSecondary,
            ),
            suffixIcon: searchQuery.isNotEmpty
                ?  IconButton(
                    icon:  Icon(
                      Icons.clear_rounded,
                      color:  HistoryTheme.textSecondary,
                    ),
                    onPressed: onClear,
                  )
                : null,
            border: InputBorder.none,
            contentPadding: 
                const EdgeInsets.symmetric(horizontal: 16, vertical:  14),
          ),
        ),
      ),
    );
  }
}