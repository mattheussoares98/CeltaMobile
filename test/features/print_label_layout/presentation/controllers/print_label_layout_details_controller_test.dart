import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/domain/repositories/repositories.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/controllers/controllers.dart';
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

  test('updateFieldCoordinateX should update coordinateX and clamp at zero', () async {
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

    await container.read(printLabelLayoutDetailsControllerProvider(10).future);
    final notifier = container.read(
      printLabelLayoutDetailsControllerProvider(10).notifier,
    );

    notifier.updateFieldCoordinateX(1, 0.5);
    var updated = container
        .read(printLabelLayoutDetailsControllerProvider(10))
        .value!;
    expect(updated.fields.first.coordinateX, 2.5);

    notifier.updateFieldCoordinateX(1, -3.0);
    updated = container
        .read(printLabelLayoutDetailsControllerProvider(10))
        .value!;
    expect(updated.fields.first.coordinateX, 0.0);
  });

  test('updateFieldCoordinateY should update coordinateY and clamp at zero', () async {
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

    await container.read(printLabelLayoutDetailsControllerProvider(10).future);
    final notifier = container.read(
      printLabelLayoutDetailsControllerProvider(10).notifier,
    );

    notifier.updateFieldCoordinateY(1, 0.2);
    var updated = container
        .read(printLabelLayoutDetailsControllerProvider(10))
        .value!;
    expect(updated.fields.first.coordinateY, 1.7);

    notifier.updateFieldCoordinateY(1, -2.0);
    updated = container
        .read(printLabelLayoutDetailsControllerProvider(10))
        .value!;
    expect(updated.fields.first.coordinateY, 0.0);
  });

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

    notifier.updateFieldWidth(1, 1.0);
    var updated = container
        .read(printLabelLayoutDetailsControllerProvider(10))
        .value!;
    expect(updated.fields.first.width, 5.0);

    notifier.updateFieldWidth(1, -10.0);
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

    notifier.updateFieldHeight(1, 0.5);
    var updated = container
        .read(printLabelLayoutDetailsControllerProvider(10))
        .value!;
    expect(updated.fields.first.height, 3.5);

    notifier.updateFieldHeight(1, -5.0);
    updated = container
        .read(printLabelLayoutDetailsControllerProvider(10))
        .value!;
    expect(updated.fields.first.height, 0.0);
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

      notifier.updateFieldRatioBarCode(1, 5.0);
      var updated = container
          .read(printLabelLayoutDetailsControllerProvider(10))
          .value!;
      expect(updated.fields.first.ratioBarCode, 80.0);

      notifier.updateFieldRatioBarCode(1, -100.0);
      updated = container
          .read(printLabelLayoutDetailsControllerProvider(10))
          .value!;
      expect(updated.fields.first.ratioBarCode, 0.0);
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

    notifier.toggleFieldVisibility(1);
    var updated = container
        .read(printLabelLayoutDetailsControllerProvider(10))
        .value!;
    expect(updated.fields.first.isVisible, false);

    notifier.toggleFieldVisibility(1);
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

    notifier.updateFieldRotateType(1, BSFPrintElementRotationType.rotate90);
    var updated = container
        .read(printLabelLayoutDetailsControllerProvider(10))
        .value!;
    expect(updated.fields.first.rotateType, BSFPrintElementRotationType.rotate90);
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

      notifier.updateFieldDrawLabelBelowBarcode(1, true);
      var updated = container
          .read(printLabelLayoutDetailsControllerProvider(10))
          .value!;
      expect(updated.fields.first.drawLabelBelowBarcode, true);
    },
  );
}
