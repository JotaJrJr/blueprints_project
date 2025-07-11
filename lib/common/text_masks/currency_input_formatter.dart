import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  final int? decimalDigits;

  CurrencyInputFormatter({this.decimalDigits});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.isEmpty) {
      return newValue.copyWith(
        text: '',
        selection: const TextSelection.collapsed(offset: 0),
      );
    }

    double value = double.parse(digitsOnly);

    final formatter = NumberFormat.simpleCurrency(
      locale: "en_US",
      decimalDigits: decimalDigits,
    );

    int formatFactor = (decimalDigits == null) ? 100 : _adicionarZeros(decimalDigits!);

    String newText = formatter.format(value / formatFactor);

    return TextEditingValue(text: newText, selection: TextSelection.collapsed(offset: newText.length));
  }

  int _adicionarZeros(int n) {
    if (n <= 0) {
      return 1;
    }
    return int.parse('1${'0' * n}');
  }
}
