import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/models/models.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/pages/components/components.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/pages/details/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../mocks/mocks.dart';

class TestPrintLabelLayoutDetailsController
    extends PrintLabelLayoutDetailsController {
  final BSFPrintLabelLayoutEntity layout;

  TestPrintLabelLayoutDetailsController(this.layout);

  @override
  BSFPrintLabelLayoutEntity build(int code) => layout;
}

void main() {
  for (final layoutType in BSFPrintLabelLayoutType.values) {
    testWidgets('should match product controls for $layoutType', (
      tester,
    ) async {
      final layout = EntityFactory.makeBSFPrintLabelLayoutEntity(
        code: 10,
        layoutType: layoutType,
      );
      await _pump(tester, layout);

      final isProduct =
          layoutType == BSFPrintLabelLayoutType.product ||
          layoutType == BSFPrintLabelLayoutType.saleRequestProduct;
      final isSaleRequestProduct =
          layoutType == BSFPrintLabelLayoutType.saleRequestProduct;
      expect(
        find.byKey(const Key('print-label-layout-product-packing')),
        isProduct ? findsOneWidget : findsNothing,
      );
      expect(
        find.byKey(const Key('print-label-layout-quantity-per-product')),
        isProduct ? findsOneWidget : findsNothing,
      );
      expect(
        find.byKey(const Key('print-label-layout-print-by-sold-quantity')),
        isSaleRequestProduct ? findsOneWidget : findsNothing,
      );
      expect(
        find.byKey(const Key('print-label-layout-balance-behavior')),
        isSaleRequestProduct ? findsOneWidget : findsNothing,
      );
    });
  }

  final labelCases = [
    (
      name: 'generic paginated',
      isGeneric: true,
      model: BSFLabelPrinterModelType.generic,
      formType: BSFPrintLabelFormType.paginated,
      editsHeight: true,
      editsDirection: false,
    ),
    (
      name: 'Zebra GC420t paginated',
      isGeneric: false,
      model: BSFLabelPrinterModelType.zebraGC420t,
      formType: BSFPrintLabelFormType.paginated,
      editsHeight: true,
      editsDirection: true,
    ),
    (
      name: 'OS214 Plus continuous',
      isGeneric: false,
      model: BSFLabelPrinterModelType.os214Plus,
      formType: BSFPrintLabelFormType.continuous,
      editsHeight: true,
      editsDirection: false,
    ),
    (
      name: 'OS214 Plus paginated',
      isGeneric: false,
      model: BSFLabelPrinterModelType.os214Plus,
      formType: BSFPrintLabelFormType.paginated,
      editsHeight: false,
      editsDirection: false,
    ),
    (
      name: 'Rabbit OS214 paginated',
      isGeneric: false,
      model: BSFLabelPrinterModelType.rabbitOS214,
      formType: BSFPrintLabelFormType.paginated,
      editsHeight: false,
      editsDirection: false,
    ),
  ];

  for (final testCase in labelCases) {
    testWidgets('should match label controls for ${testCase.name}', (
      tester,
    ) async {
      final layout = EntityFactory.makeBSFPrintLabelLayoutEntity(
        code: 10,
        formType: testCase.formType,
        labelPrinter: EntityFactory.makeBSFPrintLabelPrinterEntity(
          isGeneric: testCase.isGeneric,
          modelType: testCase.model,
          supportedDirections: const [
            BSFPrintLabelDirectionType.top,
            BSFPrintLabelDirectionType.bottom,
          ],
        ),
      );
      await _pump(tester, layout);

      expect(
        tester
            .widget<PrintLabelLayoutValueAdjuster>(
              find.byKey(const Key('print-label-layout-label-height')).first,
            )
            .enabled,
        testCase.editsHeight,
      );
      expect(
        tester
                .widget<BaseSegmentedButtons<BSFPrintLabelDirectionType>>(
                  find.byKey(const Key('print-label-layout-direction')).first,
                )
                .onChanged !=
            null,
        testCase.editsDirection,
      );
    });
  }

  testWidgets('should update every editable label and product value', (
    tester,
  ) async {
    final layout = EntityFactory.makeBSFPrintLabelLayoutEntity(
      code: 10,
      layoutType: BSFPrintLabelLayoutType.saleRequestProduct,
      formType: BSFPrintLabelFormType.continuous,
      labelWidth: 50,
      labelHeight: 30,
      labelRightMargin: 0.3,
      labelBottomMargin: 0.3,
      considerProductPacking: BSFProductPackingSelectionType.onlyUnitary,
      informPrintQuantityByProduct: false,
      printProductBySoldQuantity: false,
      goesForBalanceAndQuantityInBalance: false,
      labelPrinter: EntityFactory.makeBSFPrintLabelPrinterEntity(
        modelType: BSFLabelPrinterModelType.zebraGC420t,
      ),
    );
    final container = await _pump(tester, layout);

    for (final key in const [
      'print-label-layout-label-width',
      'print-label-layout-label-height',
      'print-label-layout-label-right-margin',
      'print-label-layout-label-bottom-margin',
    ]) {
      tester
          .widget<PrintLabelLayoutValueAdjuster>(find.byKey(Key(key)).first)
          .onIncrease();
    }
    tester
        .widget<BaseSegmentedButtons<BSFPrintLabelDirectionType>>(
          find.byKey(const Key('print-label-layout-direction')).first,
        )
        .onChanged!(BSFPrintLabelDirectionType.bottom);
    tester
        .widget<BaseSegmentedButtons<BSFProductPackingSelectionType>>(
          find.byKey(const Key('print-label-layout-product-packing')).first,
        )
        .onChanged!(BSFProductPackingSelectionType.both);
    for (final key in const [
      'print-label-layout-quantity-per-product',
      'print-label-layout-print-by-sold-quantity',
      'print-label-layout-balance-behavior',
    ]) {
      tester.widget<BaseSwitch>(find.byKey(Key(key)).first).onChanged!(true);
    }

    final updated = container
        .read(printLabelLayoutDetailsControllerProvider(10))
        .requireValue;
    expect(updated.labelWidth, 51);
    expect(updated.labelHeight, 31);
    expect(updated.labelRightMargin, closeTo(0.4, 0.0001));
    expect(updated.labelBottomMargin, closeTo(0.4, 0.0001));
    expect(updated.directionLabelType, BSFPrintLabelDirectionType.bottom);
    expect(updated.considerProductPacking, BSFProductPackingSelectionType.both);
    expect(updated.informPrintQuantityByProduct, isTrue);
    expect(updated.printProductBySoldQuantity, isTrue);
    expect(updated.goesForBalanceAndQuantityInBalance, isTrue);
  });

  testWidgets('should resize only for label dimensions', (tester) async {
    final layout = EntityFactory.makeBSFPrintLabelLayoutEntity(
      code: 10,
      layoutType: BSFPrintLabelLayoutType.saleRequestProduct,
      formType: BSFPrintLabelFormType.continuous,
      labelWidth: 50,
      labelHeight: 30,
      labelPrinter: EntityFactory.makeBSFPrintLabelPrinterEntity(
        modelType: BSFLabelPrinterModelType.eltron,
      ),
    );
    final container = await _pump(tester, layout);
    final originalMetrics = PrintLabelPreviewMetrics(layout);

    tester
        .widget<PrintLabelLayoutValueAdjuster>(
          find.byKey(const Key('print-label-layout-label-width')).first,
        )
        .onIncrease();
    tester
        .widget<PrintLabelLayoutValueAdjuster>(
          find.byKey(const Key('print-label-layout-label-height')).first,
        )
        .onIncrease();
    var updated = container
        .read(printLabelLayoutDetailsControllerProvider(10))
        .requireValue;
    expect(
      PrintLabelPreviewMetrics(updated).canvasWidth,
      isNot(originalMetrics.canvasWidth),
    );
    expect(
      PrintLabelPreviewMetrics(updated).canvasHeight,
      isNot(originalMetrics.canvasHeight),
    );

    final resizedMetrics = PrintLabelPreviewMetrics(updated);
    tester
        .widget<PrintLabelLayoutValueAdjuster>(
          find.byKey(const Key('print-label-layout-label-right-margin')).first,
        )
        .onIncrease();
    tester
        .widget<BaseSegmentedButtons<BSFProductPackingSelectionType>>(
          find.byKey(const Key('print-label-layout-product-packing')).first,
        )
        .onChanged!(BSFProductPackingSelectionType.onlyMultiple);
    tester
        .widget<BaseSwitch>(
          find
              .byKey(const Key('print-label-layout-quantity-per-product'))
              .first,
        )
        .onChanged!(true);
    updated = container
        .read(printLabelLayoutDetailsControllerProvider(10))
        .requireValue;
    expect(
      PrintLabelPreviewMetrics(updated).canvasWidth,
      resizedMetrics.canvasWidth,
    );
    expect(
      PrintLabelPreviewMetrics(updated).canvasHeight,
      resizedMetrics.canvasHeight,
    );
  });
}

Future<ProviderContainer> _pump(
  WidgetTester tester,
  BSFPrintLabelLayoutEntity layout,
) async {
  await tester.binding.setSurfaceSize(const Size(1000, 1400));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  final container = ProviderContainer(
    overrides: [
      printLabelLayoutDetailsControllerProvider(
        10,
      ).overrideWith(() => TestPrintLabelLayoutDetailsController(layout)),
    ],
  );
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        home: Scaffold(
          body: Consumer(
            builder: (context, ref, child) {
              final value = ref.watch(
                printLabelLayoutDetailsControllerProvider(10),
              );
              return value.when(
                data: (current) => SingleChildScrollView(
                  child: PrintLabelLayoutLabelParameters(layout: current),
                ),
                error: (error, stackTrace) => Text('$error'),
                loading: () => const CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return container;
}
