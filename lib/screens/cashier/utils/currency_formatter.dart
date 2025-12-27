import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue. copyWith(text: '');
    }

    String newText = newValue.text. replaceAll(RegExp(r'[^0-9]'), '');
    if (newText.isEmpty) {
      return newValue. copyWith(text: '');
    }

    double value = double.parse(newText);
    final formatter = NumberFormat. currency(
      locale: 'id_ID',
      symbol: '',
      decimalDigits: 0,
    );
    String formatted = formatter.format(value).trim();

    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted. length),
    );
  }
}