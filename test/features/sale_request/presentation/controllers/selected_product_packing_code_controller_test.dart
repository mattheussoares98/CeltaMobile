import 'package:celta_intelligence/features/sale_request/presentation/controllers/controllers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  ProviderContainer makeProviderContainer() {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    return container;
  }

  group('SelectedProductPackingCodeController', () {
    test(
      'build should have an initial state of AsyncData<int?>(null)',
      () async {
        // ARRANGE
        final container = makeProviderContainer();

        // ACT: Wait for the initial synchronous build to complete
        await container.read(
          selectedProductPackingCodeControllerProvider(true).future,
        );

        // ASSERT
        final state = container.read(
          selectedProductPackingCodeControllerProvider(true),
        );
        expect(state, const AsyncData<int?>(null));
      },
    );

    test('updateSelectedCode should update the state to the new value', () async {
      // ARRANGE
      final container = makeProviderContainer();
      await container.read(
        selectedProductPackingCodeControllerProvider(true).future,
      );
      const newCode = 123;

      final states = <AsyncValue<int?>>[];
      container.listen(
        selectedProductPackingCodeControllerProvider(true),
        (_, next) => states.add(next),
      );

      // ACT: Call the update method
      container
          .read(selectedProductPackingCodeControllerProvider(true).notifier)
          .updateSelectedCode(newCode);

      // ASSERT
      // The state transitions directly from AsyncData<int?>(null) to AsyncData<int?>(123).
      // Since we listened *after* the build, we only capture the new state.
      expect(states, [const AsyncData<int?>(newCode)]);
      expect(
        container
            .read(selectedProductPackingCodeControllerProvider(true))
            .value,
        newCode,
      );
    });

    test(
      'updateSelectedCode should set state to null if called with the same value',
      () async {
        // ARRANGE
        final container = makeProviderContainer();
        await container.read(
          selectedProductPackingCodeControllerProvider(true).future,
        );
        const newCode = 123;

        // Set the initial value
        container
            .read(selectedProductPackingCodeControllerProvider(true).notifier)
            .updateSelectedCode(newCode);

        // Verify it was set
        expect(
          container
              .read(selectedProductPackingCodeControllerProvider(true))
              .value,
          newCode,
        );

        final states = <AsyncValue<int?>>[];
        container.listen(
          selectedProductPackingCodeControllerProvider(true),
          (_, next) => states.add(next),
        );

        // ACT: Call the update method with the *same* value
        container
            .read(selectedProductPackingCodeControllerProvider(true).notifier)
            .updateSelectedCode(newCode);

        // ASSERT
        // The state transitions from AsyncData<int?>(123) back to AsyncData<int?>(null)
        expect(states, [const AsyncData<int?>(null)]);
        expect(
          container
              .read(selectedProductPackingCodeControllerProvider(true))
              .value,
          isNull,
        );
      },
    );
  });
}
