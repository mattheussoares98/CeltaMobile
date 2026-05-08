import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../mocks/mocks.dart';

void main() {
  ProviderContainer makeProviderContainer() {
    return ProviderContainer();
  }

  group('SelectedPaymentConditionStateController', () {
    test('should initialize with null state', () {
      final container = makeProviderContainer();
      addTearDown(container.dispose);

      final state = container.read(selectedPaymentConditionStateControllerProvider);

      expect(state, isNull);
    });

    test('should update state when select is called', () {
      final container = makeProviderContainer();
      addTearDown(container.dispose);

      final paymentCondition = EntityFactory.makeBSFPaymentConditionEntity();

      container
          .read(selectedPaymentConditionStateControllerProvider.notifier)
          .select(paymentCondition);

      final state = container.read(selectedPaymentConditionStateControllerProvider);

      expect(state, paymentCondition);
    });
  });
}
