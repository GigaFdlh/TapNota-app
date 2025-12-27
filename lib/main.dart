import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/transaction_provider.dart';
import 'providers/settings_provider.dart'; //
import 'screens/splash/splash_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers:  [
        ChangeNotifierProvider(create: (_) => ProductProvider().. loadProducts()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()..loadTransactions()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()), // 👈 TAMBAHKAN
      ],
      child: const TapNotaApp(),
    ),
  );
}

class TapNotaApp extends StatelessWidget {
  const TapNotaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TapNota',
      theme:  ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF7C3AED)),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}