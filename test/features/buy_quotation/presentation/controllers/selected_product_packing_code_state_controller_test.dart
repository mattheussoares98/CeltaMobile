import 'package:celta_inventario/features/buy_quotation/presentation/controllers/controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:faker/faker.dart';

void main() {
  late ProviderContainer container;
  late Faker faker;

  setUp(() {
    container = ProviderContainer();
    faker = Faker();
    addTearDown(container.dispose);
  });

  group('SelectedProductIndexStateController', () {
    test('build should have an initial state of null', () {
      // ARRANGE / ACT
      final state = container.read(
        selectedProductPackingCodeStateControllerProvider,
      );

      // ASSERT
      expect(state, isNull);
    });

    test(
      'updateProductPackingCode should set the state to the new index when null initially',
      () {
        // ARRANGE
        final newIndex = faker.randomGenerator.integer(100, min: 1);
        final notifier = container.read(
          selectedProductPackingCodeStateControllerProvider.notifier,
        );

        final states = <int?>[];
        // Listen to capture the state change
        container.listen(
          selectedProductPackingCodeStateControllerProvider,
          (_, next) => states.add(next),
        );

        // ACT
        notifier.updateProductPackingCode(newIndex);

        // ASSERT
        // 1. Verify the state transition list
        expect(states, [newIndex]);

        // 2. Verify the final state value
        expect(
          container.read(selectedProductPackingCodeStateControllerProvider),
          newIndex,
        );
      },
    );

    test(
      'updateProductPackingCode should set the state to the new index when index is 0',
      () {
        // ARRANGE
        const newIndex = 0;
        final notifier = container.read(
          selectedProductPackingCodeStateControllerProvider.notifier,
        );

        // ACT
        notifier.updateProductPackingCode(newIndex);

        // ASSERT
        expect(
          container.read(selectedProductPackingCodeStateControllerProvider),
          newIndex,
        );
      },
    );

    test(
      'updateProductPackingCode should toggle state back to null if called with the same selected index',
      () {
        // ARRANGE
        const indexToToggle = 10;
        final notifier = container.read(
          selectedProductPackingCodeStateControllerProvider.notifier,
        );

        // Set the initial selection (pre-condition)
        notifier.updateProductPackingCode(indexToToggle);

        final states = <int?>[];
        container.listen(
          selectedProductPackingCodeStateControllerProvider,
          (_, next) => states.add(next),
        );

        // ACT: Call the update method with the *same* value
        notifier.updateProductPackingCode(indexToToggle);

        // ASSERT
        // The state transitions from 10 back to null
        expect(states, [isNull]);
        expect(
          container.read(selectedProductPackingCodeStateControllerProvider),
          isNull,
        );
      },
    );

    test(
      'updateProductPackingCode should change state to a new index if a different one is already selected',
      () {
        // ARRANGE
        const initialIndex = 1;
        const newIndex = 2;
        final notifier = container.read(
          selectedProductPackingCodeStateControllerProvider.notifier,
        );

        // Set initial selection
        notifier.updateProductPackingCode(initialIndex);

        final states = <int?>[];
        container.listen(
          selectedProductPackingCodeStateControllerProvider,
          (_, next) => states.add(next),
        );

        // ACT: Call update with a *different* index
        notifier.updateProductPackingCode(newIndex);

        // ASSERT
        // State transitions from 1 to 2
        expect(states, [newIndex]);
        expect(
          container.read(selectedProductPackingCodeStateControllerProvider),
          newIndex,
        );
      },
    );

    test(
      'updateProductPackingCode should set state to null if null is passed when an index is selected',
      () {
        // ARRANGE
        const initialIndex = 5;
        final notifier = container.read(
          selectedProductPackingCodeStateControllerProvider.notifier,
        );

        // Set initial selection
        notifier.updateProductPackingCode(initialIndex);

        final states = <int?>[];
        container.listen(
          selectedProductPackingCodeStateControllerProvider,
          (_, next) => states.add(next),
        );

        // ACT: Call update with null
        notifier.updateProductPackingCode(null);

        // ASSERT
        expect(states, [isNull]);
        expect(
          container.read(selectedProductPackingCodeStateControllerProvider),
          isNull,
        );
      },
    );

    test(
      'updateProductPackingCode should do nothing if null is passed when state is already null',
      () {
        // ARRANGE
        final notifier = container.read(
          selectedProductPackingCodeStateControllerProvider.notifier,
        );

        final states = <int?>[];
        container.listen(
          selectedProductPackingCodeStateControllerProvider,
          (_, next) => states.add(next),
        );

        // ACT: Call update with null when state is null
        notifier.updateProductPackingCode(null);

        // ASSERT
        // No state change should be emitted
        expect(states, isEmpty);
        expect(
          container.read(selectedProductPackingCodeStateControllerProvider),
          isNull,
        );
      },
    );
    test('change index to null when pass the same previous value', () {
      // ARRANGE
      final newIndex = faker.randomGenerator.integer(100);
      final notifier = container.read(
        selectedProductPackingCodeStateControllerProvider.notifier,
      );

      // ACT
      notifier.updateProductPackingCode(newIndex);

      // ASSERT
      expect(
        container.read(selectedProductPackingCodeStateControllerProvider),
        newIndex,
      );

      // ACT
      notifier.updateProductPackingCode(newIndex);

      // ASSERT
      expect(
        container.read(selectedProductPackingCodeStateControllerProvider),
        null,
      );
    });
  });
}
