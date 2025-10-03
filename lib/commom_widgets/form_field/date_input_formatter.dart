import 'package:flutter/services.dart';

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    final newText = StringBuffer();
    int selectionIndex = newValue.selection.end;

    if (text.isNotEmpty) {
      // Remove caracteres não numéricos
      final cleanText = text.replaceAll(RegExp(r'[^\d]'), '');

      // Adiciona os números com as barras na posição correta
      for (int i = 0; i < cleanText.length; i++) {
        if (i == 2 || i == 4) {
          // Adiciona barras nas posições 2 e 4
          newText.write('/');
          if (selectionIndex >= i) {
            selectionIndex++;
          }
        }
        newText.write(cleanText[i]);
        if (selectionIndex >= i) {
          selectionIndex++;
        }
      }
    }

    // Mantém o cursor no último índice, mesmo ao digitar
    selectionIndex = newText.length;

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
