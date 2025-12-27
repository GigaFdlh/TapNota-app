// lib/providers/settings_provider. dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  String _storeName = "Warung Berkah Jaya";
  String _storeAddress = "Jl. Raya No. 123, Jakarta";
  String _storePhone = "08123456789";
  String _currency = "IDR";
  String _language = "Indonesia";
  bool _isDarkMode = false;
  bool _autoSaveHistory = true;
  String _receiptFormat = "80mm";
  String _themeColor = "Ungu (Default)";

  // Getters
  String get storeName => _storeName;
  String get storeAddress => _storeAddress;
  String get storePhone => _storePhone;
  String get currency => _currency;
  String get language => _language;
  bool get isDarkMode => _isDarkMode;
  bool get autoSaveHistory => _autoSaveHistory;
  String get receiptFormat => _receiptFormat;
  String get themeColor => _themeColor;

  // Constructor
  SettingsProvider() {
    loadSettings();
  }

  // Load settings dari SharedPreferences
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _storeName = prefs.getString('store_name') ?? "Warung Berkah Jaya";
    _storeAddress = prefs.getString('store_address') ?? "Jl. Raya No. 123, Jakarta";
    _storePhone = prefs.getString('store_phone') ?? "08123456789";
    _currency = prefs.getString('currency') ?? "IDR";
    _language = prefs.getString('language') ?? "Indonesia";
    _isDarkMode = prefs.getBool('dark_mode') ?? false;
    _autoSaveHistory = prefs.getBool('auto_save_history') ?? true;
    _receiptFormat = prefs.getString('receipt_format') ?? "80mm";
    _themeColor = prefs.getString('theme_color') ?? "Ungu (Default)";
    notifyListeners();
  }

  // Update Store Name
  Future<void> updateStoreName(String name) async {
    _storeName = name;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('store_name', name);
    notifyListeners();
  }

  // Update Store Address
  Future<void> updateStoreAddress(String address) async {
    _storeAddress = address;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('store_address', address);
    notifyListeners();
  }

  // Update Store Phone
  Future<void> updateStorePhone(String phone) async {
    _storePhone = phone;
    final prefs = await SharedPreferences. getInstance();
    await prefs.setString('store_phone', phone);
    notifyListeners();
  }

  // Update Currency
  Future<void> updateCurrency(String curr) async {
    _currency = curr;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currency', curr);
    notifyListeners();
  }

  // Update Language
  Future<void> updateLanguage(String lang) async {
    _language = lang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', lang);
    notifyListeners();
  }

  // Toggle Dark Mode
  Future<void> toggleDarkMode(bool value) async {
    _isDarkMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', value);
    notifyListeners();
  }

  // Toggle Auto Save History
  Future<void> toggleAutoSaveHistory(bool value) async {
    _autoSaveHistory = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('auto_save_history', value);
    notifyListeners();
  }

  // Update Receipt Format
  Future<void> updateReceiptFormat(String format) async {
    _receiptFormat = format;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('receipt_format', format);
    notifyListeners();
  }

  // Update Theme Color
  Future<void> updateThemeColor(String color) async {
    _themeColor = color;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_color', color);
    notifyListeners();
  }
}