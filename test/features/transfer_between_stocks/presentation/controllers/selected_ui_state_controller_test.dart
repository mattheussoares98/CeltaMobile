import 'package:celta_intelligence/features/transfer_between_stocks/domain/entities/entities.dart';
import 'package:celta_intelligence/features/transfer_between_stocks/presentation/controllers/controllers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:faker/faker.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ProviderContainer container;
  late int fakeEnterpriseCode;

  setUp(() {
    fakeEnterpriseCode = faker.randomGenerator.integer(1000);
    container = ProviderContainer();
    addTearDown(container.dispose);
  });

  group('SelectedUIStateController', () {
    test('build should return an empty state initially', () {
      // Act
      final state = container.read(
        selectedUIStateControllerProvider(fakeEnterpriseCode),
      );

      // Assert
      expect(state, SelectedUIStateEntity.empty());
    });

    test(
      'updateValues should update all fields correctly when index is new',
      () {
        // Arrange
        final justification = EntityFactory.makeTransferJustificationEntity();
        final originStock = EntityFactory.makeStockTypeEntity();
        final destinyStock = EntityFactory.makeStockTypeEntity();
        final productIndex = faker.randomGenerator.integer(100);

        final notifier = container.read(
          selectedUIStateControllerProvider(fakeEnterpriseCode).notifier,
        );

        // Act
        notifier.updateValues(
          justification: justification,
          originStock: originStock,
          destinyStock: destinyStock,
          productIndex: productIndex,
        );

        // Assert
        final state = container.read(
          selectedUIStateControllerProvider(fakeEnterpriseCode),
        );

        expect(state.selectedJustification, justification);
        expect(state.selectedOriginStock, originStock);
        expect(state.selectedDestinyStock, destinyStock);
        expect(state.productIndex, productIndex);
      },
    );

    test(
      'updateValues should toggle productIndex to null using annulValues when same index is passed',
      () {
        // Arrange
        final productIndex = faker.randomGenerator.integer(100);
        final notifier = container.read(
          selectedUIStateControllerProvider(fakeEnterpriseCode).notifier,
        );

        // Set initial index
        notifier.updateValues(
          justification: null,
          originStock: null,
          destinyStock: null,
          productIndex: productIndex,
        );
        expect(
          container
              .read(selectedUIStateControllerProvider(fakeEnterpriseCode))
              .productIndex,
          productIndex,
        );

        // Act
        // Passing the same index should trigger the toggle to null
        notifier.updateValues(
          justification: null,
          originStock: null,
          destinyStock: null,
          productIndex: productIndex,
        );

        // Assert
        final state = container.read(
          selectedUIStateControllerProvider(fakeEnterpriseCode),
        );
        expect(state.productIndex, isNull);
      },
    );

    test(
      'updateValues should change to a different productIndex without nulling',
      () {
        // Arrange
        const firstIndex = 1;
        const secondIndex = 2;
        final notifier = container.read(
          selectedUIStateControllerProvider(fakeEnterpriseCode).notifier,
        );

        // Set first index
        notifier.updateValues(
          justification: null,
          originStock: null,
          destinyStock: null,
          productIndex: firstIndex,
        );

        // Act
        // Passing a different index should update the value
        notifier.updateValues(
          justification: null,
          originStock: null,
          destinyStock: null,
          productIndex: secondIndex,
        );

        // Assert
        final state = container.read(
          selectedUIStateControllerProvider(fakeEnterpriseCode),
        );
        expect(state.productIndex, secondIndex);
      },
    );

    test(
      'updateValues should correctly handle passing null explicitly as productIndex',
      () {
        // Arrange
        final initialIndex = faker.randomGenerator.integer(100);
        final notifier = container.read(
          selectedUIStateControllerProvider(fakeEnterpriseCode).notifier,
        );

        notifier.updateValues(
          justification: null,
          originStock: null,
          destinyStock: null,
          productIndex: initialIndex,
        );

        // Act
        // Passing null when a value exists should set it to null
        notifier.updateValues(
          justification: null,
          originStock: null,
          destinyStock: null,
          productIndex: null,
        );

        // Assert
        final state = container.read(
          selectedUIStateControllerProvider(fakeEnterpriseCode),
        );
        expect(state.productIndex, isNull);
      },
    );
  });
}
