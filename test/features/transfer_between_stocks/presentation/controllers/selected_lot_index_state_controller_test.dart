import 'package:celta_inventario/features/transfer_between_stocks/presentation/controllers/controllers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(retry: (retryCount, error) => null);
    addTearDown(container.dispose);
  });

  group('SelectedLotIndexStateController', () {
    test('build should return null initially', () {
      // Act
      final state = container.read(selectedLotIndexStateControllerProvider);

      // Assert
      expect(state, isNull);
    });

    test(
      'updateIndex should set the state to the new index when currently null',
      () {
        // Arrange
        final newIndex = faker.randomGenerator.integer(100);
        final notifier = container.read(
          selectedLotIndexStateControllerProvider.notifier,
        );

        // Act
        notifier.updateIndex(newIndex);

        // Assert
        final state = container.read(selectedLotIndexStateControllerProvider);
        expect(state, newIndex);
      },
    );

    test(
      'updateIndex should toggle state to null if the same index is passed',
      () {
        // Arrange
        final indexToToggle = faker.randomGenerator.integer(100);
        final notifier = container.read(
          selectedLotIndexStateControllerProvider.notifier,
        );

        // Set initial index
        notifier.updateIndex(indexToToggle);
        expect(
          container.read(selectedLotIndexStateControllerProvider),
          indexToToggle,
        );

        // Act
        // Passing the same index should trigger the toggle logic
        notifier.updateIndex(indexToToggle);

        // Assert
        final state = container.read(selectedLotIndexStateControllerProvider);
        expect(state, isNull);
      },
    );

    test(
      'updateIndex should change to a different index if a different one is passed',
      () {
        // Arrange
        const firstIndex = 10;
        const secondIndex = 20;
        final notifier = container.read(
          selectedLotIndexStateControllerProvider.notifier,
        );

        // Set first index
        notifier.updateIndex(firstIndex);

        // Act
        // Passing a different index should simply update the state
        notifier.updateIndex(secondIndex);

        // Assert
        final state = container.read(selectedLotIndexStateControllerProvider);
        expect(state, secondIndex);
      },
    );

    test('updateIndex should handle passing null explicitly', () {
      // Arrange
      final initialIndex = faker.randomGenerator.integer(100);
      final notifier = container.read(
        selectedLotIndexStateControllerProvider.notifier,
      );

      notifier.updateIndex(initialIndex);

      // Act
      notifier.updateIndex(null);

      // Assert
      final state = container.read(selectedLotIndexStateControllerProvider);
      expect(state, isNull);
    });
  });
}
