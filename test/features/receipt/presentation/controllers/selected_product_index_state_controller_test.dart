import 'package:celta_intelligence/features/receipt/presentation/controllers/controllers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ProviderContainer container;
  late Faker faker;

  setUp(() {
    container = ProviderContainer();
    faker = Faker();
    addTearDown(container.dispose);
  });

  group('SelectedIndexStateController', () {
    test('build should have an initial state of null', () {
      // ARRANGE / ACT
      final state = container.read(selectedIndexStateControllerProvider);

      // ASSERT
      expect(state, isNull);
    });

    test(
      'updateIndex should set the state to the new index when null initially',
      () {
        // ARRANGE
        final newIndex = faker.randomGenerator.integer(100);
        final notifier = container.read(
          selectedIndexStateControllerProvider.notifier,
        );

        final states = <int?>[];
        // Listen to capture the state change
        container.listen(
          selectedIndexStateControllerProvider,
          (_, next) => states.add(next),
        );

        // ACT
        notifier.updateIndex(newIndex);

        // ASSERT
        // 1. Verify the state transition list
        expect(states, [newIndex]);

        // 2. Verify the final state value
        expect(container.read(selectedIndexStateControllerProvider), newIndex);
      },
    );

    test(
      'updateIndex should toggle state back to null if called with the same index',
      () {
        // ARRANGE
        const indexToToggle = 10;
        final notifier = container.read(
          selectedIndexStateControllerProvider.notifier,
        );

        // Set the initial selection (pre-condition)
        notifier.updateIndex(indexToToggle);

        final states = <int?>[];
        container.listen(
          selectedIndexStateControllerProvider,
          (_, next) => states.add(next),
        );

        // ACT: Call the update method with the *same* value
        notifier.updateIndex(indexToToggle);

        // ASSERT
        // The state transitions from 10 back to null
        expect(states, [isNull]);
        expect(container.read(selectedIndexStateControllerProvider), isNull);
      },
    );

    test(
      'updateIndex should change state to a new index if a different one is already selected',
      () {
        // ARRANGE
        const initialIndex = 1;
        const newIndex = 2;
        final notifier = container.read(
          selectedIndexStateControllerProvider.notifier,
        );

        // Set initial selection
        notifier.updateIndex(initialIndex);

        final states = <int?>[];
        container.listen(
          selectedIndexStateControllerProvider,
          (_, next) => states.add(next),
        );

        // ACT: Call update with a *different* index
        notifier.updateIndex(newIndex);

        // ASSERT
        // State transitions from 1 to 2
        expect(states, [newIndex]);
        expect(container.read(selectedIndexStateControllerProvider), newIndex);
      },
    );
  });
}
