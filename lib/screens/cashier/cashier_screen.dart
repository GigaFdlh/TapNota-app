import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/cart_provider.dart';
import '../../models/models.dart';
import 'utils/cashier_theme.dart';
import 'widgets/dialogs/payment_confirmation.dart';
import 'widgets/premium_app_bar.dart';
import 'widgets/glass_search_bar.dart';
import 'widgets/product_grid_view.dart';
import 'widgets/product_list_view.dart';
import 'widgets/empty_state.dart';
import 'widgets/floating_cart_bar.dart';
import 'widgets/cart_detail_sheet.dart';
import 'widgets/dialogs/confirmation_dialogs.dart';

class CashierScreen extends StatefulWidget {
  const CashierScreen({super.key});

  @override
  State<CashierScreen> createState() => _CashierScreenState();
}

class _CashierScreenState extends State<CashierScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  bool _isGridView = true;

  late AnimationController _fadeController;
  late AnimationController _cartBounceController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _cartBounceAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    );

    _cartBounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _cartBounceAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _cartBounceController, curve: Curves.easeOutBack),
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fadeController.dispose();
    _cartBounceController.dispose();
    super.dispose();
  }

  void _triggerCartBounce() {
    _cartBounceController.forward().then((_) {
      _cartBounceController.reverse();
    });
  }

  void _showCartDetailSheet() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (ctx) => CartDetailSheet(
            onClearCart: (sheetCtx) {
              ConfirmationDialogs.showClearCartConfirmation(context, sheetCtx);
            },
            onRemoveItem: (context, item) {
              final cart = Provider.of<CartProvider>(context, listen: false);
              ConfirmationDialogs.showRemoveItemConfirmation(
                context,
                item,
                cart,
              );
            },
          ),
    );
  }

  void _showPaymentDialog() {
    HapticFeedback.mediumImpact();
    final cart = Provider.of<CartProvider>(context, listen: false);

    showDialog(
      context: context,
      builder:
          (ctx) => PaymentDialog(cart: cart, onSuccess: _showSuccessSnackbar),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(51),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Pembayaran telah diproses",
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.white.withAlpha(204),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: CashierTheme.accentSuccess,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: CashierTheme.softGradient),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                PremiumAppBar(
                  isGridView: _isGridView,
                  onViewToggle: () {
                    HapticFeedback.lightImpact();
                    setState(() => _isGridView = !_isGridView);
                  },
                ),
                GlassSearchBar(
                  controller: _searchController,
                  searchQuery: _searchQuery,
                  onChanged:
                      (val) => setState(() => _searchQuery = val.toLowerCase()),
                  onClear: () {
                    _searchController.clear();
                    setState(() => _searchQuery = "");
                  },
                ),
                Expanded(child: _buildProductSection()),
                FloatingCartBar(
                  bounceAnimation: _cartBounceAnimation,
                  onTap: _showCartDetailSheet,
                  onCheckout: _showPaymentDialog,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductSection() {
    return Container(
      decoration: const BoxDecoration(
        color: CashierTheme.surfaceLight,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        child: Consumer<ProductProvider>(
          builder: (context, prodProvider, child) {
            final filteredProducts =
                prodProvider.products.where((p) {
                  return p.name.toLowerCase().contains(_searchQuery);
                }).toList();

            if (filteredProducts.isEmpty) {
              return const EmptyState();
            }

            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.02, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child:
                  _isGridView
                      ? ProductGridView(
                        products: filteredProducts,
                        onAddToCart: _handleAddToCart,
                      )
                      : ProductListView(
                        products: filteredProducts,
                        onAddToCart: _handleAddToCart,
                      ),
            );
          },
        ),
      ),
    );
  }

  void _handleAddToCart(Product product) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    cart.addToCart(product);
    _triggerCartBounce();
  }
}
