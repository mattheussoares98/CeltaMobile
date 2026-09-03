import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/domain/repositories/repositories.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/pages/details/components/components.dart';
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

  final ordinaryTextCases =
      <
        ({
          String name,
          bool isGeneric,
          BSFLabelPrinterModelType modelType,
          BSFPrintLabelFieldType fieldType,
          bool showsAlignment,
          bool showsDecimalPlaces,
          bool showsReverseText,
        })
      >[
        (
          name: 'generic string',
          isGeneric: true,
          modelType: BSFLabelPrinterModelType.generic,
          fieldType: BSFPrintLabelFieldType.string,
          showsAlignment: true,
          showsDecimalPlaces: false,
          showsReverseText: false,
        ),
        (
          name: 'generic float',
          isGeneric: true,
          modelType: BSFLabelPrinterModelType.generic,
          fieldType: BSFPrintLabelFieldType.float,
          showsAlignment: true,
          showsDecimalPlaces: true,
          showsReverseText: false,
        ),
        (
          name: 'specific string',
          isGeneric: false,
          modelType: BSFLabelPrinterModelType.zebraGC420t,
          fieldType: BSFPrintLabelFieldType.string,
          showsAlignment: false,
          showsDecimalPlaces: false,
          showsReverseText: true,
        ),
        (
          name: 'specific float',
          isGeneric: false,
          modelType: BSFLabelPrinterModelType.zebraGC420t,
          fieldType: BSFPrintLabelFieldType.float,
          showsAlignment: false,
          showsDecimalPlaces: true,
          showsReverseText: true,
        ),
        (
          name: 'OS214 Plus string',
          isGeneric: false,
          modelType: BSFLabelPrinterModelType.os214Plus,
          fieldType: BSFPrintLabelFieldType.string,
          showsAlignment: false,
          showsDecimalPlaces: false,
          showsReverseText: false,
        ),
        (
          name: 'Rabbit OS214 string',
          isGeneric: false,
          modelType: BSFLabelPrinterModelType.rabbitOS214,
          fieldType: BSFPrintLabelFieldType.string,
          showsAlignment: false,
          showsDecimalPlaces: false,
          showsReverseText: false,
        ),
      ];

  for (final testCase in ordinaryTextCases) {
    testWidgets(
      'should show supported ordinary-text controls for ${testCase.name}',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(800, 1200));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        final isFloat = testCase.fieldType == BSFPrintLabelFieldType.float;
        final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
          quantityDecimalPlaces: 2,
          field: EntityFactory.makeBSFPrintLabelFieldDefinitionEntity(
            fieldType: testCase.fieldType,
          ),
          format: EntityFactory.makeBSFPrintLabelFieldFormatEntity(
            stringType: !isFloat,
            floatType: isFloat,
          ),
        );
        final layout = EntityFactory.makeBSFPrintLabelLayoutEntity(
          code: 10,
          labelPrinter: EntityFactory.makeBSFPrintLabelPrinterEntity(
            isGeneric: testCase.isGeneric,
            modelType: testCase.modelType,
          ),
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
              ecPrintLabelLayoutRepositoryProvider.overrideWithValue(
                repository,
              ),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: Consumer(
                  builder: (context, ref, child) {
                    final value = ref.watch(
                      printLabelLayoutDetailsControllerProvider(10),
                    );
                    return value.when(
                      data: (currentLayout) => SingleChildScrollView(
                        child: PrintLabelLayoutFieldItem(
                          layoutCode: 10,
                          fieldIndex: 0,
                          field: currentLayout.fields.first,
                          coordinateUnit: currentLayout.coordinateUnit,
                        ),
                      ),
                      loading: () => const CircularProgressIndicator(),
                      error: (error, stackTrace) => Text(error.toString()),
                    );
                  },
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(
          find.text('Alinhamento'),
          testCase.showsAlignment ? findsOneWidget : findsNothing,
        );
        expect(
          find.text('Casas decimais'),
          testCase.showsDecimalPlaces ? findsOneWidget : findsNothing,
        );
        expect(
          find.text('Imprimir texto reverso'),
          testCase.showsReverseText ? findsOneWidget : findsNothing,
        );
      },
    );
  }

  testWidgets('should render field item adjusters and update coordinates', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

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
      labelPrinter: EntityFactory.makeBSFPrintLabelPrinterEntity(
        isGeneric: true,
        modelType: BSFLabelPrinterModelType.generic,
      ),
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
                    fieldIndex: 0,
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

    expect(find.text('X'), findsOneWidget);
    expect(find.text('2.0'), findsOneWidget);
    expect(find.text('Y'), findsOneWidget);
    expect(find.text('3.0'), findsOneWidget);
    expect(find.text('Largura'), findsOneWidget);
    expect(find.text('4.0'), findsOneWidget);
    expect(find.text('Altura'), findsOneWidget);
    expect(find.text('5.0'), findsOneWidget);
    expect(find.text('Tipo da fonte'), findsNothing);
    expect(find.text('Alinhamento'), findsOneWidget);
    expect(find.text('Esquerda'), findsOneWidget);
    expect(find.text('Centro'), findsOneWidget);
    expect(find.text('Direita'), findsOneWidget);

    await tester.tap(find.text('Direita'));
    await tester.pumpAndSettle();

    // Tap increase on X (first add button)
    final addButtons = find.byIcon(Icons.add_circle_outline);
    expect(addButtons, findsNWidgets(7));

    await tester.tap(addButtons.at(0));
    await tester.pumpAndSettle();

    expect(find.text('2.1'), findsOneWidget);

    // Tap increase on Largura (third add button)
    await tester.tap(addButtons.at(2));
    await tester.pumpAndSettle();

    expect(find.text('4.1'), findsOneWidget);

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
                    fieldIndex: 0,
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

    expect(find.text('190'), findsOneWidget);
    expect(find.text('150'), findsOneWidget);
    expect(find.text('Espessura do traço'), findsOneWidget);
    expect(find.text('75'), findsOneWidget);

    final addButtons = find.byIcon(Icons.add_circle_outline);
    expect(addButtons, findsNWidgets(5));

    // Tap increase on Espessura do traço (fifth add button)
    await tester.tap(addButtons.at(4));
    await tester.pumpAndSettle();

    expect(find.text('76'), findsOneWidget);

    expect(find.text('Rotação'), findsNothing);
    expect(find.text('90°'), findsNothing);
    expect(find.text('Tipo da fonte'), findsNothing);
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
                      fieldIndex: 0,
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
