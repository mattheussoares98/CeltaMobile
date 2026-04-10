import 'dart:async';

import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../mocks/mocks.dart';

class FakeSaleRequestDetailsController
    extends SaleRequestDetailsStateController {
  final BSFSaleRequestEntity entity;
  FakeSaleRequestDetailsController(this.entity);

  @override
  FutureOr<BSFSaleRequestEntity> build({
    required int customerCode,
    required int enterpriseCode,
    required int saleRequestCode,
  }) {
    return entity;
  }
}

class FakePaymentOptionsController extends PaymentOptionsStateController {
  final List<BSFPaymentFinalizationEntity> entities;
  bool wasCalled = false;
  FakePaymentOptionsController(this.entities);

  @override
  FutureOr<List<BSFPaymentFinalizationEntity>> build(int enterpriseCode) {
    wasCalled = true;
    return entities;
  }
}

void main() {
  group('InsertUpdateStateController', () {
    test('should return empty entity when saleRequestId is 0 and load payment options',
        () async {
      final fakePayments = FakePaymentOptionsController([]);
      const enterpriseCode = 1;

      final container = ProviderContainer(
        overrides: [
          paymentOptionsStateControllerProvider(enterpriseCode)
              .overrideWith(() => fakePayments),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(
        insertUpdateStateControllerProvider(
          enterpriseCode: enterpriseCode,
          customerCode: 1,
          saleRequestId: 0,
        ).future,
      );

      expect(result, isA<BSFSaleRequestEntity>());
      expect(result, BSFSaleRequestEntity.empty());
      expect(fakePayments.wasCalled, isTrue);
    });

    test(
      'should return data from saleRequestDetailsStateControllerProvider when saleRequestId is not 0 and load payment options',
      () async {
        final fakeEntity = EntityFactory.makeBSFSaleRequestEntity();
        final fakePayments = FakePaymentOptionsController([]);
        const enterpriseCode = 1;
        const customerCode = 2;
        const saleRequestId = 123;

        final container = ProviderContainer(
          overrides: [
            paymentOptionsStateControllerProvider(enterpriseCode)
                .overrideWith(() => fakePayments),
            saleRequestDetailsStateControllerProvider(
              customerCode: customerCode,
              enterpriseCode: enterpriseCode,
              saleRequestCode: saleRequestId,
            ).overrideWith(() => FakeSaleRequestDetailsController(fakeEntity)),
          ],
        );
        addTearDown(container.dispose);

        final result = await container.read(
          insertUpdateStateControllerProvider(
            enterpriseCode: enterpriseCode,
            customerCode: customerCode,
            saleRequestId: saleRequestId,
          ).future,
        );

        expect(result, fakeEntity);
        expect(fakePayments.wasCalled, isTrue);
      },
    );
  });
}
