import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/controllers/controllers.dart';
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
  testWidgets('should limit the name and update editable identity values', (
    tester,
  ) async {
    final layout = EntityFactory.makeBSFPrintLabelLayoutEntity(
      code: 10,
      name: 'Layout',
      layoutType: BSFPrintLabelLayoutType.customer,
      addressType: BSFPrintLabelAddressType.principal,
    );
    final container = await _pump(tester, layout, (current) {
      return PrintLabelLayoutGeneralInformation(layout: current);
    });

    expect(
      tester
          .widget<BaseTextFormField>(
            find.byKey(const Key('print-label-layout-name')).first,
          )
          .maxLength,
      50,
    );
    await tester.enterText(
      find.byKey(const Key('print-label-layout-name')).first,
      'Updated layout',
    );
    tester
        .widget<BaseSegmentedButtons<BSFPrintLabelAddressType>>(
          find.byKey(const Key('print-label-layout-address-type')).first,
        )
        .onChanged!(BSFPrintLabelAddressType.delivery);

    final updated = container
        .read(printLabelLayoutDetailsControllerProvider(10))
        .requireValue;
    expect(updated.name, 'Updated layout');
    expect(updated.addressType, BSFPrintLabelAddressType.delivery);
  });

  for (final layoutType in BSFPrintLabelLayoutType.values) {
    testWidgets('should show address type only for $layoutType', (
      tester,
    ) async {
      final layout = EntityFactory.makeBSFPrintLabelLayoutEntity(
        code: 10,
        layoutType: layoutType,
      );
      await _pump(tester, layout, (current) {
        return PrintLabelLayoutGeneralInformation(layout: current);
      });

      final shouldShow =
          layoutType == BSFPrintLabelLayoutType.customer ||
          layoutType == BSFPrintLabelLayoutType.customerCard;
      expect(
        find.byKey(const Key('print-label-layout-address-type')),
        shouldShow ? findsWidgets : findsNothing,
      );
      if (shouldShow) {
        expect(
          tester
                  .widget<BaseSegmentedButtons<BSFPrintLabelAddressType>>(
                    find
                        .byKey(const Key('print-label-layout-address-type'))
                        .first,
                  )
                  .onChanged !=
              null,
          layoutType == BSFPrintLabelLayoutType.customer,
        );
      }
    });
  }

  final formCases =
      <
        ({
          String name,
          bool isGeneric,
          BSFLabelPrinterModelType model,
          BSFPrintLabelFormType formType,
          bool canEditFormType,
          bool canEditHeight,
          bool canEditFormSize,
        })
      >[
        (
          name: 'generic paginated',
          isGeneric: true,
          model: BSFLabelPrinterModelType.generic,
          formType: BSFPrintLabelFormType.paginated,
          canEditFormType: false,
          canEditHeight: true,
          canEditFormSize: true,
        ),
        (
          name: 'Zebra GC420t paginated',
          isGeneric: false,
          model: BSFLabelPrinterModelType.zebraGC420t,
          formType: BSFPrintLabelFormType.paginated,
          canEditFormType: true,
          canEditHeight: true,
          canEditFormSize: false,
        ),
        (
          name: 'specific continuous',
          isGeneric: false,
          model: BSFLabelPrinterModelType.os214Plus,
          formType: BSFPrintLabelFormType.continuous,
          canEditFormType: true,
          canEditHeight: true,
          canEditFormSize: false,
        ),
        (
          name: 'specific paginated',
          isGeneric: false,
          model: BSFLabelPrinterModelType.os214Plus,
          formType: BSFPrintLabelFormType.paginated,
          canEditFormType: true,
          canEditHeight: false,
          canEditFormSize: false,
        ),
      ];

  for (final testCase in formCases) {
    testWidgets('should match the form control matrix for ${testCase.name}', (
      tester,
    ) async {
      final layout = EntityFactory.makeBSFPrintLabelLayoutEntity(
        code: 10,
        formType: testCase.formType,
        labelPrinter: EntityFactory.makeBSFPrintLabelPrinterEntity(
          isGeneric: testCase.isGeneric,
          modelType: testCase.model,
        ),
      );
      await _pump(tester, layout, (current) {
        return PrintLabelLayoutFormParameters(layout: current);
      });

      expect(
        tester
                .widget<BaseSegmentedButtons<BSFPrintLabelFormType>>(
                  find.byKey(const Key('print-label-layout-form-type')).first,
                )
                .onChanged !=
            null,
        testCase.canEditFormType,
      );
      expect(
        tester
                .widget<PrintLabelLayoutValueAdjuster>(
                  find.byKey(const Key('print-label-layout-form-height')).first,
                )
                .onIncrease !=
            null,
        testCase.canEditHeight,
      );
      expect(
        tester
                .widget<BaseSwitch>(
                  find
                      .byKey(const Key('print-label-layout-apply-form-size'))
                      .first,
                )
                .onChanged !=
            null,
        testCase.canEditFormSize,
      );
    });
  }

  testWidgets('should update every editable form value', (tester) async {
    final layout = EntityFactory.makeBSFPrintLabelLayoutEntity(
      code: 10,
      formType: BSFPrintLabelFormType.continuous,
      formWidth: 10,
      formHeight: 20,
      formTopMargin: 1,
      formLeftMargin: 2,
      quantityColumns: 1,
      applyFormSizeConfiguration: false,
      labelPrinter: EntityFactory.makeBSFPrintLabelPrinterEntity(
        isGeneric: true,
        modelType: BSFLabelPrinterModelType.generic,
      ),
    );
    final container = await _pump(tester, layout, (current) {
      return PrintLabelLayoutFormParameters(layout: current);
    });

    for (final key in const [
      'print-label-layout-form-width',
      'print-label-layout-form-height',
      'print-label-layout-form-top-margin',
      'print-label-layout-form-left-margin',
      'print-label-layout-quantity-columns',
    ]) {
      tester
          .widget<PrintLabelLayoutValueAdjuster>(find.byKey(Key(key)).first)
          .onIncrease!();
    }
    tester
        .widget<BaseSwitch>(
          find.byKey(const Key('print-label-layout-apply-form-size')).first,
        )
        .onChanged!(true);

    final updated = container
        .read(printLabelLayoutDetailsControllerProvider(10))
        .requireValue;
    expect(updated.formWidth, 11);
    expect(updated.formHeight, 21);
    expect(updated.formTopMargin, 2);
    expect(updated.formLeftMargin, 3);
    expect(updated.quantityColumns, 2);
    expect(updated.applyFormSizeConfiguration, isTrue);
  });
}

Future<ProviderContainer> _pump(
  WidgetTester tester,
  BSFPrintLabelLayoutEntity layout,
  Widget Function(BSFPrintLabelLayoutEntity) builder,
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
                data: (current) =>
                    SingleChildScrollView(child: builder(current)),
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
