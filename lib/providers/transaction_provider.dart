import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/storage_service.dart';

class TransactionProvider with ChangeNotifier {
  final StorageService _storage = StorageService();
  List<Transaction> _transactions = [];

  List<Transaction> get transactions => _transactions;

  // --- 1. LOAD DATA DARI HP ---
  Future<void> loadTransactions() async {
    _transactions = await _storage.getTransactions();
    notifyListeners();
  }

  // --- 2. LOGIKA TAMBAHAN (ADD TRANSAKSI) ---
  // Panggil ini saat selesai bayar di CartProvider agar dashboard langsung update
  void addTransaction(Transaction trx) {
    _transactions.insert(0, trx); // Masukkan ke paling atas
    _storage.saveTransaction(trx); // Simpan ke local
    notifyListeners(); // Update UI Dashboard
  }

  // --- 3. HITUNG OMZET HARI INI ---
  double get totalOmzetHariIni {
    final now = DateTime.now();
    double total = 0;

    for (var trx in _transactions) {
      // Cek apakah tanggal & bulan & tahun sama dengan hari ini
      if (trx.date.day == now.day && 
          trx.date.month == now.month && 
          trx.date.year == now.year) {
        total += trx.totalAmount;
      }
    }
    return total;
  }

  // --- 4. HITUNG JUMLAH TRANSAKSI HARI INI ---
  int get totalTransaksiHariIni {
    final now = DateTime.now();
    return _transactions.where((trx) => 
      trx.date.day == now.day && 
      trx.date.month == now.month && 
      trx.date.year == now.year
    ).length;
  }

  // --- 5. PRODUK TERLARIS (TOP PRODUCTS) ---
  List<Map<String, dynamic>> get topProducts {
    Map<String, int> productCount = {};
    Map<String, int> productIncome = {};

    // Loop semua transaksi
    for (var trx in _transactions) {
      for (var item in trx.items) {
        // Hitung jumlah terjual
        if (productCount.containsKey(item.product.name)) {
          productCount[item.product.name] = productCount[item.product.name]! + item.quantity;
          productIncome[item.product.name] = productIncome[item.product.name]! + item.subtotal;
        } else {
          productCount[item.product.name] = item.quantity;
          productIncome[item.product.name] = item.subtotal;
        }
      }
    }

    // Ubah ke List dan Sortir dari yang terbanyak
    List<Map<String, dynamic>> result = productCount.entries.map((entry) {
      return {
        'name': entry.key,
        'sold': entry.value,
        'income': productIncome[entry.key] ?? 0,
      };
    }).toList();

    // Urutkan (Sort Descending)
    result.sort((a, b) => b['sold'].compareTo(a['sold']));

    // Ambil 5 teratas saja
    return result.take(5).toList();
  }
}