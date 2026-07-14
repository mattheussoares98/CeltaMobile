import 'package:celta_inventario/commom_widgets/form_field/input_formatters/date_input_formatter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DateInputFormatter', () {
    late DateInputFormatter formatterWithDay;
    late DateInputFormatter formatterWithoutDay;

    setUp(() {
      formatterWithDay = DateInputFormatter();
      formatterWithoutDay = DateInputFormatter(includeDay: false);
    });

    test('should format full date correctly (DD/MM/YYYY)', () {
      const oldValue = TextEditingValue.empty;

      // Typing 12052024
      var newValue = const TextEditingValue(
          text: '1', selection: TextSelection.collapsed(offset: 1));
      var result = formatterWithDay.formatEditUpdate(oldValue, newValue);
      expect(result.text, '1');

      newValue = const TextEditingValue(
          text: '12', selection: TextSelection.collapsed(offset: 2));
      result = formatterWithDay.formatEditUpdate(oldValue, newValue);
      expect(result.text, '12');

      newValue = const TextEditingValue(
          text: '120', selection: TextSelection.collapsed(offset: 3));
      result = formatterWithDay.formatEditUpdate(oldValue, newValue);
      expect(result.text, '12/0');
      expect(result.selection.end, 4); // Cursor after slash

      newValue = const TextEditingValue(
          text: '12052024', selection: TextSelection.collapsed(offset: 8));
      result = formatterWithDay.formatEditUpdate(oldValue, newValue);
      expect(result.text, '12/05/2024');
    });

    test('should format month and year correctly (MM/YYYY)', () {
      const oldValue = TextEditingValue.empty;

      var newValue = const TextEditingValue(
          text: '122024', selection: TextSelection.collapsed(offset: 6));
      var result = formatterWithoutDay.formatEditUpdate(oldValue, newValue);
      expect(result.text, '12/2024');
      expect(result.text.length, 7);
    });

    test('should limit input length', () {
      const oldValue = TextEditingValue.empty;

      // With day (8 digits max)
      var newValue = const TextEditingValue(
          text: '120520241', selection: TextSelection.collapsed(offset: 9));
      var result = formatterWithDay.formatEditUpdate(oldValue, newValue);
      expect(result, oldValue); // Rejects input longer than 8 digits

      // Without day (6 digits max)
      newValue = const TextEditingValue(
          text: '1220241', selection: TextSelection.collapsed(offset: 7));
      result = formatterWithoutDay.formatEditUpdate(oldValue, newValue);
      expect(result, oldValue);
    });

    test('should ignore non-digit characters', () {
      const oldValue = TextEditingValue.empty;
      const newValue = TextEditingValue(
          text: '12a05', selection: TextSelection.collapsed(offset: 5));
      final result = formatterWithDay.formatEditUpdate(oldValue, newValue);
      expect(result.text, '12/05');
    });

    test('should maintain cursor position when editing in middle', () {
      // Current: 12/05/20
      // User places cursor after '0' (index 4) and types '7'
      // Proposed: 12/075/20
      const oldValue = TextEditingValue(
        text: '12/05/20',
        selection: TextSelection.collapsed(offset: 4),
      );
      const newValue = TextEditingValue(
        text: '12/075/20',
        selection: TextSelection.collapsed(offset: 5),
      );

      final result = formatterWithDay.formatEditUpdate(oldValue, newValue);
      expect(result.text, '12/07/520');
      expect(result.selection.end, 6); // Cursor pushed after the slash
    });

    test('should handle backspace correctly at separator', () {
      // Current: 12/
      // User hits backspace (proposing '12')
      const oldValue = TextEditingValue(
        text: '12/',
        selection: TextSelection.collapsed(offset: 3),
      );
      const newValue = TextEditingValue(
        text: '12',
        selection: TextSelection.collapsed(offset: 2),
      );

      final result = formatterWithDay.formatEditUpdate(oldValue, newValue);
      expect(result.text, '12');
      expect(result.selection.end, 2);
    });
  });
}
