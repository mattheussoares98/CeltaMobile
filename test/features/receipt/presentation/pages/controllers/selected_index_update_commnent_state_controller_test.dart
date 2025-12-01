import 'package:celta_intelligence/features/receipt/presentation/pages/controllers/controllers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
    addTearDown(container.dispose);
  });

  group('SelectedIndexUpdateCommnentStateController', () {
    test('build should have an initial state of null', () {
      // ARRANGE / ACT
      // Since build is synchronous, we read the current value (or default).
      final state = container.read(
        selectedIndexUpdateCommnentStateControllerProvider,
      );

      // ASSERT
      expect(state, isNull);
    });

    test('update should set the state to the new index', () async {
      // ARRANGE
      final newIndex = faker.randomGenerator.integer(100);
      final notifier = container.read(
        selectedIndexUpdateCommnentStateControllerProvider.notifier,
      );

      final states = <int?>[];
      // Listen to capture the state change
      container.listen(
        selectedIndexUpdateCommnentStateControllerProvider,
        (_, next) => states.add(next),
      );

      // ACT
      notifier.update(newIndex);

      // ASSERT
      // 1. Verify the state transition list
      expect(states, [newIndex]);

      // 2. Verify the final state value
      expect(
        container.read(selectedIndexUpdateCommnentStateControllerProvider),
        newIndex,
      );
    });

    test(
      'update should toggle state back to null if called with the same index',
      () async {
        // ARRANGE
        const indexToToggle = 10;
        final notifier = container.read(
          selectedIndexUpdateCommnentStateControllerProvider.notifier,
        );

        // Set the initial selection (pre-condition)
        notifier.update(indexToToggle);

        final states = <int?>[];
        container.listen(
          selectedIndexUpdateCommnentStateControllerProvider,
          (_, next) => states.add(next),
        );

        // ACT: Call the update method with the *same* value
        notifier.update(indexToToggle);

        // ASSERT
        // The state transitions from 10 back to null
        expect(states, [isNull]);
        expect(
          container.read(selectedIndexUpdateCommnentStateControllerProvider),
          isNull,
        );
      },
    );

    test(
      'update should change state to a new index if a different one is already selected',
      () async {
        // ARRANGE
        const initialIndex = 1;
        const newIndex = 2;
        final notifier = container.read(
          selectedIndexUpdateCommnentStateControllerProvider.notifier,
        );

        // Set initial selection
        notifier.update(initialIndex);

        final states = <int?>[];
        container.listen(
          selectedIndexUpdateCommnentStateControllerProvider,
          (_, next) => states.add(next),
        );

        // ACT: Call update with a *different* index
        notifier.update(newIndex);

        // ASSERT
        // State transitions from 1 to 2
        expect(states, [newIndex]);
        expect(
          container.read(selectedIndexUpdateCommnentStateControllerProvider),
          newIndex,
        );
      },
    );
  });
}
