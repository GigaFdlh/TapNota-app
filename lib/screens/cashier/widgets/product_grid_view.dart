import 'package:flutter/material.dart';
import '../../../models/models.dart';
import 'product_card.dart';

class ProductGridView extends StatelessWidget {
  final List<Product> products;
  final Function(Product) onAddToCart;

  const ProductGridView({
    super. key,
    required this.products,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      key: const ValueKey('grid'),
      padding: const EdgeInsets. fromLTRB(20, 24, 20, 160),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent:  280,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemCount: products. length,
      itemBuilder: (ctx, i) => ProductCard(
        product: products[i],
        index: i,
        onAddToCart: () => onAddToCart(products[i]),
      ),
    );
  }
}