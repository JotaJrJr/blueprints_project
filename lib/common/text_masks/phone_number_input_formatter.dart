import 'package:flutter/services.dart';

class PhoneNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');

    final digits = digitsOnly.length > 10 ? digitsOnly.substring(0, 10) : digitsOnly;

    final buffer = StringBuffer();

    if (digits.isEmpty) {
      return newValue.copyWith(text: '', selection: newValue.selection);
    } else if (digits.length < 4) {
      buffer.write(digits);
    } else if (digits.length < 7) {
      buffer.write('(${digits.substring(0, 3)}) ');
      buffer.write(digits.substring(3));
    } else {
      buffer.write('(${digits.substring(0, 3)}) ');
      buffer.write('${digits.substring(3, 6)}-');
      buffer.write(digits.substring(6));
    }

    final formatted = buffer.toString();

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  static String formatUSPhoneNumber(String rawPhone) {
    final digits = rawPhone.replaceAll(RegExp(r'\D'), '');

    if (digits.length <= 3) {
      return digits;
    } else if (digits.length <= 6) {
      return '(${digits.substring(0, 3)}) ${digits.substring(3)}';
    } else if (digits.length <= 10) {
      return '(${digits.substring(0, 3)}) ${digits.substring(3, 6)}-${digits.substring(6)}';
    } else {
      return '(${digits.substring(0, 3)}) ${digits.substring(3, 6)}-${digits.substring(6, 10)}';
    }
  }
}
