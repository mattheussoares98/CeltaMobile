import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../mocks/mocks.dart';

void main() {
  ProviderContainer makeProviderContainer() {
    final container = ProviderContainer(retry: (retryCount, error) => null);
    addTearDown(container.dispose);
    return container;
  }

  // Define some test data
  const testPackingCode = 123;
  const testDiscountType = PercentageOrValue.percentage;
  final cartProduct = EntityFactory.makeCartProductEntity(
    productPackingCode: testPackingCode,
    discountType: testDiscountType,
  );

  // The 'isCartPage' parameter for the family
  const isCartPage = true;

  group('SelectedItemUIController', () {
    test(
      'build should have an initial state of SelectedItemUIState.empty()',
      () async {
        // ARRANGE
        final container = makeProviderContainer();

        // ACT
        final result = container.read(
          selectedItemUIControllerProvider(isCartPage: isCartPage),
        );

        // ASSERT
        expect(result, SelectedItemUIState.empty());
        expect(
          container.read(
            selectedItemUIControllerProvider(isCartPage: isCartPage),
          ),
          SelectedItemUIState.empty(),
        );
      },
    );

    group('selectProduct', () {
      test(
        'should update state with new product code and discount type',
        () async {
          // ARRANGE
          final container = makeProviderContainer();
          container.read(
            selectedItemUIControllerProvider(isCartPage: isCartPage),
          );

          final states = <SelectedItemUIState>[];
          container.listen(
            selectedItemUIControllerProvider(isCartPage: isCartPage),
            (_, next) => states.add(next),
          );

          // ACT
          container
              .read(
                selectedItemUIControllerProvider(
                  isCartPage: isCartPage,
                ).notifier,
              )
              .selectProduct(testPackingCode, cartProduct);

          // ASSERT
          const expectedState = SelectedItemUIState(
            productPackingCode: testPackingCode,
            discountType: null,
          );

          expect(states, [expectedState]);
          expect(
            container.read(
              selectedItemUIControllerProvider(isCartPage: isCartPage),
            ),
            expectedState,
          );
        },
      );

      test(
        'should toggle state back to empty if the same product is selected',
        () async {
          // ARRANGE
          final container = makeProviderContainer();
          container.read(
            selectedItemUIControllerProvider(isCartPage: isCartPage),
          );

          // Set the initial selection
          container
              .read(
                selectedItemUIControllerProvider(
                  isCartPage: isCartPage,
                ).notifier,
              )
              .selectProduct(testPackingCode, cartProduct);

          // Verify it was set
          expect(
            container
                .read(selectedItemUIControllerProvider(isCartPage: isCartPage))
                .productPackingCode,
            testPackingCode,
          );

          final states = <SelectedItemUIState>[];
          container.listen(
            selectedItemUIControllerProvider(isCartPage: isCartPage),
            (_, next) => states.add(next),
          );

          // ACT: Call selectProduct with the *same* code
          container
              .read(
                selectedItemUIControllerProvider(
                  isCartPage: isCartPage,
                ).notifier,
              )
              .selectProduct(testPackingCode, cartProduct);

          // ASSERT
          expect(states, [SelectedItemUIState.empty()]);
          expect(
            container.read(
              selectedItemUIControllerProvider(isCartPage: isCartPage),
            ),
            SelectedItemUIState.empty(),
          );
        },
      );
    });

    group('updateDiscountType', () {
      test(
        'should update only the discount type, preserving the product code',
        () async {
          // ARRANGE
          final container = makeProviderContainer();
          container.read(
            selectedItemUIControllerProvider(isCartPage: isCartPage),
          );

          // Set an initial product selection
          container
              .read(
                selectedItemUIControllerProvider(
                  isCartPage: isCartPage,
                ).notifier,
              )
              .selectProduct(testPackingCode, null); // Start with null discount

          // Verify initial state
          expect(
            container.read(
              selectedItemUIControllerProvider(isCartPage: isCartPage),
            ),
            const SelectedItemUIState(
              productPackingCode: testPackingCode,
              discountType: null,
            ),
          );

          final states = <SelectedItemUIState>[];
          container.listen(
            selectedItemUIControllerProvider(isCartPage: isCartPage),
            (_, next) => states.add(next),
          );

          // ACT: Call updateDiscountType
          container
              .read(
                selectedItemUIControllerProvider(
                  isCartPage: isCartPage,
                ).notifier,
              )
              .updateDiscountType(PercentageOrValue.percentage);

          // ASSERT
          const expectedState = SelectedItemUIState(
            productPackingCode: testPackingCode,
            discountType: PercentageOrValue.percentage,
          );
          expect(states, [expectedState]);
          expect(
            container.read(
              selectedItemUIControllerProvider(isCartPage: isCartPage),
            ),
            expectedState,
          );
        },
      );
    });
  });
}
