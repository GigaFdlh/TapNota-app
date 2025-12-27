import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/storage_service.dart';

class ProductProvider with ChangeNotifier {
  final StorageService _storage = StorageService();
  List<Product> _products = [];

  List<Product> get products => _products;

  // Load data saat aplikasi dibuka
  Future<void> loadProducts() async {
    _products = await _storage.getProducts();
    notifyListeners();
  }

  // Tambah Produk
Future<void> addProduct(String name, int price, String? imagePath, String unit) async {
    final newProduct = Product(
      name: name, 
      price: price, 
      imagePath: imagePath, 
      unit: unit // <--- Masukkan unit
    );
    _products.add(newProduct);
    await _storage.saveProducts(_products);
    notifyListeners();
  }

  // Update editProduct
  Future<void> editProduct(String id, String newName, int newPrice, String? newImagePath, String newUnit) async {
    final index = _products.indexWhere((prod) => prod.id == id);
    if (index >= 0) {
      _products[index] = Product(
        id: id,
        name: newName,
        price: newPrice,
        imagePath: newImagePath,
        unit: newUnit, // <--- Update unit
      );
      await _storage.saveProducts(_products);
      notifyListeners();
    }
  }

  // Hapus Produk
  Future<void> deleteProduct(String id) async {
    _products.removeWhere((p) => p.id == id);
    await _storage.saveProducts(_products);
    notifyListeners();
  }
}