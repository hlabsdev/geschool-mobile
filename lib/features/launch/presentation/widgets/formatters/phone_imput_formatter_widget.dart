import 'package:flutter/services.dart';

class PhoneNumberFormatter extends TextInputFormatter {
  PhoneNumberFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (!oldValue.text.contains("(") &&
        oldValue.text.length >= 10 &&
        newValue.text.length != oldValue.text.length) {
      return TextEditingValue(
        text: "",
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    if (oldValue.text.length > newValue.text.length) {
      return TextEditingValue(
        text: newValue.text.toString(),
        selection: TextSelection.collapsed(offset: newValue.text.length),
      );
    }

    var newText = newValue.text;
    // PARENTHESES AVENT LE 228
    if (newText.length == 1) newText = "(" + newText;
    // PARENTHESES ET ESPACE APRES LE 228
    if (newText.length == 4) newText = newText + ") ";
    // if (newText.length == 3) newText = newText + " ";
    // ESPACE A CHAQUE 2 CHIFFRES
    // if (newText.length == 6) newText = newText + " ";
    if (newText.length == 8) newText = newText + " ";
    // ESPACE A CHAQUE 2 CHIFFRES
    // if (newText.length == 9) newText = newText + " ";
    if (newText.length == 11) newText = newText + " ";
    // ESPACE A CHAQUE 2 CHIFFRES
    // if (newText.length == 12) newText = newText + " ";
    if (newText.length == 14) newText = newText + " ";

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
