import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/domain/repositories/repositories.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/models/models.dart';
import 'package:celta_inventario/features/print_label_layout/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockEcPrintLabelLayoutRepository extends Mock
    implements IEcPrintLabelLayoutRepository {}

void main() {
  late MockEcPrintLabelLayoutRepository repository;
  late EcRequestParams params;
  late BSFPrintLabelLayoutEntity layout;

  ProviderContainer makeContainer() {
    return ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        ecRequestParamsProvider().overrideWith((ref) => params),
        ecPrintLabelLayoutRepositoryProvider.overrideWithValue(repository),
      ],
    );
  }

  setUp(() {
    repository = MockEcPrintLabelLayoutRepository();
    params = EntityFactory.makeEcRequestParams();
    layout = EntityFactory.makeBSFPrintLabelLayoutEntity();
  });

  test('build should load details for the requested layout code', () async {
    when(
      () => repository.getDetails(params, layout.code),
    ).thenAnswer((_) async => layout);
    final container = makeContainer();
    addTearDown(container.dispose);

    final result = await container.read(
      printLabelLayoutDetailsControllerProvider(layout.code).future,
    );

    expect(result, layout);
    verify(() => repository.getDetails(params, layout.code)).called(1);
    verifyNoMoreInteractions(repository);
  });

  test('build should propagate repository errors', () async {
    final exception = Exception('Failed to load label layout details');
    when(() => repository.getDetails(params, layout.code)).thenThrow(exception);
    final container = makeContainer();
    addTearDown(container.dispose);

    final call = container.read(
      printLabelLayoutDetailsControllerProvider(layout.code).future,
    );

    await expectLater(call, throwsA(same(exception)));
    verify(() => repository.getDetails(params, layout.code)).called(1);
    verifyNoMoreInteractions(repository);
  });

  test('build should load create options for code zero', () async {
    final draft = EntityFactory.makeBSFPrintLabelLayoutEntity(
      code: 0,
      fields: const [],
    );
    final printer = EntityFactory.makeBSFPrintLabelPrinterEntity();
    final options = EntityFactory.makeBSFPrintLabelLayoutCreateOptionsEntity(
      draft: draft,
      printers: [printer],
    );
    when(
      () => repository.getCreateOptions(params),
    ).thenAnswer((_) async => options);
    final container = makeContainer();
    addTearDown(container.dispose);
    final provider = printLabelLayoutDetailsControllerProvider(0);

    final result = await container.read(provider.future);

    expect(result, draft);
    expect(container.read(provider.notifier).printers, [printer]);
    verify(() => repository.getCreateOptions(params)).called(1);
    verifyNever(() => repository.getDetails(params, 0));
  });

  test(
    'updatePrinter should apply supported values without reloading',
    () async {
      final draft = EntityFactory.makeBSFPrintLabelLayoutEntity(
        code: 0,
        fields: const [],
        temperature: 99,
        printSpeed: 99,
      );
      final printer = EntityFactory.makeBSFPrintLabelPrinterEntity(
        supportedTemperatures: const ['10', '15'],
        supportedPrintSpeeds: const ['2', '4'],
        supportedDirections: const [BSFPrintLabelDirectionType.bottom],
      );
      when(() => repository.getCreateOptions(params)).thenAnswer(
        (_) async => EntityFactory.makeBSFPrintLabelLayoutCreateOptionsEntity(
          draft: draft,
          printers: [printer],
        ),
      );
      final container = makeContainer();
      addTearDown(container.dispose);
      final provider = printLabelLayoutDetailsControllerProvider(0);
      await container.read(provider.future);

      container.read(provider.notifier).updatePrinter(printer);

      final updated = container.read(provider).requireValue;
      expect(updated.labelPrinter, printer);
      expect(updated.temperature, 10);
      expect(updated.printSpeed, 2);
      expect(updated.directionLabelType, BSFPrintLabelDirectionType.bottom);
      verify(() => repository.getCreateOptions(params)).called(1);
    },
  );

  test(
    'updateFieldCoordinateX should update coordinateX and clamp at zero',
    () async {
      final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
        code: 1,
        coordinateX: 2.0,
      );
      final initialLayout = EntityFactory.makeBSFPrintLabelLayoutEntity(
        code: 10,
        fields: [field],
      );
      when(
        () => repository.getDetails(params, 10),
      ).thenAnswer((_) async => initialLayout);
      final container = makeContainer();
      addTearDown(container.dispose);

      await container.read(
        printLabelLayoutDetailsControllerProvider(10).future,
      );
      final notifier = container.read(
        printLabelLayoutDetailsControllerProvider(10).notifier,
      );

      notifier.updateFieldCoordinateX(0, 0.5);
      var updated = container
          .read(printLabelLayoutDetailsControllerProvider(10))
          .value!;
      expect(updated.fields.first.coordinateX, 2.5);

      notifier.updateFieldCoordinateX(0, -3.0);
      updated = container
          .read(printLabelLayoutDetailsControllerProvider(10))
          .value!;
      expect(updated.fields.first.coordinateX, 0.0);
    },
  );

  test(
    'updateFieldCoordinateY should update coordinateY and clamp at zero',
    () async {
      final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
        code: 1,
        coordinateY: 1.5,
      );
      final initialLayout = EntityFactory.makeBSFPrintLabelLayoutEntity(
        code: 10,
        fields: [field],
      );
      when(
        () => repository.getDetails(params, 10),
      ).thenAnswer((_) async => initialLayout);
      final container = makeContainer();
      addTearDown(container.dispose);

      await container.read(
        printLabelLayoutDetailsControllerProvider(10).future,
      );
      final notifier = container.read(
        printLabelLayoutDetailsControllerProvider(10).notifier,
      );

      notifier.updateFieldCoordinateY(0, 0.2);
      var updated = container
          .read(printLabelLayoutDetailsControllerProvider(10))
          .value!;
      expect(updated.fields.first.coordinateY, 1.7);

      notifier.updateFieldCoordinateY(0, -2.0);
      updated = container
          .read(printLabelLayoutDetailsControllerProvider(10))
          .value!;
      expect(updated.fields.first.coordinateY, 0.0);
    },
  );

  test('updateFieldWidth should update width and clamp at zero', () async {
    final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
      code: 1,
      width: 4.0,
    );
    final initialLayout = EntityFactory.makeBSFPrintLabelLayoutEntity(
      code: 10,
      fields: [field],
    );
    when(
      () => repository.getDetails(params, 10),
    ).thenAnswer((_) async => initialLayout);
    final container = makeContainer();
    addTearDown(container.dispose);

    await container.read(printLabelLayoutDetailsControllerProvider(10).future);
    final notifier = container.read(
      printLabelLayoutDetailsControllerProvider(10).notifier,
    );

    notifier.updateFieldWidth(0, 1.0);
    var updated = container
        .read(printLabelLayoutDetailsControllerProvider(10))
        .value!;
    expect(updated.fields.first.width, 5.0);

    notifier.updateFieldWidth(0, -10.0);
    updated = container
        .read(printLabelLayoutDetailsControllerProvider(10))
        .value!;
    expect(updated.fields.first.width, 0.0);
  });

  test('updateFieldHeight should update height and clamp at zero', () async {
    final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
      code: 1,
      height: 3.0,
    );
    final initialLayout = EntityFactory.makeBSFPrintLabelLayoutEntity(
      code: 10,
      fields: [field],
    );
    when(
      () => repository.getDetails(params, 10),
    ).thenAnswer((_) async => initialLayout);
    final container = makeContainer();
    addTearDown(container.dispose);

    await container.read(printLabelLayoutDetailsControllerProvider(10).future);
    final notifier = container.read(
      printLabelLayoutDetailsControllerProvider(10).notifier,
    );

    notifier.updateFieldHeight(0, 0.5);
    var updated = container
        .read(printLabelLayoutDetailsControllerProvider(10))
        .value!;
    expect(updated.fields.first.height, 3.5);

    notifier.updateFieldHeight(0, -5.0);
    updated = container
        .read(printLabelLayoutDetailsControllerProvider(10))
        .value!;
    expect(updated.fields.first.height, 0.0);
  });

  test('updateFieldSize should update width and height together', () async {
    final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
      width: 4.0,
      height: 7.0,
    );
    final initialLayout = EntityFactory.makeBSFPrintLabelLayoutEntity(
      code: 10,
      fields: [field],
    );
    when(
      () => repository.getDetails(params, 10),
    ).thenAnswer((_) async => initialLayout);
    final container = makeContainer();
    addTearDown(container.dispose);

    await container.read(printLabelLayoutDetailsControllerProvider(10).future);
    container
        .read(printLabelLayoutDetailsControllerProvider(10).notifier)
        .updateFieldSize(0, 1.0);

    final updated = container
        .read(printLabelLayoutDetailsControllerProvider(10))
        .requireValue
        .fields
        .first;
    expect(updated.width, 5.0);
    expect(updated.height, 5.0);
  });

  test(
    'updateFieldRatioBarCode should update ratioBarCode and clamp at zero',
    () async {
      final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
        code: 1,
        ratioBarCode: 75.0,
      );
      final initialLayout = EntityFactory.makeBSFPrintLabelLayoutEntity(
        code: 10,
        fields: [field],
      );
      when(
        () => repository.getDetails(params, 10),
      ).thenAnswer((_) async => initialLayout);
      final container = makeContainer();
      addTearDown(container.dispose);

      await container.read(
        printLabelLayoutDetailsControllerProvider(10).future,
      );
      final notifier = container.read(
        printLabelLayoutDetailsControllerProvider(10).notifier,
      );

      notifier.updateFieldRatioBarCode(0, 5.0);
      var updated = container
          .read(printLabelLayoutDetailsControllerProvider(10))
          .value!;
      expect(updated.fields.first.ratioBarCode, 80.0);

      notifier.updateFieldRatioBarCode(0, -100.0);
      updated = container
          .read(printLabelLayoutDetailsControllerProvider(10))
          .value!;
      expect(updated.fields.first.ratioBarCode, 0.0);
    },
  );

  test('updateFieldBarcodeSimbologyType should update symbology', () async {
    final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
      barcodeSimbologyType: BSFBarcodeSimbologyType.none,
    );
    final initialLayout = EntityFactory.makeBSFPrintLabelLayoutEntity(
      code: 10,
      fields: [field],
    );
    when(
      () => repository.getDetails(params, 10),
    ).thenAnswer((_) async => initialLayout);
    final container = makeContainer();
    addTearDown(container.dispose);
    await container.read(printLabelLayoutDetailsControllerProvider(10).future);

    container
        .read(printLabelLayoutDetailsControllerProvider(10).notifier)
        .updateFieldBarcodeSimbologyType(0, BSFBarcodeSimbologyType.code128);

    expect(
      container
          .read(printLabelLayoutDetailsControllerProvider(10))
          .value!
          .fields
          .first
          .barcodeSimbologyType,
      BSFBarcodeSimbologyType.code128,
    );
  });

  test(
    'updateFieldForDataBarcode should update representative field',
    () async {
      final representativeField =
          EntityFactory.makeBSFPrintLabelFieldDefinitionEntity(code: 90);
      final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity();
      final initialLayout = EntityFactory.makeBSFPrintLabelLayoutEntity(
        code: 10,
        fields: [field],
      );
      when(
        () => repository.getDetails(params, 10),
      ).thenAnswer((_) async => initialLayout);
      final container = makeContainer();
      addTearDown(container.dispose);
      await container.read(
        printLabelLayoutDetailsControllerProvider(10).future,
      );

      container
          .read(printLabelLayoutDetailsControllerProvider(10).notifier)
          .updateFieldForDataBarcode(0, representativeField);

      expect(
        container
            .read(printLabelLayoutDetailsControllerProvider(10))
            .value!
            .fields
            .first
            .fieldForDataBarcode,
        representativeField,
      );
    },
  );

  test('toggleFieldVisibility should toggle field isVisible', () async {
    final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
      code: 1,
      isVisible: true,
    );
    final initialLayout = EntityFactory.makeBSFPrintLabelLayoutEntity(
      code: 10,
      fields: [field],
    );
    when(
      () => repository.getDetails(params, 10),
    ).thenAnswer((_) async => initialLayout);
    final container = makeContainer();
    addTearDown(container.dispose);

    await container.read(printLabelLayoutDetailsControllerProvider(10).future);
    final notifier = container.read(
      printLabelLayoutDetailsControllerProvider(10).notifier,
    );

    notifier.toggleFieldVisibility(0);
    var updated = container
        .read(printLabelLayoutDetailsControllerProvider(10))
        .value!;
    expect(updated.fields.first.isVisible, false);

    notifier.toggleFieldVisibility(0);
    updated = container
        .read(printLabelLayoutDetailsControllerProvider(10))
        .value!;
    expect(updated.fields.first.isVisible, true);
  });

  test('updateFieldRotateType should update field rotation', () async {
    final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
      code: 1,
      rotateType: BSFPrintElementRotationType.none,
    );
    final initialLayout = EntityFactory.makeBSFPrintLabelLayoutEntity(
      code: 10,
      fields: [field],
    );
    when(
      () => repository.getDetails(params, 10),
    ).thenAnswer((_) async => initialLayout);
    final container = makeContainer();
    addTearDown(container.dispose);

    await container.read(printLabelLayoutDetailsControllerProvider(10).future);
    final notifier = container.read(
      printLabelLayoutDetailsControllerProvider(10).notifier,
    );

    notifier.updateFieldRotateType(0, BSFPrintElementRotationType.rotate90);
    var updated = container
        .read(printLabelLayoutDetailsControllerProvider(10))
        .value!;
    expect(
      updated.fields.first.rotateType,
      BSFPrintElementRotationType.rotate90,
    );
  });

  test('updateFieldAlignmentType should update field alignment', () async {
    final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(code: 1);
    final initialLayout = EntityFactory.makeBSFPrintLabelLayoutEntity(
      code: 10,
      fields: [field],
    );
    when(
      () => repository.getDetails(params, 10),
    ).thenAnswer((_) async => initialLayout);
    final container = makeContainer();
    addTearDown(container.dispose);

    await container.read(printLabelLayoutDetailsControllerProvider(10).future);
    final notifier = container.read(
      printLabelLayoutDetailsControllerProvider(10).notifier,
    );

    notifier.updateFieldAlignmentType(0, BSFPrintElementAlignmentType.middle);

    expect(
      container
          .read(printLabelLayoutDetailsControllerProvider(10))
          .value!
          .fields
          .first
          .alignmentType,
      BSFPrintElementAlignmentType.middle,
    );
  });

  test(
    'updateFieldQuantityDecimalPlaces should update and clamp the value',
    () async {
      final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
        code: 1,
        quantityDecimalPlaces: 1,
      );
      final initialLayout = EntityFactory.makeBSFPrintLabelLayoutEntity(
        code: 10,
        fields: [field],
      );
      when(
        () => repository.getDetails(params, 10),
      ).thenAnswer((_) async => initialLayout);
      final container = makeContainer();
      addTearDown(container.dispose);

      await container.read(
        printLabelLayoutDetailsControllerProvider(10).future,
      );
      final notifier = container.read(
        printLabelLayoutDetailsControllerProvider(10).notifier,
      );

      notifier.updateFieldQuantityDecimalPlaces(0, -2);
      expect(
        container
            .read(printLabelLayoutDetailsControllerProvider(10))
            .requireValue
            .fields
            .first
            .quantityDecimalPlaces,
        0,
      );

      notifier.updateFieldQuantityDecimalPlaces(0, 10000);
      expect(
        container
            .read(printLabelLayoutDetailsControllerProvider(10))
            .requireValue
            .fields
            .first
            .quantityDecimalPlaces,
        9999,
      );
    },
  );

  test('updateFieldFontType should clamp font type between 1 and 6', () async {
    final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
      code: 1,
      fontType: '1',
    );
    final initialLayout = EntityFactory.makeBSFPrintLabelLayoutEntity(
      code: 10,
      fields: [field],
    );
    when(
      () => repository.getDetails(params, 10),
    ).thenAnswer((_) async => initialLayout);
    final container = makeContainer();
    addTearDown(container.dispose);

    await container.read(printLabelLayoutDetailsControllerProvider(10).future);
    final notifier = container.read(
      printLabelLayoutDetailsControllerProvider(10).notifier,
    );

    notifier.updateFieldFontType(0, 0);
    expect(
      container
          .read(printLabelLayoutDetailsControllerProvider(10))
          .value!
          .fields
          .first
          .fontType,
      '1',
    );

    notifier.updateFieldFontType(0, 7);
    expect(
      container
          .read(printLabelLayoutDetailsControllerProvider(10))
          .value!
          .fields
          .first
          .fontType,
      '6',
    );
  });

  test(
    'changeFieldFontSize should clamp font size between 0 and 216',
    () async {
      final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
        code: 1,
        fontSize: 10,
      );
      final initialLayout = EntityFactory.makeBSFPrintLabelLayoutEntity(
        code: 10,
        fields: [field],
      );
      when(
        () => repository.getDetails(params, 10),
      ).thenAnswer((_) async => initialLayout);
      final container = makeContainer();
      addTearDown(container.dispose);

      await container.read(
        printLabelLayoutDetailsControllerProvider(10).future,
      );
      final notifier = container.read(
        printLabelLayoutDetailsControllerProvider(10).notifier,
      );

      for (var count = 0; count < 11; count++) {
        notifier.changeFieldFontSize(0, false);
      }
      expect(
        container
            .read(printLabelLayoutDetailsControllerProvider(10))
            .requireValue
            .fields
            .first
            .fontSize,
        0,
      );

      for (var count = 0; count < 217; count++) {
        notifier.changeFieldFontSize(0, true);
      }
      expect(
        container
            .read(printLabelLayoutDetailsControllerProvider(10))
            .requireValue
            .fields
            .first
            .fontSize,
        216,
      );
    },
  );

  test('updateFieldIsBold should update bold printing', () async {
    final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
      code: 1,
      isBold: false,
    );
    final initialLayout = EntityFactory.makeBSFPrintLabelLayoutEntity(
      code: 10,
      fields: [field],
    );
    when(
      () => repository.getDetails(params, 10),
    ).thenAnswer((_) async => initialLayout);
    final container = makeContainer();
    addTearDown(container.dispose);

    await container.read(printLabelLayoutDetailsControllerProvider(10).future);
    container
        .read(printLabelLayoutDetailsControllerProvider(10).notifier)
        .updateFieldIsBold(0, true);

    expect(
      container
          .read(printLabelLayoutDetailsControllerProvider(10))
          .requireValue
          .fields
          .first
          .isBold,
      true,
    );
  });

  test('updateFieldIsReverseText should update reverse text', () async {
    final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
      code: 1,
      isReverseText: false,
    );
    final initialLayout = EntityFactory.makeBSFPrintLabelLayoutEntity(
      code: 10,
      fields: [field],
    );
    when(
      () => repository.getDetails(params, 10),
    ).thenAnswer((_) async => initialLayout);
    final container = makeContainer();
    addTearDown(container.dispose);

    await container.read(printLabelLayoutDetailsControllerProvider(10).future);
    container
        .read(printLabelLayoutDetailsControllerProvider(10).notifier)
        .updateFieldIsReverseText(0, true);

    expect(
      container
          .read(printLabelLayoutDetailsControllerProvider(10))
          .requireValue
          .fields
          .first
          .isReverseText,
      isTrue,
    );
  });

  test(
    'updateFieldDrawLabelBelowBarcode should update drawLabelBelowBarcode',
    () async {
      final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
        code: 1,
        drawLabelBelowBarcode: false,
      );
      final initialLayout = EntityFactory.makeBSFPrintLabelLayoutEntity(
        code: 10,
        fields: [field],
      );
      when(
        () => repository.getDetails(params, 10),
      ).thenAnswer((_) async => initialLayout);
      final container = makeContainer();
      addTearDown(container.dispose);

      await container.read(
        printLabelLayoutDetailsControllerProvider(10).future,
      );
      final notifier = container.read(
        printLabelLayoutDetailsControllerProvider(10).notifier,
      );

      notifier.updateFieldDrawLabelBelowBarcode(0, true);
      var updated = container
          .read(printLabelLayoutDetailsControllerProvider(10))
          .value!;
      expect(updated.fields.first.drawLabelBelowBarcode, true);
    },
  );

  test('updateFieldPrefix should replace the prefix in previewValue', () async {
    final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
      code: 1,
      previewValue: 'Old prefixValue',
    ).copyWith(prefix: 'Old prefix');
    final initialLayout = EntityFactory.makeBSFPrintLabelLayoutEntity(
      code: 10,
      fields: [field],
    );
    when(
      () => repository.getDetails(params, 10),
    ).thenAnswer((_) async => initialLayout);
    final container = makeContainer();
    addTearDown(container.dispose);

    await container.read(printLabelLayoutDetailsControllerProvider(10).future);
    container
        .read(printLabelLayoutDetailsControllerProvider(10).notifier)
        .updateFieldPrefix(0, 'New prefix');

    final updatedField = container
        .read(printLabelLayoutDetailsControllerProvider(10))
        .requireValue
        .fields
        .first;
    expect(updatedField.prefix, 'New prefix');
    expect(updatedField.previewValue, 'New prefixValue');
  });

  test('updateFieldImageName should update the QR image name', () async {
    final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity().copyWith(
      imageName: 'old-name',
    );
    final initialLayout = EntityFactory.makeBSFPrintLabelLayoutEntity(
      code: 10,
      fields: [field],
    );
    when(
      () => repository.getDetails(params, 10),
    ).thenAnswer((_) async => initialLayout);
    final container = makeContainer();
    addTearDown(container.dispose);

    await container.read(printLabelLayoutDetailsControllerProvider(10).future);
    container
        .read(printLabelLayoutDetailsControllerProvider(10).notifier)
        .updateFieldImageName(0, 'new-name');

    expect(
      container
          .read(printLabelLayoutDetailsControllerProvider(10))
          .requireValue
          .fields
          .first
          .imageName,
      'new-name',
    );
  });

  test('updateName should update layout name', () async {
    final initialLayout = EntityFactory.makeBSFPrintLabelLayoutEntity(
      code: 10,
      name: 'Old Name',
    );
    when(
      () => repository.getDetails(params, 10),
    ).thenAnswer((_) async => initialLayout);
    final container = makeContainer();
    addTearDown(container.dispose);

    await container.read(printLabelLayoutDetailsControllerProvider(10).future);
    final notifier = container.read(
      printLabelLayoutDetailsControllerProvider(10).notifier,
    );

    notifier.updateName('New Name');
    final updated = container
        .read(printLabelLayoutDetailsControllerProvider(10))
        .value!;
    expect(updated.name, 'New Name');
  });

  test('updateTemperature should accept only supported values', () async {
    final initialLayout = EntityFactory.makeBSFPrintLabelLayoutEntity(
      code: 10,
      temperature: 12,
      labelPrinter: EntityFactory.makeBSFPrintLabelPrinterEntity(
        supportedTemperatures: const ['0', '12', '30'],
      ),
    );
    when(
      () => repository.getDetails(params, 10),
    ).thenAnswer((_) async => initialLayout);
    final container = makeContainer();
    addTearDown(container.dispose);

    await container.read(printLabelLayoutDetailsControllerProvider(10).future);
    final notifier = container.read(
      printLabelLayoutDetailsControllerProvider(10).notifier,
    );

    notifier.updateTemperature(30);
    var updated = container
        .read(printLabelLayoutDetailsControllerProvider(10))
        .value!;
    expect(updated.temperature, 30);

    notifier.updateTemperature(16);
    updated = container
        .read(printLabelLayoutDetailsControllerProvider(10))
        .value!;
    expect(updated.temperature, 30);

    notifier.updateTemperature(0);
    updated = container
        .read(printLabelLayoutDetailsControllerProvider(10))
        .value!;
    expect(updated.temperature, 0);
  });

  test('updatePrintSpeed should accept only supported values', () async {
    final initialLayout = EntityFactory.makeBSFPrintLabelLayoutEntity(
      code: 10,
      printSpeed: 2,
      labelPrinter: EntityFactory.makeBSFPrintLabelPrinterEntity(
        supportedPrintSpeeds: const ['2', '4', '6'],
      ),
    );
    when(
      () => repository.getDetails(params, 10),
    ).thenAnswer((_) async => initialLayout);
    final container = makeContainer();
    addTearDown(container.dispose);

    await container.read(printLabelLayoutDetailsControllerProvider(10).future);
    final notifier = container.read(
      printLabelLayoutDetailsControllerProvider(10).notifier,
    );

    notifier.updatePrintSpeed(6);
    var updated = container
        .read(printLabelLayoutDetailsControllerProvider(10))
        .value!;
    expect(updated.printSpeed, 6);

    notifier.updatePrintSpeed(5);
    updated = container
        .read(printLabelLayoutDetailsControllerProvider(10))
        .value!;
    expect(updated.printSpeed, 6);
  });

  test(
    'printer values should remain unchanged for a generic printer',
    () async {
      final initialLayout = EntityFactory.makeBSFPrintLabelLayoutEntity(
        code: 10,
        temperature: 12,
        printSpeed: 2,
        labelPrinter: EntityFactory.makeBSFPrintLabelPrinterEntity(
          isGeneric: true,
          modelType: BSFLabelPrinterModelType.generic,
          supportedTemperatures: const ['12', '30'],
          supportedPrintSpeeds: const ['2', '6'],
        ),
      );
      when(
        () => repository.getDetails(params, 10),
      ).thenAnswer((_) async => initialLayout);
      final container = makeContainer();
      addTearDown(container.dispose);
      await container.read(
        printLabelLayoutDetailsControllerProvider(10).future,
      );
      final notifier = container.read(
        printLabelLayoutDetailsControllerProvider(10).notifier,
      );

      notifier.updateTemperature(30);
      notifier.updatePrintSpeed(6);

      final updated = container
          .read(printLabelLayoutDetailsControllerProvider(10))
          .requireValue;
      expect(updated.temperature, 12);
      expect(updated.printSpeed, 2);
    },
  );

  test(
    'updateIntervalPrintPackage should update interval clamped at zero',
    () async {
      final initialLayout = EntityFactory.makeBSFPrintLabelLayoutEntity(
        code: 10,
        intervalPrintPackage: 100,
      );
      when(
        () => repository.getDetails(params, 10),
      ).thenAnswer((_) async => initialLayout);
      final container = makeContainer();
      addTearDown(container.dispose);

      await container.read(
        printLabelLayoutDetailsControllerProvider(10).future,
      );
      final notifier = container.read(
        printLabelLayoutDetailsControllerProvider(10).notifier,
      );

      notifier.updateIntervalPrintPackage(50);
      var updated = container
          .read(printLabelLayoutDetailsControllerProvider(10))
          .value!;
      expect(updated.intervalPrintPackage, 150);

      notifier.updateIntervalPrintPackage(-300);
      updated = container
          .read(printLabelLayoutDetailsControllerProvider(10))
          .value!;
      expect(updated.intervalPrintPackage, 0);
    },
  );

  test('updateFormType should apply legacy compatibility rules', () async {
    final cases = [
      (
        printer: EntityFactory.makeBSFPrintLabelPrinterEntity(
          modelType: BSFLabelPrinterModelType.generic,
          isGeneric: true,
        ),
        formType: BSFPrintLabelFormType.paginated,
        keepsHeight: true,
        keepsDirection: false,
        keepsFormSizeConfiguration: true,
      ),
      (
        printer: EntityFactory.makeBSFPrintLabelPrinterEntity(
          modelType: BSFLabelPrinterModelType.zebraGC420t,
        ),
        formType: BSFPrintLabelFormType.paginated,
        keepsHeight: true,
        keepsDirection: true,
        keepsFormSizeConfiguration: false,
      ),
      (
        printer: EntityFactory.makeBSFPrintLabelPrinterEntity(
          modelType: BSFLabelPrinterModelType.os214Plus,
        ),
        formType: BSFPrintLabelFormType.paginated,
        keepsHeight: false,
        keepsDirection: false,
        keepsFormSizeConfiguration: false,
      ),
      (
        printer: EntityFactory.makeBSFPrintLabelPrinterEntity(
          modelType: BSFLabelPrinterModelType.rabbitOS214,
        ),
        formType: BSFPrintLabelFormType.continuous,
        keepsHeight: true,
        keepsDirection: false,
        keepsFormSizeConfiguration: false,
      ),
    ];

    for (final testCase in cases) {
      final initialLayout = EntityFactory.makeBSFPrintLabelLayoutEntity(
        code: 10,
        formType: testCase.formType == BSFPrintLabelFormType.paginated
            ? BSFPrintLabelFormType.continuous
            : BSFPrintLabelFormType.paginated,
        formHeight: 40,
        labelHeight: 30,
        labelBottomMargin: 2,
        directionLabelType: BSFPrintLabelDirectionType.bottom,
        applyFormSizeConfiguration: false,
        labelPrinter: testCase.printer,
      );
      when(
        () => repository.getDetails(params, 10),
      ).thenAnswer((_) async => initialLayout);
      final container = makeContainer();

      await container.read(
        printLabelLayoutDetailsControllerProvider(10).future,
      );
      container
          .read(printLabelLayoutDetailsControllerProvider(10).notifier)
          .updateFormType(testCase.formType);
      final updated = container
          .read(printLabelLayoutDetailsControllerProvider(10))
          .requireValue;

      expect(updated.formType, testCase.formType);
      expect(updated.formHeight, testCase.keepsHeight ? 40 : 0);
      expect(updated.labelHeight, testCase.keepsHeight ? 30 : 0);
      expect(updated.labelBottomMargin, testCase.keepsHeight ? 2 : 0);
      expect(
        updated.directionLabelType,
        testCase.keepsDirection
            ? BSFPrintLabelDirectionType.bottom
            : BSFPrintLabelDirectionType.top,
      );
      expect(
        updated.applyFormSizeConfiguration,
        testCase.keepsFormSizeConfiguration ? false : true,
      );
      container.dispose();
    }
  });

  test(
    'updateFormHeight should resize the preview with a new layout',
    () async {
      final initialLayout = EntityFactory.makeBSFPrintLabelLayoutEntity(
        code: 10,
        formHeight: 30,
        labelHeight: 0,
      );
      when(
        () => repository.getDetails(params, 10),
      ).thenAnswer((_) async => initialLayout);
      final container = makeContainer();
      addTearDown(container.dispose);

      await container.read(
        printLabelLayoutDetailsControllerProvider(10).future,
      );
      final before = container
          .read(printLabelLayoutDetailsControllerProvider(10))
          .requireValue;
      container
          .read(printLabelLayoutDetailsControllerProvider(10).notifier)
          .updateFormHeight(5);
      final after = container
          .read(printLabelLayoutDetailsControllerProvider(10))
          .requireValue;

      expect(identical(after, before), isFalse);
      expect(after.formHeight, 35);
      expect(PrintLabelPreviewMetrics(after).canvasHeight, 35);
    },
  );

  test(
    'updateQuantityColumns should update and clamp between 1 and 99',
    () async {
      final initialLayout = EntityFactory.makeBSFPrintLabelLayoutEntity(
        code: 10,
        quantityColumns: 2,
      );
      when(
        () => repository.getDetails(params, 10),
      ).thenAnswer((_) async => initialLayout);
      final container = makeContainer();
      addTearDown(container.dispose);

      await container.read(
        printLabelLayoutDetailsControllerProvider(10).future,
      );
      final notifier = container.read(
        printLabelLayoutDetailsControllerProvider(10).notifier,
      );

      notifier.updateQuantityColumns(1);
      expect(
        container
            .read(printLabelLayoutDetailsControllerProvider(10))
            .requireValue
            .quantityColumns,
        3,
      );
      notifier.updateQuantityColumns(-100);
      expect(
        container
            .read(printLabelLayoutDetailsControllerProvider(10))
            .requireValue
            .quantityColumns,
        1,
      );
      notifier.updateQuantityColumns(100);
      expect(
        container
            .read(printLabelLayoutDetailsControllerProvider(10))
            .requireValue
            .quantityColumns,
        99,
      );
    },
  );

  test('updateAddressType should update addressType', () async {
    when(() => repository.getDetails(params, 10)).thenAnswer(
      (_) async => EntityFactory.makeBSFPrintLabelLayoutEntity(code: 10),
    );
    final container = makeContainer();
    addTearDown(container.dispose);
    await container.read(printLabelLayoutDetailsControllerProvider(10).future);

    container
        .read(printLabelLayoutDetailsControllerProvider(10).notifier)
        .updateAddressType(BSFPrintLabelAddressType.delivery);

    expect(
      container
          .read(printLabelLayoutDetailsControllerProvider(10))
          .requireValue
          .addressType,
      BSFPrintLabelAddressType.delivery,
    );
  });

  test(
    'updateDirectionLabelType should accept only supported values',
    () async {
      when(() => repository.getDetails(params, 10)).thenAnswer(
        (_) async => EntityFactory.makeBSFPrintLabelLayoutEntity(
          code: 10,
          labelPrinter: EntityFactory.makeBSFPrintLabelPrinterEntity(
            modelType: BSFLabelPrinterModelType.zebraGC420t,
            supportedDirections: const [
              BSFPrintLabelDirectionType.top,
              BSFPrintLabelDirectionType.bottom,
            ],
          ),
        ),
      );
      final container = makeContainer();
      addTearDown(container.dispose);
      await container.read(
        printLabelLayoutDetailsControllerProvider(10).future,
      );

      container
          .read(printLabelLayoutDetailsControllerProvider(10).notifier)
          .updateDirectionLabelType(BSFPrintLabelDirectionType.bottom);

      expect(
        container
            .read(printLabelLayoutDetailsControllerProvider(10))
            .requireValue
            .directionLabelType,
        BSFPrintLabelDirectionType.bottom,
      );

      container
          .read(printLabelLayoutDetailsControllerProvider(10).notifier)
          .updateDirectionLabelType(BSFPrintLabelDirectionType.left);

      expect(
        container
            .read(printLabelLayoutDetailsControllerProvider(10))
            .requireValue
            .directionLabelType,
        BSFPrintLabelDirectionType.bottom,
      );
    },
  );

  test('updatePrintProductBySoldQuantity should update its flag', () async {
    when(() => repository.getDetails(params, 10)).thenAnswer(
      (_) async => EntityFactory.makeBSFPrintLabelLayoutEntity(code: 10),
    );
    final container = makeContainer();
    addTearDown(container.dispose);
    await container.read(printLabelLayoutDetailsControllerProvider(10).future);

    container
        .read(printLabelLayoutDetailsControllerProvider(10).notifier)
        .updatePrintProductBySoldQuantity(true);

    expect(
      container
          .read(printLabelLayoutDetailsControllerProvider(10))
          .requireValue
          .printProductBySoldQuantity,
      isTrue,
    );
  });

  test(
    'updateGoesForBalanceAndQuantityInBalance should update its flag',
    () async {
      when(() => repository.getDetails(params, 10)).thenAnswer(
        (_) async => EntityFactory.makeBSFPrintLabelLayoutEntity(code: 10),
      );
      final container = makeContainer();
      addTearDown(container.dispose);
      await container.read(
        printLabelLayoutDetailsControllerProvider(10).future,
      );

      container
          .read(printLabelLayoutDetailsControllerProvider(10).notifier)
          .updateGoesForBalanceAndQuantityInBalance(true);

      expect(
        container
            .read(printLabelLayoutDetailsControllerProvider(10))
            .requireValue
            .goesForBalanceAndQuantityInBalance,
        isTrue,
      );
    },
  );

  test('updateFormWidth and margins should update form dimensions', () async {
    final initialLayout = EntityFactory.makeBSFPrintLabelLayoutEntity(
      code: 10,
      formWidth: 100.0,
      formTopMargin: 5.0,
      formLeftMargin: 5.0,
      applyFormSizeConfiguration: false,
    );
    when(
      () => repository.getDetails(params, 10),
    ).thenAnswer((_) async => initialLayout);
    final container = makeContainer();
    addTearDown(container.dispose);

    await container.read(printLabelLayoutDetailsControllerProvider(10).future);
    final notifier = container.read(
      printLabelLayoutDetailsControllerProvider(10).notifier,
    );

    notifier.updateFormWidth(10.0);
    notifier.updateFormTopMargin(2.5);
    notifier.updateFormLeftMargin(1.5);
    notifier.updateApplyFormSizeConfiguration(true);

    final updated = container
        .read(printLabelLayoutDetailsControllerProvider(10))
        .value!;
    expect(updated.formWidth, 110.0);
    expect(updated.formTopMargin, 7.5);
    expect(updated.formLeftMargin, 6.5);
    expect(updated.applyFormSizeConfiguration, true);
  });

  test(
    'updateLabelWidth, height and margins should update label dimensions',
    () async {
      final initialLayout = EntityFactory.makeBSFPrintLabelLayoutEntity(
        code: 10,
        labelWidth: 50.0,
        labelHeight: 30.0,
        labelRightMargin: 2.0,
        labelBottomMargin: 2.0,
        considerProductPacking: BSFProductPackingSelectionType.onlyUnitary,
        informPrintQuantityByProduct: false,
      );
      when(
        () => repository.getDetails(params, 10),
      ).thenAnswer((_) async => initialLayout);
      final container = makeContainer();
      addTearDown(container.dispose);

      await container.read(
        printLabelLayoutDetailsControllerProvider(10).future,
      );
      final notifier = container.read(
        printLabelLayoutDetailsControllerProvider(10).notifier,
      );

      notifier.updateLabelWidth(5.0);
      notifier.updateLabelHeight(10.0);
      notifier.updateLabelRightMargin(1.0);
      notifier.updateLabelBottomMargin(1.0);
      notifier.updateConsiderProductPacking(
        BSFProductPackingSelectionType.both,
      );
      notifier.updateInformPrintQuantityByProduct(true);

      final updated = container
          .read(printLabelLayoutDetailsControllerProvider(10))
          .value!;
      expect(updated.labelWidth, 55.0);
      expect(updated.labelHeight, 40.0);
      expect(updated.labelRightMargin, 3.0);
      expect(updated.labelBottomMargin, 3.0);
      expect(
        updated.considerProductPacking,
        BSFProductPackingSelectionType.both,
      );
      expect(updated.informPrintQuantityByProduct, true);
    },
  );

  test('character positions should not decrease below one', () async {
    final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
      code: 1,
    ).copyWith(positionStartCharacter: 1, maxCharacterSize: 1);
    final initialLayout = EntityFactory.makeBSFPrintLabelLayoutEntity(
      code: 10,
      fields: [field],
    );
    when(
      () => repository.getDetails(params, 10),
    ).thenAnswer((_) async => initialLayout);
    final container = makeContainer();
    addTearDown(container.dispose);

    await container.read(printLabelLayoutDetailsControllerProvider(10).future);
    final notifier = container.read(
      printLabelLayoutDetailsControllerProvider(10).notifier,
    );

    notifier.updateFieldPositionStartCharacter(0, -1);
    notifier.updateFieldMaxCharacterSize(0, -1);

    final updated = container
        .read(printLabelLayoutDetailsControllerProvider(10))
        .requireValue
        .fields
        .first;
    expect(updated.positionStartCharacter, 1);
    expect(updated.maxCharacterSize, 0);
  });

  test(
    'replaceFieldDefinition should replace by index and preserve only prefix',
    () async {
      final first = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
        code: 0,
      ).copyWith(prefix: 'first', imageName: 'old-image');
      final second = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
        code: 0,
      ).copyWith(prefix: 'second');
      final replacement = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
        code: 0,
      ).copyWith(prefix: 'server-prefix', imageName: 'server-image');
      final initialLayout = EntityFactory.makeBSFPrintLabelLayoutEntity(
        code: 10,
        fields: [first, second],
      );
      when(
        () => repository.getDetails(params, 10),
      ).thenAnswer((_) async => initialLayout);
      final container = makeContainer();
      addTearDown(container.dispose);

      await container.read(
        printLabelLayoutDetailsControllerProvider(10).future,
      );
      container
          .read(printLabelLayoutDetailsControllerProvider(10).notifier)
          .replaceFieldDefinition(1, replacement);

      final fields = container
          .read(printLabelLayoutDetailsControllerProvider(10))
          .requireValue
          .fields;
      expect(fields.first, first);
      expect(fields.last.code, 0);
      expect(fields.last.prefix, 'second');
      expect(fields.last.imageName, 'server-image');
    },
  );

  test('addField should append the unchanged server draft', () async {
    final draft = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(code: 0);
    final initialLayout = EntityFactory.makeBSFPrintLabelLayoutEntity(
      code: 10,
      fields: [EntityFactory.makeBSFPrintLabelLayoutFieldEntity(code: -1)],
    );
    when(
      () => repository.getDetails(params, 10),
    ).thenAnswer((_) async => initialLayout);
    final container = makeContainer();
    addTearDown(container.dispose);

    await container.read(printLabelLayoutDetailsControllerProvider(10).future);
    container
        .read(printLabelLayoutDetailsControllerProvider(10).notifier)
        .addField(draft);

    final added = container
        .read(printLabelLayoutDetailsControllerProvider(10))
        .requireValue
        .fields
        .last;
    expect(added, draft);
  });

  final removalCases = <({String name, int index, List<String> remaining})>[
    (name: 'first', index: 0, remaining: ['middle', 'last']),
    (name: 'middle', index: 1, remaining: ['first', 'last']),
    (name: 'last', index: 2, remaining: ['first', 'middle']),
  ];

  for (final testCase in removalCases) {
    test(
      'removeField should remove the ${testCase.name} field by index',
      () async {
        final initialLayout = EntityFactory.makeBSFPrintLabelLayoutEntity(
          code: 10,
          fields: [
            EntityFactory.makeBSFPrintLabelLayoutFieldEntity().copyWith(
              prefix: 'first',
            ),
            EntityFactory.makeBSFPrintLabelLayoutFieldEntity().copyWith(
              prefix: 'middle',
            ),
            EntityFactory.makeBSFPrintLabelLayoutFieldEntity().copyWith(
              prefix: 'last',
            ),
          ],
        );
        when(
          () => repository.getDetails(params, 10),
        ).thenAnswer((_) async => initialLayout);
        final container = makeContainer();
        addTearDown(container.dispose);

        await container.read(
          printLabelLayoutDetailsControllerProvider(10).future,
        );
        container
            .read(printLabelLayoutDetailsControllerProvider(10).notifier)
            .removeField(testCase.index);

        final remainingPrefixes = container
            .read(printLabelLayoutDetailsControllerProvider(10))
            .requireValue
            .fields
            .map((field) => field.prefix)
            .toList();
        expect(remainingPrefixes, testCase.remaining);
      },
    );
  }

  test(
    'removeField should distinguish duplicate code-zero fields by index',
    () async {
      final initialLayout = EntityFactory.makeBSFPrintLabelLayoutEntity(
        code: 10,
        fields: [
          EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
            code: 0,
          ).copyWith(prefix: 'keep'),
          EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
            code: 0,
          ).copyWith(prefix: 'remove'),
        ],
      );
      when(
        () => repository.getDetails(params, 10),
      ).thenAnswer((_) async => initialLayout);
      final container = makeContainer();
      addTearDown(container.dispose);

      await container.read(
        printLabelLayoutDetailsControllerProvider(10).future,
      );
      container
          .read(printLabelLayoutDetailsControllerProvider(10).notifier)
          .removeField(1);

      final fields = container
          .read(printLabelLayoutDetailsControllerProvider(10))
          .requireValue
          .fields;
      expect(fields, hasLength(1));
      expect(fields.single.prefix, 'keep');
      expect(fields.single.code, 0);
    },
  );

  test('replaceWithSavedLayout should apply refreshed server state', () async {
    final updated = layout.copyWith(name: 'Server name');
    when(
      () => repository.getDetails(params, layout.code),
    ).thenAnswer((_) async => layout);
    final container = makeContainer();
    addTearDown(container.dispose);
    final provider = printLabelLayoutDetailsControllerProvider(layout.code);
    await container.read(provider.future);

    container.read(provider.notifier).replaceWithSavedLayout(updated);

    expect(container.read(provider).requireValue, updated);
  });
}
