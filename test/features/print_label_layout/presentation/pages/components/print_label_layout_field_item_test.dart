import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/domain/repositories/repositories.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/pages/components/components.dart';
import 'package:celta_inventario/features/print_label_layout/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../mocks/mocks.dart';

class MockEcPrintLabelLayoutRepository extends Mock
    implements IEcPrintLabelLayoutRepository {}

void main() {
  late MockEcPrintLabelLayoutRepository repository;

  setUp(() {
    repository = MockEcPrintLabelLayoutRepository();
  });

  testWidgets('should render field item adjusters and update coordinates', (
    tester,
  ) async {
    final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
      code: 1,
      coordinateX: 2.0,
      coordinateY: 3.0,
      width: 4.0,
      height: 5.0,
      dimensionType: BSFPrintLabelFieldDimensionType.centimeter,
    );
    final layout = EntityFactory.makeBSFPrintLabelLayoutEntity(
      code: 10,
      fields: [field],
    );

    final params = EntityFactory.makeEcRequestParams();
    when(
      () => repository.getDetails(params, 10),
    ).thenAnswer((_) async => layout);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ecRequestParamsProvider().overrideWith((ref) => params),
          ecPrintLabelLayoutRepositoryProvider.overrideWithValue(repository),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: Consumer(
              builder: (context, ref, child) {
                final layoutAsync = ref.watch(
                  printLabelLayoutDetailsControllerProvider(10),
                );
                return layoutAsync.when(
                  data: (l) => PrintLabelLayoutFieldItem(
                    layoutCode: 10,
                    field: l.fields.first,
                    coordinateUnit: BSFPrintLabelCoordinateUnit.centimeter,
                  ),
                  loading: () => const CircularProgressIndicator(),
                  error: (e, st) => Text(e.toString()),
                );
              },
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('X: 2.0'), findsOneWidget);
    expect(find.text('Y: 3.0'), findsOneWidget);
    expect(find.text('Largura: 4.0'), findsOneWidget);
    expect(find.text('Altura: 5.0'), findsOneWidget);

    // Tap increase on X (first add button)
    final addButtons = find.byIcon(Icons.add_circle_outline);
    expect(addButtons, findsNWidgets(4));

    await tester.tap(addButtons.at(0));
    await tester.pumpAndSettle();

    expect(find.text('X: 2.1'), findsOneWidget);

    // Tap increase on Largura (third add button)
    await tester.tap(addButtons.at(2));
    await tester.pumpAndSettle();

    expect(find.text('Largura: 4.1'), findsOneWidget);

    // Toggle visibility
    expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    await tester.tap(find.byIcon(Icons.visibility_outlined));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);

    await tester.tap(find.byIcon(Icons.visibility_off_outlined));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
  });

  testWidgets('should render stroke thickness adjuster for boxOrLine field', (
    tester,
  ) async {
    final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
      code: 2,
      coordinateX: 20.0,
      coordinateY: 5.0,
      width: 190.0,
      height: 150.0,
      ratioBarCode: 75.0,
      dimensionType: BSFPrintLabelFieldDimensionType.printerDot,
      field: EntityFactory.makeBSFPrintLabelFieldDefinitionEntity(
        fieldType: BSFPrintLabelFieldType.boxOrLine,
      ),
    );
    final layout = EntityFactory.makeBSFPrintLabelLayoutEntity(
      code: 10,
      fields: [field],
    );

    final params = EntityFactory.makeEcRequestParams();
    when(
      () => repository.getDetails(params, 10),
    ).thenAnswer((_) async => layout);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ecRequestParamsProvider().overrideWith((ref) => params),
          ecPrintLabelLayoutRepositoryProvider.overrideWithValue(repository),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: Consumer(
              builder: (context, ref, child) {
                final layoutAsync = ref.watch(
                  printLabelLayoutDetailsControllerProvider(10),
                );
                return layoutAsync.when(
                  data: (l) => PrintLabelLayoutFieldItem(
                    layoutCode: 10,
                    field: l.fields.first,
                    coordinateUnit: BSFPrintLabelCoordinateUnit.printerDot,
                  ),
                  loading: () => const CircularProgressIndicator(),
                  error: (e, st) => Text(e.toString()),
                );
              },
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Largura: 190'), findsOneWidget);
    expect(find.text('Altura: 150'), findsOneWidget);
    expect(find.text('Espessura do traço: 75'), findsOneWidget);

    final addButtons = find.byIcon(Icons.add_circle_outline);
    expect(addButtons, findsNWidgets(5));

    // Tap increase on Espessura do traço (fifth add button)
    await tester.tap(addButtons.at(4));
    await tester.pumpAndSettle();

    expect(find.text('Espessura do traço: 76'), findsOneWidget);

    // Tap rotation 90°
    expect(find.text('90°'), findsOneWidget);
    await tester.tap(find.text('90°'));
    await tester.pumpAndSettle();
  });

  testWidgets(
    'should render and toggle drawLabelBelowBarcode switch for barcode field',
    (tester) async {
      final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
        code: 3,
        drawLabelBelowBarcode: true,
        field: EntityFactory.makeBSFPrintLabelFieldDefinitionEntity(
          fieldType: BSFPrintLabelFieldType.barcode,
        ),
      );
      final layout = EntityFactory.makeBSFPrintLabelLayoutEntity(
        code: 10,
        fields: [field],
      );

      final params = EntityFactory.makeEcRequestParams();
      when(
        () => repository.getDetails(params, 10),
      ).thenAnswer((_) async => layout);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            ecRequestParamsProvider().overrideWith((ref) => params),
            ecPrintLabelLayoutRepositoryProvider.overrideWithValue(repository),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, child) {
                  final layoutAsync = ref.watch(
                    printLabelLayoutDetailsControllerProvider(10),
                  );
                  return layoutAsync.when(
                    data: (l) => PrintLabelLayoutFieldItem(
                      layoutCode: 10,
                      field: l.fields.first,
                      coordinateUnit: BSFPrintLabelCoordinateUnit.printerDot,
                    ),
                    loading: () => const CircularProgressIndicator(),
                    error: (e, st) => Text(e.toString()),
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Imprimir o texto abaixo do código de barras'),
        findsOneWidget,
      );

      final switchFinder = find.byType(Switch);
      expect(switchFinder, findsOneWidget);

      await tester.tap(switchFinder);
      await tester.pumpAndSettle();
    },
  );
}
