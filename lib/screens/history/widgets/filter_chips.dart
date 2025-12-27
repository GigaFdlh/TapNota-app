import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/history_theme.dart';
import '../utils/filter_sort_helper.dart';

class FilterChips extends StatelessWidget {
  final DateFilter selectedFilter;
  final ValueChanged<DateFilter> onFilterChanged;

  const FilterChips({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _FilterChip(
            label: 'Semua',
            isSelected: selectedFilter == DateFilter.all,
            onTap: () => onFilterChanged(DateFilter.all),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Hari Ini',
            isSelected: selectedFilter == DateFilter.today,
            onTap: () => onFilterChanged(DateFilter.today),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Minggu Ini',
            isSelected: selectedFilter == DateFilter.thisWeek,
            onTap: () => onFilterChanged(DateFilter. thisWeek),
          ),
          const SizedBox(width:  8),
          _FilterChip(
            label: 'Bulan Ini',
            isSelected: selectedFilter == DateFilter.thisMonth,
            onTap: () => onFilterChanged(DateFilter.thisMonth),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
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
      child:  AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected ?  HistoryTheme.primaryGradient : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.transparent : HistoryTheme.borderColor,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color:  HistoryTheme.gradientTeal.withAlpha(77),
                    blurRadius:  8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ?  Colors.white : HistoryTheme.textSecondary,
          ),
        ),
      ),
    );
  }
}