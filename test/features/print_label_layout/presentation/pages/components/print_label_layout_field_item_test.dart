import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/domain/repositories/repositories.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/pages/components/editor/editor.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/pages/details/components/components.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/pages/pages.dart';
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
          previewValue: isFloat ? '5,55' : 'Texto',
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
        if (isFloat) {
          expect(
            tester
                .widgetList<TitleAndSubTitle>(find.byType(TitleAndSubTitle))
                .any((widget) => widget.subTitle == '5,55'),
            isTrue,
          );
          final decimalAdjuster = find.ancestor(
            of: find.text('Casas decimais'),
            matching: find.byType(PrintLabelLayoutValueAdjuster),
          );
          await tester.tap(
            find.descendant(
              of: decimalAdjuster,
              matching: find.byIcon(Icons.add_circle_outline),
            ),
          );
          await tester.pumpAndSettle();

          expect(
            tester
                .widgetList<TitleAndSubTitle>(find.byType(TitleAndSubTitle))
                .any((widget) => widget.subTitle == '5,550'),
            isTrue,
          );
        }
      },
    );
  }

  testWidgets('should initialize a new float field with two decimal places', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final definition = EntityFactory.makeBSFPrintLabelFieldDefinitionEntity(
      name: 'Preço de venda',
      fieldType: BSFPrintLabelFieldType.float,
    );
    final draft = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
      code: 0,
      quantityDecimalPlaces: 0,
      previewValue: '5,55',
      field: definition,
      format: EntityFactory.makeBSFPrintLabelFieldFormatEntity(floatType: true),
    );
    final option = EntityFactory.makePrintLabelFieldEditorOptionEntity(
      definition: definition,
      draft: draft,
    );
    final layout = EntityFactory.makeBSFPrintLabelLayoutEntity(
      code: 10,
      fields: const [],
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
            body: PrintLabelLayoutAddFieldPage(
              layoutCode: 10,
              fieldOptions: [option],
              formats: [draft.format!],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.byType(DropdownMenu<PrintLabelFieldEditorOptionEntity>),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Preço de venda').last);
    await tester.pumpAndSettle();

    expect(find.text('Casas decimais'), findsOneWidget);
    final decimalAdjuster = find.ancestor(
      of: find.text('Casas decimais'),
      matching: find.byType(PrintLabelLayoutValueAdjuster),
    );
    expect(
      find.descendant(of: decimalAdjuster, matching: find.text('2')),
      findsOneWidget,
    );
    expect(
      tester
          .widgetList<TitleAndSubTitle>(find.byType(TitleAndSubTitle))
          .any((widget) => widget.subTitle == '5,55'),
      isTrue,
    );
  });

  testWidgets('should initialize new field dimensions at their minimums', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final definition = EntityFactory.makeBSFPrintLabelFieldDefinitionEntity(
      name: 'EAN',
      fieldType: BSFPrintLabelFieldType.barcode,
    );
    final draft = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
      code: 0,
      width: 0,
      height: 0,
      field: definition,
    );
    final option = EntityFactory.makePrintLabelFieldEditorOptionEntity(
      definition: definition,
      draft: draft,
    );
    final layout = EntityFactory.makeBSFPrintLabelLayoutEntity(
      code: 10,
      fields: const [],
      labelPrinter: EntityFactory.makeBSFPrintLabelPrinterEntity(
        isGeneric: false,
        modelType: BSFLabelPrinterModelType.os214Plus,
      ),
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
            body: PrintLabelLayoutAddFieldPage(
              layoutCode: 10,
              fieldOptions: [option],
              formats: const [],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.byType(DropdownMenu<PrintLabelFieldEditorOptionEntity>),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('EAN').last);
    await tester.pumpAndSettle();

    final widthAdjuster = find.ancestor(
      of: find.text('Largura'),
      matching: find.byType(PrintLabelLayoutValueAdjuster),
    );
    expect(
      tester.widget<PrintLabelLayoutValueAdjuster>(widthAdjuster).value,
      '1',
    );
    final heightAdjuster = find.ancestor(
      of: find.text('Altura'),
      matching: find.byType(PrintLabelLayoutValueAdjuster),
    );
    expect(
      tester.widget<PrintLabelLayoutValueAdjuster>(heightAdjuster).value,
      '1',
    );
  });

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

    expect(find.text('Eixo X'), findsOneWidget);
    expect(find.text('2.0'), findsOneWidget);
    expect(find.text('Eixo Y'), findsOneWidget);
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
  });

  testWidgets(
    'should replace an existing definition and keep its selection while editing',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final originalDefinition =
          EntityFactory.makeBSFPrintLabelFieldDefinitionEntity(
            code: 1,
            name: 'Descrição',
          );
      final replacementDefinition =
          EntityFactory.makeBSFPrintLabelFieldDefinitionEntity(
            code: 2,
            name: 'Preço de venda',
            fieldType: BSFPrintLabelFieldType.float,
          );
      final originalFormat = EntityFactory.makeBSFPrintLabelFieldFormatEntity(
        stringType: true,
      );
      final replacementFormat =
          EntityFactory.makeBSFPrintLabelFieldFormatEntity(floatType: true);
      final original = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
        code: 7,
        field: originalDefinition,
        format: originalFormat,
      ).copyWith(prefix: 'Oferta: ');
      final replacement = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
        code: 0,
        quantityDecimalPlaces: 3,
        field: replacementDefinition,
        format: replacementFormat,
      ).copyWith(prefix: 'server-prefix');
      final layout = EntityFactory.makeBSFPrintLabelLayoutEntity(
        code: 10,
        fields: [original],
      );
      final options = EntityFactory.makeBSFPrintLabelFieldEditorOptionsEntity(
        formats: [originalFormat, replacementFormat],
        fieldOptions: [
          EntityFactory.makePrintLabelFieldEditorOptionEntity(
            definition: originalDefinition,
            draft: original,
          ),
          EntityFactory.makePrintLabelFieldEditorOptionEntity(
            definition: replacementDefinition,
            draft: replacement,
          ),
        ],
      );
      final params = EntityFactory.makeEcRequestParams();
      when(
        () => repository.getDetails(params, 10),
      ).thenAnswer((_) async => layout);
      when(
        () => repository.getFieldEditorOptions(params, layout),
      ).thenAnswer((_) async => options);

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

      await tester.tap(
        find.byType(DropdownMenu<PrintLabelFieldEditorOptionEntity>),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Preço de venda').last);
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(BaseTextFormField, 'Prefixo'),
        'Promoção: ',
      );
      await tester.pumpAndSettle();

      expect(find.text('Preço de venda'), findsOneWidget);
      expect(find.text('Casas decimais'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    },
  );

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

  final barcodeCases = [
    (
      name: 'generic barcode',
      isGeneric: true,
      symbology: BSFBarcodeSimbologyType.code128,
      showsGenericControls: true,
      showsRatio: false,
      modelType: BSFLabelPrinterModelType.generic,
    ),
    (
      name: 'generic QR barcode',
      isGeneric: true,
      symbology: BSFBarcodeSimbologyType.qrCode,
      showsGenericControls: false,
      showsRatio: false,
      modelType: BSFLabelPrinterModelType.generic,
    ),
    (
      name: 'specific barcode',
      isGeneric: false,
      symbology: BSFBarcodeSimbologyType.code128,
      showsGenericControls: false,
      showsRatio: true,
      modelType: BSFLabelPrinterModelType.zebraGC420t,
    ),
    (
      name: 'specific QR barcode',
      isGeneric: false,
      symbology: BSFBarcodeSimbologyType.qrCode,
      showsGenericControls: false,
      showsRatio: false,
      modelType: BSFLabelPrinterModelType.zebraGC420t,
    ),
    (
      name: 'OS214 Plus QR barcode',
      isGeneric: false,
      symbology: BSFBarcodeSimbologyType.qrCode,
      showsGenericControls: false,
      showsRatio: false,
      modelType: BSFLabelPrinterModelType.os214Plus,
    ),
  ];

  for (final testCase in barcodeCases) {
    testWidgets('should show supported barcode controls for ${testCase.name}', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final representativeField =
          EntityFactory.makeBSFPrintLabelFieldDefinitionEntity(
            code: 90,
            name: 'Preço de venda',
          );
      final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
        dimensionType: BSFPrintLabelFieldDimensionType.printerCommandValue,
        ratioBarCode: 2.0,
        barcodeSimbologyType: testCase.symbology,
        drawLabelBelowBarcode: true,
        fieldForDataBarcode: representativeField,
        field: EntityFactory.makeBSFPrintLabelFieldDefinitionEntity(
          fieldType: BSFPrintLabelFieldType.barcode,
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
      final options = EntityFactory.makeBSFPrintLabelFieldEditorOptionsEntity(
        fieldOptions: [
          EntityFactory.makePrintLabelFieldEditorOptionEntity(
            definition: representativeField,
          ),
        ],
      );
      final params = EntityFactory.makeEcRequestParams();
      when(
        () => repository.getDetails(params, 10),
      ).thenAnswer((_) async => layout);
      when(
        () => repository.getFieldEditorOptions(params, layout),
      ).thenAnswer((_) async => options);

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
        find.text('Tipo do código de barras'),
        testCase.showsGenericControls ? findsOneWidget : findsNothing,
      );
      expect(
        find.text('Campo representante do dado'),
        testCase.showsGenericControls ? findsOneWidget : findsNothing,
      );
      expect(
        find.text('Proporção das barras'),
        testCase.showsRatio ? findsOneWidget : findsNothing,
      );
      if (testCase.showsRatio) {
        final ratioAdjuster = find.ancestor(
          of: find.text('Proporção das barras'),
          matching: find.byType(PrintLabelLayoutValueAdjuster),
        );
        expect(find.text('2.0'), findsOneWidget);

        await tester.tap(
          find.descendant(
            of: ratioAdjuster,
            matching: find.byIcon(Icons.add_circle_outline),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('2.1'), findsOneWidget);
      }
      expect(
        find.text('Imprimir o texto abaixo do código de barras'),
        testCase.symbology == BSFBarcodeSimbologyType.qrCode
            ? findsNothing
            : findsOneWidget,
      );
      final isQrCode = testCase.symbology == BSFBarcodeSimbologyType.qrCode;
      expect(find.text('Tamanho'), isQrCode ? findsOneWidget : findsNothing);
      expect(find.text('Largura'), isQrCode ? findsNothing : findsOneWidget);
      expect(find.text('Altura'), isQrCode ? findsNothing : findsOneWidget);
      expect(
        find.text('Nome da imagem'),
        isQrCode && !testCase.isGeneric ? findsOneWidget : findsNothing,
      );
      expect(
        find.text('Rotação'),
        testCase.modelType == BSFLabelPrinterModelType.os214Plus
            ? findsNothing
            : findsOneWidget,
      );
    });
  }

  testWidgets('should apply QR controls to an ordinary QR format', (
    tester,
  ) async {
    final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
      field: EntityFactory.makeBSFPrintLabelFieldDefinitionEntity(
        fieldType: BSFPrintLabelFieldType.string,
      ),
      format: EntityFactory.makeBSFPrintLabelFieldFormatEntity(
        qrCodeType: true,
      ),
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
            body: PrintLabelLayoutFieldItem(
              layoutCode: 10,
              fieldIndex: 0,
              field: field,
              coordinateUnit: BSFPrintLabelCoordinateUnit.printerDot,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tamanho'), findsOneWidget);
    expect(find.text('Largura'), findsNothing);
    expect(find.text('Altura'), findsNothing);
    expect(find.text('Nome da imagem'), findsNothing);
  });

  testWidgets('should keep ordinary image name read-only', (tester) async {
    final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
      field: EntityFactory.makeBSFPrintLabelFieldDefinitionEntity(
        fieldType: BSFPrintLabelFieldType.logo,
      ),
    ).copyWith(imageName: 'logo');
    final layout = EntityFactory.makeBSFPrintLabelLayoutEntity(
      code: 10,
      labelPrinter: EntityFactory.makeBSFPrintLabelPrinterEntity(
        isGeneric: false,
        modelType: BSFLabelPrinterModelType.os214Plus,
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
            body: PrintLabelLayoutFieldItem(
              layoutCode: 10,
              fieldIndex: 0,
              field: field,
              coordinateUnit: BSFPrintLabelCoordinateUnit.printerDot,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Nome da imagem'), findsNothing);
    expect(find.text('Rotação'), findsNothing);
  });

  testWidgets('should keep the field when removal is canceled', (tester) async {
    final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity();
    final layout = EntityFactory.makeBSFPrintLabelLayoutEntity(
      code: 10,
      fields: [field],
    );
    final params = EntityFactory.makeEcRequestParams();
    when(
      () => repository.getDetails(params, 10),
    ).thenAnswer((_) async => layout);
    when(() => repository.getFieldEditorOptions(params, layout)).thenAnswer(
      (_) async => EntityFactory.makeBSFPrintLabelFieldEditorOptionsEntity(),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ecRequestParamsProvider().overrideWith((ref) => params),
          ecPrintLabelLayoutRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MaterialApp(
          home: PrintLabelLayoutDetailsPage(labelCode: 10, enterpriseCode: 1),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();
    expect(find.text('Remover item?'), findsOneWidget);

    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    expect(find.text('Campos (1)'), findsOneWidget);
    expect(find.byType(PrintLabelPreviewElement), findsOneWidget);
  });

  testWidgets('should remove the confirmed field from the editor and preview', (
    tester,
  ) async {
    final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
      previewValue: 'REMOVE-ME',
    );
    final layout = EntityFactory.makeBSFPrintLabelLayoutEntity(
      code: 10,
      fields: [field],
    );
    final params = EntityFactory.makeEcRequestParams();
    when(
      () => repository.getDetails(params, 10),
    ).thenAnswer((_) async => layout);
    when(() => repository.getFieldEditorOptions(params, layout)).thenAnswer(
      (_) async => EntityFactory.makeBSFPrintLabelFieldEditorOptionsEntity(),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ecRequestParamsProvider().overrideWith((ref) => params),
          ecPrintLabelLayoutRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MaterialApp(
          home: PrintLabelLayoutDetailsPage(labelCode: 10, enterpriseCode: 1),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(PrintLabelPreviewElement), findsOneWidget);
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remover'));
    await tester.pumpAndSettle();

    expect(find.byType(PrintLabelLayoutFieldItem), findsNothing);
    expect(find.byType(PrintLabelPreviewElement), findsNothing);
  });
}
