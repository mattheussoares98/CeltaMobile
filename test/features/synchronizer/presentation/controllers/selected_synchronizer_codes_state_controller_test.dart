import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/presentation/controllers/controllers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  ProviderContainer makeProviderContainer() {
    return ProviderContainer();
  }

  group('SelectedSynchronizerCodesStateController', () {
    test('initial state should be empty list', () {
      final container = makeProviderContainer();
      addTearDown(container.dispose);

      final state = container.read(
        selectedSynchronizerCodesStateControllerProvider(
          SynchronizerErrorDetailType.coupon,
        ),
      );

      expect(state, isEmpty);
    });

    test(
      'should add code to state when select is called and code is not present',
      () {
        final container = makeProviderContainer();
        addTearDown(container.dispose);

        final provider = selectedSynchronizerCodesStateControllerProvider(
          SynchronizerErrorDetailType.coupon,
        );

        // Verify initial state
        expect(container.read(provider), isEmpty);

        // Select a code (should add it)
        container.read(provider.notifier).select(123);

        expect(container.read(provider), equals({123}));
      },
    );

    test(
      'should remove code from state when select is called and code is already present',
      () {
        final container = makeProviderContainer();
        addTearDown(container.dispose);

        final provider = selectedSynchronizerCodesStateControllerProvider(
          SynchronizerErrorDetailType.coupon,
        );

        // Select a code (should add it)
        container.read(provider.notifier).select(123);
        expect(container.read(provider), equals({123}));

        // Select the same code again (should remove it)
        container.read(provider.notifier).select(123);
        expect(container.read(provider), isEmpty);
      },
    );

    test(
      'should support multiple codes and handle them independently per type',
      () {
        final container = makeProviderContainer();
        addTearDown(container.dispose);

        final couponProvider = selectedSynchronizerCodesStateControllerProvider(
          SynchronizerErrorDetailType.coupon,
        );
        final fiscalNoteProvider =
            selectedSynchronizerCodesStateControllerProvider(
              SynchronizerErrorDetailType.fiscalNote,
            );

        // Add codes to coupon provider
        container.read(couponProvider.notifier).select(100);
        container.read(couponProvider.notifier).select(200);

        // Add code to fiscal note provider
        container.read(fiscalNoteProvider.notifier).select(300);

        expect(container.read(couponProvider), equals({100, 200}));
        expect(container.read(fiscalNoteProvider), equals({300}));

        // Toggle code in coupon provider
        container.read(couponProvider.notifier).select(100);
        expect(container.read(couponProvider), equals({200}));
        expect(container.read(fiscalNoteProvider), equals({300}));
      },
    );
  });
}
