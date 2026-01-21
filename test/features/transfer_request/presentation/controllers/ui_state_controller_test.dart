import 'dart:async';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/request_type/request_type.dart';
import 'package:celta_inventario/features/transfer_request/presentation/controllers/ui_state_controller.dart';
import 'package:celta_inventario/features/transfer_request/presentation/models/models.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class SpyRequestTypeStateController extends RequestTypeStateController {
  final List<RequestTypeEntity>? requestsToReturn;
  SpyRequestTypeStateController(this.requestsToReturn);

  @override
  FutureOr<List<RequestTypeEntity>?> build(Modules module) async {
    return requestsToReturn;
  }
}

void main() {
  late int requestTypeCode;
  late List<RequestTypeEntity> fakeRequests;

  setUpAll(() {
    // Registering fallback for AsyncValue if using verify with any()
    registerFallbackValue(const AsyncLoading<UiModel>());
  });

  setUp(() {
    requestTypeCode = faker.randomGenerator.integer(1000);

    // Generating a list of fake request types
    fakeRequests = List.generate(3, (index) {
      return EntityFactory.makeRequestTypeEntity(
        Code: index == 0
            ? requestTypeCode
            : faker.randomGenerator.integer(1000, min: 100),
        AllowAlterCostOrSalePrice: faker.randomGenerator.boolean(),
      );
    });
  });

  ProviderContainer makeProviderContainer({
    List<RequestTypeEntity>? requestTypes,
  }) {
    return ProviderContainer(
      overrides: [
        requestTypeStateControllerProvider(
          Modules.transferRequest,
        ).overrideWith(() => SpyRequestTypeStateController(requestTypes ?? [])),
      ],
    );
  }

  group('UiStateController build', () {
    test(
      'should initialize with allowChangePrice true when request code matches and allows it',
      () async {
        // ARRANGE
        final targetRequest = EntityFactory.makeRequestTypeEntity(
          Code: requestTypeCode,
          AllowAlterCostOrSalePrice: true,
        );
        final container = makeProviderContainer(requestTypes: [targetRequest]);
        addTearDown(container.dispose);

        // ACT
        final result = await container.read(
          uiStateControllerProvider(requestTypeCode).future,
        );

        // ASSERT
        expect(result.requestTypeAllowChangePrice, isTrue);
        expect(result.selectedInsertProductIndex, null);
        expect(result.selectedCartProductIndex, null);
      },
    );

    test(
      'should initialize with allowChangePrice false when request code is not found',
      () async {
        // ARRANGE
        final container = makeProviderContainer(requestTypes: []);
        addTearDown(container.dispose);

        // ACT
        final result = await container.read(
          uiStateControllerProvider(requestTypeCode).future,
        );

        // ASSERT
        expect(result.requestTypeAllowChangePrice, isFalse);
        expect(result.selectedInsertProductIndex, null);
        expect(result.selectedCartProductIndex, null);
      },
    );
  });

  group('UiStateController Actions', () {
    test('updatePageIndex should update the pageIndex in state', () async {
      // ARRANGE
      final container = makeProviderContainer(requestTypes: fakeRequests);
      addTearDown(container.dispose);

      final newPageIndex = faker.randomGenerator.integer(10);

      // Wait for build
      await container.read(uiStateControllerProvider(requestTypeCode).future);

      // ACT
      container
          .read(uiStateControllerProvider(requestTypeCode).notifier)
          .updatePageIndex(newPageIndex);

      // ASSERT
      final state = container
          .read(uiStateControllerProvider(requestTypeCode))
          .value;
      expect(state?.pageIndex, newPageIndex);
    });

    test(
      'updateSelectedInsertProductIndex should set index and handle annulment',
      () async {
        // ARRANGE
        final container = makeProviderContainer(requestTypes: fakeRequests);
        addTearDown(container.dispose);
        await container.read(uiStateControllerProvider(requestTypeCode).future);

        final notifier = container.read(
          uiStateControllerProvider(requestTypeCode).notifier,
        );
        final selectionIndex = faker.randomGenerator.integer(50, min: 1);

        // ACT 1: Selection
        notifier.updateSelectedInsertProductIndex(selectionIndex);

        // ASSERT 1
        expect(
          container
              .read(uiStateControllerProvider(requestTypeCode))
              .value
              ?.selectedInsertProductIndex,
          selectionIndex,
        );

        // ACT 2: Toggle off (same index)
        notifier.updateSelectedInsertProductIndex(selectionIndex);

        // ASSERT 2: Should annul (based on your copyWith logic)
        expect(
          container
              .read(uiStateControllerProvider(requestTypeCode))
              .value
              ?.selectedInsertProductIndex,
          isNull,
        );
      },
    );

    test(
      'updateSelectedCartProductIndex should set index and handle annulment',
      () async {
        // ARRANGE
        final container = makeProviderContainer(requestTypes: fakeRequests);
        addTearDown(container.dispose);
        await container.read(uiStateControllerProvider(requestTypeCode).future);

        final notifier = container.read(
          uiStateControllerProvider(requestTypeCode).notifier,
        );
        final selectionIndex = faker.randomGenerator.integer(50);

        // ACT 1: Selection
        notifier.updateSelectedCartProductIndex(selectionIndex);

        // ASSERT 1
        expect(
          container
              .read(uiStateControllerProvider(requestTypeCode))
              .value
              ?.selectedCartProductIndex,
          selectionIndex,
        );

        // ACT 2: Null index passed
        notifier.updateSelectedCartProductIndex(null);

        // ASSERT 2
        expect(
          container
              .read(uiStateControllerProvider(requestTypeCode))
              .value
              ?.selectedCartProductIndex,
          isNull,
        );
      },
    );
  });
}
