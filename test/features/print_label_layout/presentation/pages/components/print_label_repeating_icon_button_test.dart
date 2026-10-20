import 'package:celta_inventario/localization/localization.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/pages/components/components.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('should call onPressed on single tap', (tester) async {
    var callCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('pt'),
        home: Scaffold(
          body: PrintLabelRepeatingIconButton(
            onPressed: () => callCount++,
            icon: const Icon(Icons.add),
            repeatInterval: const Duration(milliseconds: 75),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(PrintLabelRepeatingIconButton));
    await tester.pumpAndSettle();

    expect(callCount, 1);
  });

  testWidgets('should repeat onPressed repeatedly when long-pressed', (
    tester,
  ) async {
    var callCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('pt'),
        home: Scaffold(
          body: PrintLabelRepeatingIconButton(
            onPressed: () => callCount++,
            icon: const Icon(Icons.add),
            repeatInterval: const Duration(milliseconds: 50),
          ),
        ),
      ),
    );

    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(PrintLabelRepeatingIconButton)),
    );

    // Wait for long press to trigger
    await tester.pump(kLongPressTimeout);
    expect(callCount, 1);

    // Advance time during long press to trigger periodic repeats
    await tester.pump(const Duration(milliseconds: 100));
    expect(callCount, 3);

    // Release gesture
    await gesture.up();
    await tester.pumpAndSettle();

    // Advance time again - should not increment anymore after release
    await tester.pump(const Duration(milliseconds: 200));
    expect(callCount, 3);
  });

  testWidgets('should use the latest onPressed callback while repeating', (
    tester,
  ) async {
    var value = 0;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('pt'),
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              final currentValue = value;
              return PrintLabelRepeatingIconButton(
                onPressed: () => setState(() => value = currentValue + 1),
                icon: const Icon(Icons.add),
                repeatInterval: const Duration(milliseconds: 50),
              );
            },
          ),
        ),
      ),
    );

    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(PrintLabelRepeatingIconButton)),
    );

    await tester.pump(kLongPressTimeout);
    expect(value, 1);

    await tester.pump(const Duration(milliseconds: 50));
    expect(value, 2);

    await tester.pump(const Duration(milliseconds: 50));
    expect(value, 3);

    await gesture.up();
    await tester.pumpAndSettle();
  });

  testWidgets('should not call onPressed when disabled', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('pt'),
        home: Scaffold(
          body: PrintLabelRepeatingIconButton(
            onPressed: null,
            icon: Icon(Icons.add),
            repeatInterval: Duration(milliseconds: 75),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(PrintLabelRepeatingIconButton));
    await tester.pumpAndSettle();

    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(PrintLabelRepeatingIconButton)),
    );
    await tester.pump(const Duration(milliseconds: 600));
    await gesture.up();
    await tester.pumpAndSettle();
  });
}
