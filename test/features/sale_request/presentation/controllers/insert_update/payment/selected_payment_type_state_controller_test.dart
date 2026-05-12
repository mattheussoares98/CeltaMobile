import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../mocks/mocks.dart';

void main() {
  group('SelectedPaymentTypeStateController', () {
    late int saleRequestCode;

    setUp(() {
      saleRequestCode = faker.randomGenerator.integer(1000);
    });

    test('should have null as initial state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = container.read(
        selectedPaymentTypeStateControllerProvider(saleRequestCode),
      );

      expect(state, isNull);
    });

    test('should update state when select is called', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final payment = faker.randomGenerator.boolean()
          ? EntityFactory.makeBSFPaymentFinalizationEntity()
          : null;

      container
          .read(
            selectedPaymentTypeStateControllerProvider(
              saleRequestCode,
            ).notifier,
          )
          .select(payment);

      final state = container.read(
        selectedPaymentTypeStateControllerProvider(saleRequestCode),
      );

      expect(state, payment);
    });
  });
}
