import 'package:celta_inventario/features/print_label_layout/presentation/pages/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildSubject({
    required String label,
    required String value,
    required num currentValue,
    required num min,
    num max = double.infinity,
    bool enabled = true,
    required VoidCallback onDecrease,
    required VoidCallback onIncrease,
    ValueChanged<num>? onValueChanged,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: PrintLabelLayoutValueAdjuster(
            label: label,
            value: value,
            currentValue: currentValue,
            min: min,
            max: max,
            enabled: enabled,
            onDecrease: onDecrease,
            onIncrease: onIncrease,
            onValueChanged: onValueChanged,
          ),
        ),
      ),
    );
  }

  group('PrintLabelLayoutValueAdjuster', () {
    testWidgets('disables decrease when currentValue <= min', (tester) async {
      var decreaseCalled = false;
      var increaseCalled = false;

      await tester.pumpWidget(
        buildSubject(
          label: 'Eixo X',
          value: '0',
          currentValue: 0,
          min: 0,
          max: 10,
          onDecrease: () => decreaseCalled = true,
          onIncrease: () => increaseCalled = true,
        ),
      );

      final minusButton = tester.widget<IconButton>(
        find.ancestor(
          of: find.byIcon(Icons.remove_circle_outline),
          matching: find.byType(IconButton),
        ),
      );
      final plusButton = tester.widget<IconButton>(
        find.ancestor(
          of: find.byIcon(Icons.add_circle_outline),
          matching: find.byType(IconButton),
        ),
      );

      expect(minusButton.onPressed, isNull);
      expect(plusButton.onPressed, isNotNull);

      await tester.tap(find.byIcon(Icons.add_circle_outline));
      await tester.pump();
      expect(decreaseCalled, isFalse);
      expect(increaseCalled, isTrue);
    });

    testWidgets('disables increase when currentValue >= max', (tester) async {
      await tester.pumpWidget(
        buildSubject(
          label: 'Colunas',
          value: '99',
          currentValue: 99,
          min: 1,
          max: 99,
          onDecrease: () {},
          onIncrease: () {},
        ),
      );

      final minusButton = tester.widget<IconButton>(
        find.ancestor(
          of: find.byIcon(Icons.remove_circle_outline),
          matching: find.byType(IconButton),
        ),
      );
      final plusButton = tester.widget<IconButton>(
        find.ancestor(
          of: find.byIcon(Icons.add_circle_outline),
          matching: find.byType(IconButton),
        ),
      );

      expect(minusButton.onPressed, isNotNull);
      expect(plusButton.onPressed, isNull);
    });

    testWidgets('allows user to type new value inline and updates via debounce', (
      tester,
    ) async {
      num? updatedValue;

      await tester.pumpWidget(
        buildSubject(
          label: 'Largura',
          value: '10.0',
          currentValue: 10.0,
          min: 0,
          max: 100,
          onDecrease: () {},
          onIncrease: () {},
          onValueChanged: (val) => updatedValue = val,
        ),
      );

      await tester.tap(find.text('10.0'));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);

      await tester.enterText(find.byType(TextField), '25.5');
      // Wait less than debounce duration -> not yet called and still editing
      await tester.pump(const Duration(milliseconds: 200));
      expect(updatedValue, isNull);
      expect(find.byType(TextField), findsOneWidget);

      // Wait full debounce duration -> called with parsed double and auto-dismisses
      await tester.pump(const Duration(milliseconds: 450));
      expect(updatedValue, 25.5);
      expect(find.byType(TextField), findsNothing);
    });

    testWidgets('submits value and hides TextField when focus is lost', (
      tester,
    ) async {
      num? updatedValue;
      final otherFocusNode = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                PrintLabelLayoutValueAdjuster(
                  label: 'Largura',
                  value: '10.0',
                  currentValue: 10.0,
                  min: 0,
                  max: 100,
                  onDecrease: () {},
                  onIncrease: () {},
                  onValueChanged: (val) => updatedValue = val,
                ),
                TextField(
                  key: const Key('other-field'),
                  focusNode: otherFocusNode,
                ),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.text('10.0'));
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsNWidgets(2));

      await tester.enterText(find.byType(TextField).first, '30.0');

      // Immediately unfocus by tapping other field
      await tester.tap(find.byKey(const Key('other-field')));
      await tester.pumpAndSettle();

      expect(updatedValue, 30.0);
      // Value adjuster field is gone, only other-field remains
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('clamps value between min and max and respects acceptDecimal: false', (
      tester,
    ) async {
      num? updatedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrintLabelLayoutValueAdjuster(
              label: 'Colunas',
              value: '5',
              currentValue: 5,
              min: 1,
              max: 99,
              acceptDecimal: false,
              onDecrease: () {},
              onIncrease: () {},
              onValueChanged: (val) => updatedValue = val,
            ),
          ),
        ),
      );

      await tester.tap(find.text('5'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '150');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(updatedValue, 99);
      expect(find.byType(TextField), findsNothing);
    });
  });
}
