import 'package:celta_intelligence/features/sale_request/domain/entities/entities.dart';
import 'package:celta_intelligence/features/sale_request/presentation/controllers/controllers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// No mocks are needed since this controller has no dependencies.

void main() {
  ProviderContainer makeProviderContainer() {
    return ProviderContainer();
  }

  group('SelectedDiscountTypeController', () {
    test('build should have an initial state of null', () async {
      // ARRANGE
      final container = makeProviderContainer();
      addTearDown(container.dispose);

      // ACT
      // We await the future to ensure the build method has completed.
      final result = await container.read(
        selectedDiscountTypeControllerProvider.future,
      );

      // ASSERT
      expect(result, null);
      // You can also check the full state object
      final state = container.read(selectedDiscountTypeControllerProvider);
      expect(state, const AsyncData<PercentageOrValue?>(null));
    });

    test(
      'updateSelectedDiscountType should update the state to the new value',
      () async {
        // ARRANGE
        final container = makeProviderContainer();
        addTearDown(container.dispose);
        // Wait for the initial build to complete
        await container.read(selectedDiscountTypeControllerProvider.future);

        const newValue = PercentageOrValue.percentage;

        final states = <AsyncValue<PercentageOrValue?>>[];
        container.listen(
          selectedDiscountTypeControllerProvider,
          (_, next) => states.add(next),
        );

        // ACT
        // The method is synchronous, so no 'await' is needed.
        container
            .read(selectedDiscountTypeControllerProvider.notifier)
            .updateSelectedDiscountType(newValue);

        // ASSERT
        // The state transitions directly from AsyncData(null) to AsyncData(newValue).
        // Since we started listening *after* the build, we only get the new state.
        expect(states, [const AsyncData<PercentageOrValue?>(newValue)]);

        // Verify the final state is correct
        final finalState = container.read(
          selectedDiscountTypeControllerProvider,
        );
        expect(finalState.value, newValue);
      },
    );

    test(
      'updateSelectedDiscountType should be able to update the state to null',
      () async {
        // ARRANGE
        final container = makeProviderContainer();
        addTearDown(container.dispose);
        await container.read(selectedDiscountTypeControllerProvider.future);

        // Set a value first
        container
            .read(selectedDiscountTypeControllerProvider.notifier)
            .updateSelectedDiscountType(PercentageOrValue.percentage);

        final states = <AsyncValue<PercentageOrValue?>>[];
        container.listen(
          selectedDiscountTypeControllerProvider,
          (_, next) => states.add(next),
        );

        // ACT: Call the update with null
        container
            .read(selectedDiscountTypeControllerProvider.notifier)
            .updateSelectedDiscountType(null);

        // ASSERT
        expect(states, [const AsyncData<PercentageOrValue?>(null)]);
        final finalState = container.read(
          selectedDiscountTypeControllerProvider,
        );
        expect(finalState.value, isNull);
      },
    );
  });
}
