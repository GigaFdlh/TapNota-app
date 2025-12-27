import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class Product {
  final String id;
  final String name;
  final int price;
  final String? imagePath;
  final String unit;

  Product({
    String? id,
    required this.name,
    required this.price,
    this.imagePath,
    this.unit = 'Pcs',
  }) : id = id ?? uuid.v4();

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      imagePath: json['imagePath'],
      unit: json['unit'] ?? 'Pcs',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'imagePath': imagePath,
        'unit': unit,
      };
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  int get subtotal => product.price * quantity;

  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'quantity': quantity,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
    );
  }
}

// --- UPDATE DI SINI ---
class Transaction {
  final String id;
  final DateTime date;
  final List<CartItem> items;
  final int totalAmount;
  final String customerName;
  final int paymentAmount; // Total Bayar (Uang diterima)
  final int changeAmount;  // Kembalian

  Transaction({
    String? id,
    required this.date,
    required this.items,
    required this.totalAmount,
    this.customerName = "Umum",
    required this.paymentAmount, // Wajib diisi
    required this.changeAmount,  // Wajib diisi
  }) : id = id ?? uuid.v4();

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'items': items.map((i) => i.toJson()).toList(),
        'totalAmount': totalAmount,
        'customerName': customerName,
        'paymentAmount': paymentAmount, // Simpan
        'changeAmount': changeAmount,   // Simpan
      };

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      date: DateTime.parse(json['date']),
      items: (json['items'] as List).map((i) => CartItem.fromJson(i)).toList(),
      totalAmount: json['totalAmount'],
      customerName: json['customerName'] ?? "Umum",
      // Handle data lama yang mungkin belum punya field ini (kasih default 0 atau sama dengan total)
      paymentAmount: json['paymentAmount'] ?? json['totalAmount'], 
      changeAmount: json['changeAmount'] ?? 0, 
    );
  }
}