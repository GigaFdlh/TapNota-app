import 'package:flutter/material.dart';
import '../../../models/models.dart';
import 'product_list_item.dart';

class ProductListView extends StatelessWidget {
  final List<Product> products;
  final Function(Product) onAddToCart;

  const ProductListView({
    super.key,
    required this.products,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return ListView. builder(
      key: const ValueKey('list'),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 160),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ProductListItem(
        product: products[i],
        index: i,
        onAddToCart: () => onAddToCart(products[i]),
      ),
    );
  }
}