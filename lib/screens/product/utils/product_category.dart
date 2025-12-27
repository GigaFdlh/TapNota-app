import 'package:flutter/material.dart';

enum ProductCategory { all, food, drink, snack, other }

extension ProductCategoryExtension on ProductCategory {
  String get label {
    switch (this) {
      case ProductCategory.all:
        return 'Semua';
      case ProductCategory.food:
        return 'Makanan';
      case ProductCategory.drink:
        return 'Minuman';
      case ProductCategory. snack:
        return 'Snack';
      case ProductCategory.other:
        return 'Lainnya';
    }
  }

  IconData get icon {
    switch (this) {
      case ProductCategory.all:
        return Icons. grid_view_rounded;
      case ProductCategory.food:
        return Icons.restaurant_rounded;
      case ProductCategory.drink:
        return Icons. local_cafe_rounded;
      case ProductCategory.snack:
        return Icons.cookie_rounded;
      case ProductCategory.other:
        return Icons. inventory_2_rounded;
    }
  }
}