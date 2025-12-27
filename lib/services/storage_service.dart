import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class StorageService {
  static const String _keyProducts = 'tapnota_products';
  static const String _keyTransactions = 'tapnota_transactions';

  // --- PRODUK ---
  Future<List<Product>> getProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_keyProducts);
    if (data == null) return [];
    // Convert teks JSON jadi List Product
    return (jsonDecode(data) as List).map((e) => Product.fromJson(e)).toList();
  }

  Future<void> saveProducts(List<Product> products) async {
    final prefs = await SharedPreferences.getInstance();
    // Convert List Product jadi teks JSON
    final String data = jsonEncode(products.map((e) => e.toJson()).toList());
    await prefs.setString(_keyProducts, data);
  }

  // --- TRANSAKSI ---
  Future<List<Transaction>> getTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_keyTransactions);
    if (data == null) return [];
    return (jsonDecode(data) as List).map((e) => Transaction.fromJson(e)).toList();
  }

  Future<void> saveTransaction(Transaction trx) async {
    final prefs = await SharedPreferences.getInstance();
    // Ambil data lama, tambah yang baru di paling atas, lalu simpan lagi
    List<Transaction> currentList = await getTransactions();
    currentList.insert(0, trx); 
    
    final String data = jsonEncode(currentList.map((e) => e.toJson()).toList());
    await prefs.setString(_keyTransactions, data);
  }
}