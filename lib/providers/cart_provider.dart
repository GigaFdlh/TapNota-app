import 'package:flutter/material.dart';
import '../models/models.dart';
import 'transaction_provider.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  int get totalAmount {
    return _cartItems.fold(0, (sum, item) => sum + item.subtotal);
  }

  void addToCart(Product product) {
    int index = _cartItems.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _cartItems[index].quantity++;
    } else {
      _cartItems.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void setQuantity(String productId, int quantity) {
    int index = _cartItems.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (quantity <= 0) {
        _cartItems.removeAt(index);
      } else {
        _cartItems[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  void decreaseItem(String productId) {
    int index = _cartItems.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity--;
      } else {
        _cartItems.removeAt(index);
      }
      notifyListeners();
    }
  }
  
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  // --- UPDATE: Tambahkan parameter uang bayar & kembalian ---
  Future<bool> checkout(
    TransactionProvider trxProvider, {
    String customerName = "Umum",
    required int payAmount,    // Uang Diterima
    required int changeAmount, // Kembalian
  }) async {
    if (_cartItems.isEmpty) return false;

    final newTrx = Transaction(
      date: DateTime.now(),
      items: List.from(_cartItems),
      totalAmount: totalAmount,
      customerName: customerName,
      paymentAmount: payAmount, // Simpan
      changeAmount: changeAmount, // Simpan
    );

    trxProvider.addTransaction(newTrx);
    clearCart(); 
    return true;
  }
}