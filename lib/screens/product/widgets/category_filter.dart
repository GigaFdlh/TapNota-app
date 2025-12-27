import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/product_theme.dart';
import '../utils/product_category.dart';
class CategoryFilter extends StatelessWidget {
  final ProductCategory selectedCategory;
  final ValueChanged<ProductCategory> onCategoryChanged;

  const CategoryFilter({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ListView(
        scrollDirection: Axis. horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        children: ProductCategory.values.map((category) {
          final isSelected = selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: _CategoryChip(
              category:  category,
              isSelected: isSelected,
              onTap: () {
                HapticFeedback.lightImpact();
                onCategoryChanged(category);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final ProductCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        gradient: isSelected ?  ProductTheme.mainGradient : null,
        color: isSelected ? null : ProductTheme.cardColor,
        borderRadius: BorderRadius. circular(14),
        border: isSelected
            ? null
            : Border.all(
                color: ProductTheme.borderColor,
                width: 1.2,
              ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: ProductTheme.tealFresh.withAlpha(71),
                  blurRadius:  12,
                  offset: const Offset(0, 4),
                ),
              ]
            :  [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius:  8,
                  offset:  const Offset(0, 2),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical:  10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  category.icon,
                  size: 18,
                  color: isSelected
                      ? Colors.white
                      : ProductTheme.textSecondary.withAlpha(179),
                ),
                const SizedBox(width: 8),
                Text(
                  category.label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? Colors.white
                        : ProductTheme.textSecondary.withAlpha(179),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}