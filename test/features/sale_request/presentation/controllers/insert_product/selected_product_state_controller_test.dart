import 'package:celta_inventario/features/sale_request/presentation/controllers/insert_product/selected_product_state_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../mocks/mocks.dart';

void main() {
  ProviderContainer makeProviderContainer() {
    final container = ProviderContainer(
      retry: (retryCount, error) => null,
    );
    addTearDown(container.dispose);
    return container;
  }

  group('SelectedProductStateController', () {
    test('build should return null initially', () {
      // ARRANGE
      final container = makeProviderContainer();

      // ACT
      final state = container.read(selectedProductStateControllerProvider);

      // ASSERT
      expect(state, isNull);
    });

    test('setProduct should update the state with the provided product', () {
      // ARRANGE
      final container = makeProviderContainer();
      final testProduct =
          EntityFactory.makeBSFSaleRequestEntity().products!.first;

      final notifier = container.read(
        selectedProductStateControllerProvider.notifier,
      );

      // ACT
      notifier.setProduct(testProduct);

      // ASSERT
      final state = container.read(selectedProductStateControllerProvider);
      expect(state, equals(testProduct));
    });
  });
}
