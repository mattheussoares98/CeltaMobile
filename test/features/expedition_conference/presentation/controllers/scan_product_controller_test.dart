import 'dart:async';

import 'package:celta_inventario/exceptions/exceptions.dart';
import 'package:celta_inventario/features/expedition_conference/domain/entities/entities.dart';
import 'package:celta_inventario/features/expedition_conference/presentation/controllers/controllers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// --- Spies and Fakes ---

/// Spy for the data controller to verify state updates.
class SpyExpeditionConferenceController extends ExpeditionConferenceController {
  final ExpeditionConferenceState initialState;
  ExpeditionConferenceState? capturedUpdatedState;

  SpyExpeditionConferenceController(this.initialState);

  @override
  FutureOr<ExpeditionConferenceState> build(int expeditionControlCode) =>
      initialState;

  @override
  void updateState(ExpeditionConferenceState newState) {
    capturedUpdatedState = newState;
    state = AsyncData(newState);
  }
}

/// Spy for the confirmation controller to verify side effects.
class SpyConfirmConferenceController extends ConfirmConferenceController {
  bool confirmCalled = false;
  int? capturedControlCode;
  int? capturedStepCode;

  @override
  FutureOr<void> build() {}

  @override
  Future<bool> confirm({
    required int expeditionControlCode,
    required int stepCode,
  }) async {
    confirmCalled = true;
    capturedControlCode = expeditionControlCode;
    capturedStepCode = stepCode;
    return true;
  }
}

void main() {
  late ProviderContainer container;
  late SpyExpeditionConferenceController spyDataController;
  late SpyConfirmConferenceController spyConfirmController;

  late int fakeControlCode;
  late int fakeStepCode;
  late int fakePackingCode;
  late ExpeditionConferenceState fakeInitialState;

  setUpAll(() {
    registerFallbackValue(const AsyncLoading<void>());
  });

  setUp(() {
    fakeControlCode = faker.randomGenerator.integer(1000);
    fakeStepCode = faker.randomGenerator.integer(10);
    fakePackingCode = faker.randomGenerator.integer(10000);

    // Create an initial state where the scanned product is pending.
    fakeInitialState = ExpeditionConferenceState(
      initialProducts: const [],
      pendingQuantities: {fakePackingCode: 10.0},
      scannedQuantities: {fakePackingCode: 0.0},
    );

    spyDataController = SpyExpeditionConferenceController(fakeInitialState);
    spyConfirmController = SpyConfirmConferenceController();
  });

  /// Helper to create the container with mocked dependencies.
  ProviderContainer makeProviderContainer() {
    return ProviderContainer(
      overrides: [
        expeditionConferenceControllerProvider(
          fakeControlCode,
        ).overrideWith(() => spyDataController),
        confirmConferenceControllerProvider.overrideWith(
          () => spyConfirmController,
        ),
      ],
    );
  }

  group('ScanProductController', () {
    test('should update local quantities correctly on a valid scan', () async {
      // Arrange
      container = makeProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(scanProductControllerProvider.notifier);

      // Act
      final succeeds = await notifier.scan(
        expeditionControlCode: fakeControlCode,
        productPackingCode: fakePackingCode,
        stepCode: fakeStepCode,
      );

      expect(succeeds, isTrue);

      // Assert
      final finalState = container.read(scanProductControllerProvider);

      // 1. Verify the action controller completed successfully.
      expect(finalState, isA<AsyncData>());

      // 2. Verify that the data controller's state was updated with decremented pending quantity.
      expect(spyDataController.capturedUpdatedState, isNotNull);
      expect(
        spyDataController
            .capturedUpdatedState!
            .pendingQuantities[fakePackingCode],
        9.0,
      );
      expect(
        spyDataController
            .capturedUpdatedState!
            .scannedQuantities[fakePackingCode],
        1.0,
      );

      // 3. Verify confirmation was NOT triggered yet.
      expect(spyConfirmController.confirmCalled, isFalse);
    });

    test(
      'should trigger confirmation side effect when the conference is completed',
      () async {
        // Arrange: Set up state with only 1 item remaining.
        final stateNearCompletion = ExpeditionConferenceState(
          initialProducts: const [],
          pendingQuantities: {fakePackingCode: 1.0},
          scannedQuantities: {fakePackingCode: 0.0},
        );
        spyDataController = SpyExpeditionConferenceController(
          stateNearCompletion,
        );

        container = makeProviderContainer();
        addTearDown(container.dispose);

        // Act: Scan the last remaining item.
        final succeeds = await container
            .read(scanProductControllerProvider.notifier)
            .scan(
              expeditionControlCode: fakeControlCode,
              productPackingCode: fakePackingCode,
              stepCode: fakeStepCode,
            );
        expect(succeeds, isTrue);

        // Assert
        // 1. Verify that the confirmation logic was called.
        expect(spyConfirmController.confirmCalled, isTrue);
        expect(spyConfirmController.capturedControlCode, fakeControlCode);
        expect(spyConfirmController.capturedStepCode, fakeStepCode);
      },
    );

    test(
      'should emit AsyncError (AppException) if product is not in the pending list',
      () async {
        // Arrange: Data controller has no record of the scanned packing code.
        spyDataController = SpyExpeditionConferenceController(
          const ExpeditionConferenceState(
            initialProducts: [],
            pendingQuantities: {},
            scannedQuantities: {},
          ),
        );

        container = makeProviderContainer();
        addTearDown(container.dispose);

        // Act
        final succeeds = await container
            .read(scanProductControllerProvider.notifier)
            .scan(
              expeditionControlCode: fakeControlCode,
              productPackingCode: fakePackingCode,
              stepCode: fakeStepCode,
            );
        expect(succeeds, isFalse);

        // Assert
        final state = container.read(scanProductControllerProvider);

        // 1. Verify error emission.
        expect(state, isA<AsyncError>());
        expect(state.error, isA<AppException>());
        expect(state.error.toString(), contains('não está pendente'));

        // 2. Verify that the data controller was never updated.
        expect(spyDataController.capturedUpdatedState, isNull);
      },
    );

    test(
      'should emit AsyncError (AppException) if the pending quantity is already zero',
      () async {
        // Arrange: Product is known but has 0 quantity pending.
        spyDataController = SpyExpeditionConferenceController(
          ExpeditionConferenceState(
            initialProducts: const [],
            pendingQuantities: {fakePackingCode: 0.0},
            scannedQuantities: {fakePackingCode: 10.0},
          ),
        );

        container = makeProviderContainer();
        addTearDown(container.dispose);

        // Act
        final succeeds = await container
            .read(scanProductControllerProvider.notifier)
            .scan(
              expeditionControlCode: fakeControlCode,
              productPackingCode: fakePackingCode,
              stepCode: fakeStepCode,
            );
        expect(succeeds, isFalse);

        // Assert
        final state = container.read(scanProductControllerProvider);
        expect(state.hasError, isTrue);
        expect(spyDataController.capturedUpdatedState, isNull);
      },
    );
  });
}
