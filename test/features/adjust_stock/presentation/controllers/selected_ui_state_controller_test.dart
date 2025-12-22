import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/features/adjust_stock/domain/entities/entities.dart';
import 'package:celta_intelligence/features/adjust_stock/presentation/controllers/controllers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ProviderContainer container;
  late Faker fakerInstance;
  late TransferJustificationEntity? selectedJustification;
  late StockTypeEntity? selectedStockType;

  setUp(() {
    container = ProviderContainer();
    fakerInstance = Faker();
    addTearDown(container.dispose);

    selectedJustification = EntityFactory.makeTransferJustificationEntity();
    selectedStockType = EntityFactory.makeStockTypeEntity();
  });

  group('SelectedUIStateController', () {
    test(
      'build should return SelectedItemUIState.empty() as initial state',
      () {
        // Act
        final state = container.read(selectedUIStateControllerProvider);

        // Assert
        expect(state, SelectedItemUIState.empty());
        expect(state.selectedIndex, isNull);
      },
    );

    test(
      'udpateValues should replace the current state with the provided value',
      () {
        // Arrange
        final notifier = container.read(
          selectedUIStateControllerProvider.notifier,
        );
        final newState = SelectedItemUIState(
          selectedIndex: fakerInstance.randomGenerator.integer(100),
          selectedJustification: selectedJustification,
          selectedStockType: selectedStockType,
        );

        final states = <SelectedItemUIState>[];
        container.listen(
          selectedUIStateControllerProvider,
          (_, next) => states.add(next),
        );

        // Act
        notifier.udpateValues(newState);

        // Assert
        // 1. Verify the state was updated in the container
        expect(container.read(selectedUIStateControllerProvider), newState);

        // 2. Verify the listener captured exactly one change
        expect(states, [newState]);
      },
    );

    test(
      'multiple udpateValues calls should result in the last provided state',
      () {
        // Arrange
        final notifier = container.read(
          selectedUIStateControllerProvider.notifier,
        );
        final firstState = SelectedItemUIState(
          selectedIndex: fakerInstance.randomGenerator.integer(10),
          selectedJustification:
              EntityFactory.makeTransferJustificationEntity(),
          selectedStockType: EntityFactory.makeStockTypeEntity(),
        );
        final secondState = SelectedItemUIState(
          selectedIndex: fakerInstance.randomGenerator.integer(20, min: 11),
          selectedJustification:
              EntityFactory.makeTransferJustificationEntity(),
          selectedStockType: EntityFactory.makeStockTypeEntity(),
        );

        // Act
        notifier.udpateValues(firstState);
        notifier.udpateValues(secondState);

        // Assert
        final finalState = container.read(selectedUIStateControllerProvider);
        expect(finalState, secondState);
        expect(finalState.selectedIndex, isNot(firstState.selectedIndex));
      },
    );
    test('should annul the selectedIndex if pass the same value as param', () {
      // Arrange
      final notifier = container.read(
        selectedUIStateControllerProvider.notifier,
      );
      final state = SelectedItemUIState(
        selectedIndex: fakerInstance.randomGenerator.integer(10),
        selectedJustification: EntityFactory.makeTransferJustificationEntity(),
        selectedStockType: EntityFactory.makeStockTypeEntity(),
      );

      // Act
      notifier.udpateValues(state);
      final firstState = container.read(selectedUIStateControllerProvider);
      expect(firstState.selectedIndex, isNotNull);

      notifier.udpateValues(state);
      final secondState = container.read(selectedUIStateControllerProvider);
      expect(secondState.selectedIndex, isNull);
    });
  });
}
