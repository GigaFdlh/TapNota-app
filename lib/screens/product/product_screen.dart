import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../providers/product_provider.dart';
import '../../models/models.dart';
import 'utils/product_theme.dart';
import 'utils/product_category.dart';
import 'widgets/premium_app_bar.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/category_filter.dart';
import 'widgets/product_card.dart';
import 'widgets/empty_state_widget.dart';
import 'widgets/product_form_dialog.dart';
import 'widgets/product_detail_sheet.dart';
import 'widgets/delete_confirm_dialog.dart';

// ============================================
// PRODUCT SCREEN
// ============================================
class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  ProductCategory _selectedCategory = ProductCategory.all;
  String _searchQuery = '';

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  List<Product> _getFilteredProducts(List<Product> products) {
    return products.where((product) {
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!product.name.toLowerCase().contains(query)) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  void _showFormDialog({Product? productToEdit}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ProductFormDialog(productToEdit: productToEdit),
    );
  }

  void _showProductDetail(Product product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (ctx) => ProductDetailSheet(
            product: product,
            onEdit: () {
              Navigator.pop(ctx);
              _showFormDialog(productToEdit: product);
            },
            onDelete: () {
              Navigator.pop(ctx);
              _showDeleteConfirm(product.id, product.name);
            },
          ),
    );
  }

  void _showDeleteConfirm(String productId, String productName) {
    showDialog(
      context: context,
      builder:
          (ctx) => DeleteConfirmDialog(
            productId: productId,
            productName: productName,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProductTheme.backgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const PremiumAppBar(),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: SearchBarWidget(
                  controller: _searchController,
                  searchQuery: _searchQuery,
                  onChanged: (value) {
                    setState(() => _searchQuery = value);
                  },
                  onClear: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: CategoryFilter(
                  selectedCategory: _selectedCategory,
                  onCategoryChanged: (category) {
                    setState(() => _selectedCategory = category);
                  },
                ),
              ),
            ),
          ),
          Consumer<ProductProvider>(
            builder: (context, provider, child) {
              final filteredProducts = _getFilteredProducts(provider.products);

              if (filteredProducts.isEmpty) {
                return SliverFillRemaining(
                  child: EmptyStateWidget(searchQuery: _searchQuery),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 280,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final product = filteredProducts[index];
                    return ProductCard(
                      product: product,
                      index: index,
                      onTap: () => _showProductDetail(product),
                      onEdit: () => _showFormDialog(productToEdit: product),
                    );
                  }, childCount: filteredProducts.length),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom > 0 ? 100 : 120,
        ),
        child: _PremiumFAB(onPressed: () => _showFormDialog()),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class _PremiumFAB extends StatelessWidget {
  final VoidCallback onPressed;

  const _PremiumFAB({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final isMediumScreen = screenWidth >= 360 && screenWidth < 400;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ProductTheme.tealFresh.withAlpha(102),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: () {
          HapticFeedback.mediumImpact();
          onPressed();
        },
        backgroundColor: ProductTheme.tealFresh,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: Icon(
          Icons.add_rounded,
          color: Colors.white,
          size: isSmallScreen ? 20 : 24,
        ),
        label: Text(
          isSmallScreen ? 'Tambah' : 'Tambah Produk',
          style: GoogleFonts.inter(
            fontSize: isSmallScreen ? 12 : (isMediumScreen ? 13 : 14),
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}
