import 'package:celta_intelligence/features/inventory/presentation/controllers/controllers.dart';
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
      final state = container.read(selectedProductIndexStateControllerProvider);

      // ASSERT
      expect(state, isNull);
    });

    test(
      'updateIndex should set the state to the new index when null initially',
      () {
        // ARRANGE
        final newIndex = faker.randomGenerator.integer(100, min: 1);
        final notifier = container.read(
          selectedProductIndexStateControllerProvider.notifier,
        );

        final states = <int?>[];
        // Listen to capture the state change
        container.listen(
          selectedProductIndexStateControllerProvider,
          (_, next) => states.add(next),
        );

        // ACT
        notifier.updateIndex(newIndex);

        // ASSERT
        // 1. Verify the state transition list
        expect(states, [newIndex]);

        // 2. Verify the final state value
        expect(
          container.read(selectedProductIndexStateControllerProvider),
          newIndex,
        );
      },
    );

    test(
      'updateIndex should set the state to the new index when index is 0',
      () {
        // ARRANGE
        const newIndex = 0;
        final notifier = container.read(
          selectedProductIndexStateControllerProvider.notifier,
        );

        // ACT
        notifier.updateIndex(newIndex);

        // ASSERT
        expect(
          container.read(selectedProductIndexStateControllerProvider),
          newIndex,
        );
      },
    );

    test(
      'updateIndex should toggle state back to null if called with the same selected index',
      () {
        // ARRANGE
        const indexToToggle = 10;
        final notifier = container.read(
          selectedProductIndexStateControllerProvider.notifier,
        );

        // Set the initial selection (pre-condition)
        notifier.updateIndex(indexToToggle);

        final states = <int?>[];
        container.listen(
          selectedProductIndexStateControllerProvider,
          (_, next) => states.add(next),
        );

        // ACT: Call the update method with the *same* value
        notifier.updateIndex(indexToToggle);

        // ASSERT
        // The state transitions from 10 back to null
        expect(states, [isNull]);
        expect(
          container.read(selectedProductIndexStateControllerProvider),
          isNull,
        );
      },
    );

    test(
      'updateIndex should change state to a new index if a different one is already selected',
      () {
        // ARRANGE
        const initialIndex = 1;
        const newIndex = 2;
        final notifier = container.read(
          selectedProductIndexStateControllerProvider.notifier,
        );

        // Set initial selection
        notifier.updateIndex(initialIndex);

        final states = <int?>[];
        container.listen(
          selectedProductIndexStateControllerProvider,
          (_, next) => states.add(next),
        );

        // ACT: Call update with a *different* index
        notifier.updateIndex(newIndex);

        // ASSERT
        // State transitions from 1 to 2
        expect(states, [newIndex]);
        expect(
          container.read(selectedProductIndexStateControllerProvider),
          newIndex,
        );
      },
    );

    test(
      'updateIndex should set state to null if null is passed when an index is selected',
      () {
        // ARRANGE
        const initialIndex = 5;
        final notifier = container.read(
          selectedProductIndexStateControllerProvider.notifier,
        );

        // Set initial selection
        notifier.updateIndex(initialIndex);

        final states = <int?>[];
        container.listen(
          selectedProductIndexStateControllerProvider,
          (_, next) => states.add(next),
        );

        // ACT: Call update with null
        notifier.updateIndex(null);

        // ASSERT
        expect(states, [isNull]);
        expect(
          container.read(selectedProductIndexStateControllerProvider),
          isNull,
        );
      },
    );

    test(
      'updateIndex should do nothing if null is passed when state is already null',
      () {
        // ARRANGE
        final notifier = container.read(
          selectedProductIndexStateControllerProvider.notifier,
        );

        final states = <int?>[];
        container.listen(
          selectedProductIndexStateControllerProvider,
          (_, next) => states.add(next),
        );

        // ACT: Call update with null when state is null
        notifier.updateIndex(null);

        // ASSERT
        // No state change should be emitted
        expect(states, isEmpty);
        expect(
          container.read(selectedProductIndexStateControllerProvider),
          isNull,
        );
      },
    );
  });
}
