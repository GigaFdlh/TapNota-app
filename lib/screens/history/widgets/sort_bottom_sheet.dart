// lib/screens/history/widgets/sort_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/history_theme.dart';
import '../utils/filter_sort_helper.dart';

class SortBottomSheet extends StatelessWidget {
  final SortOption selectedSort;
  final ValueChanged<SortOption> onSortChanged;

  const SortBottomSheet({
    super.key,
    required this.selectedSort,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color:  Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: HistoryTheme.borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height:  20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:  [
              Text(
                'Urutkan',
                style: GoogleFonts.poppins(
                  fontSize:  20,
                  fontWeight: FontWeight.bold,
                  color: HistoryTheme.textPrimary,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SortOption(
            title: 'Terbaru',
            icon: Icons.arrow_downward_rounded,
            isSelected: selectedSort == SortOption.latest,
            onTap: () => onSortChanged(SortOption.latest),
          ),
          _SortOption(
            title: 'Terlama',
            icon: Icons.arrow_upward_rounded,
            isSelected: selectedSort == SortOption.oldest,
            onTap: () => onSortChanged(SortOption.oldest),
          ),
          _SortOption(
            title:  'Total Tertinggi',
            icon: Icons.trending_up_rounded,
            isSelected: selectedSort == SortOption.highestTotal,
            onTap: () => onSortChanged(SortOption.highestTotal),
          ),
          _SortOption(
            title:  'Total Terendah',
            icon: Icons.trending_down_rounded,
            isSelected: selectedSort == SortOption. lowestTotal,
            onTap: () => onSortChanged(SortOption.lowestTotal),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                gradient: HistoryTheme.primaryGradient,
                borderRadius: BorderRadius. circular(14),
                boxShadow: [
                  BoxShadow(
                    color: HistoryTheme.gradientTeal.withAlpha(77),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed:  () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child:  Text(
                  'Terapkan',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _SortOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _SortOption({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: isSelected ?  HistoryTheme.primaryGradient : null,
          color: isSelected ? null : Colors. transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ?  Colors.transparent : HistoryTheme.borderColor,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color:  isSelected ? Colors.white : HistoryTheme.textSecondary,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight:  isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ?  Colors.white : HistoryTheme.textPrimary,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: Colors.white,
              ),
          ],
        ),
      ),
    );
  }
}