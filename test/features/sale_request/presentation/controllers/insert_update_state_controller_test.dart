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

    test('addItem should add a new product to the cart', () async {
      final container = ProviderContainer(
        overrides: [
          paymentOptionsStateControllerProvider(1).overrideWith(
            () => FakePaymentOptionsController([]),
          ),
        ],
      );
      addTearDown(container.dispose);

      final controller = container.read(
        insertUpdateStateControllerProvider(
          enterpriseCode: 1,
          customerCode: 1,
          saleRequestId: 0,
        ).notifier,
      );

      await container.read(
        insertUpdateStateControllerProvider(
          enterpriseCode: 1,
          customerCode: 1,
          saleRequestId: 0,
        ).future,
      );

      final product = EntityFactory.makeProductEntity(
        productPackingCode: 123,
        enterpriseCode: 1,
      );

      controller.addItem(product);

      final state = container.read(
        insertUpdateStateControllerProvider(
          enterpriseCode: 1,
          customerCode: 1,
          saleRequestId: 0,
        ),
      );

      expect(state.value!.products!.length, 1);
      expect(state.value!.products!.first.productPackingCode, 123);
      expect(state.value!.products!.first.quantity, 1);
    });

    test('addItem should increment quantity if product is already in cart',
        () async {
      final container = ProviderContainer(
        overrides: [
          paymentOptionsStateControllerProvider(1).overrideWith(
            () => FakePaymentOptionsController([]),
          ),
        ],
      );
      addTearDown(container.dispose);

      final controller = container.read(
        insertUpdateStateControllerProvider(
          enterpriseCode: 1,
          customerCode: 1,
          saleRequestId: 0,
        ).notifier,
      );

      await container.read(
        insertUpdateStateControllerProvider(
          enterpriseCode: 1,
          customerCode: 1,
          saleRequestId: 0,
        ).future,
      );

      final product = EntityFactory.makeProductEntity(
        productPackingCode: 123,
        enterpriseCode: 1,
      );

      controller.addItem(product);
      controller.addItem(product);

      final state = container.read(
        insertUpdateStateControllerProvider(
          enterpriseCode: 1,
          customerCode: 1,
          saleRequestId: 0,
        ),
      );

      expect(state.value!.products!.length, 1);
      expect(state.value!.products!.first.quantity, 2);
    });

    test('updateItemQuantity should call addItem when item is null', () async {
      final container = ProviderContainer(
        overrides: [
          paymentOptionsStateControllerProvider(1).overrideWith(
            () => FakePaymentOptionsController([]),
          ),
        ],
      );
      addTearDown(container.dispose);

      final controller = container.read(
        insertUpdateStateControllerProvider(
          enterpriseCode: 1,
          customerCode: 1,
          saleRequestId: 0,
        ).notifier,
      );

      await container.read(
        insertUpdateStateControllerProvider(
          enterpriseCode: 1,
          customerCode: 1,
          saleRequestId: 0,
        ).future,
      );

      final product = EntityFactory.makeProductEntity(
        productPackingCode: 123,
        enterpriseCode: 1,
      );

      controller.updateItemQuantity(null, 5.0, product);

      final state = container.read(
        insertUpdateStateControllerProvider(
          enterpriseCode: 1,
          customerCode: 1,
          saleRequestId: 0,
        ),
      );

      expect(state.value!.products!.length, 1);
      expect(state.value!.products!.first.quantity, 1); // addItem starts with 1
    });

    test('updateItemQuantity should update quantity when item is not null',
        () async {
      final container = ProviderContainer(
        overrides: [
          paymentOptionsStateControllerProvider(1).overrideWith(
            () => FakePaymentOptionsController([]),
          ),
        ],
      );
      addTearDown(container.dispose);

      final controller = container.read(
        insertUpdateStateControllerProvider(
          enterpriseCode: 1,
          customerCode: 1,
          saleRequestId: 0,
        ).notifier,
      );

      await container.read(
        insertUpdateStateControllerProvider(
          enterpriseCode: 1,
          customerCode: 1,
          saleRequestId: 0,
        ).future,
      );

      final product = EntityFactory.makeProductEntity(
        productPackingCode: 123,
        enterpriseCode: 1,
      );

      controller.addItem(product);
      final item = container
          .read(
            insertUpdateStateControllerProvider(
              enterpriseCode: 1,
              customerCode: 1,
              saleRequestId: 0,
            ),
          )
          .value!
          .products!
          .first;

      controller.updateItemQuantity(item, 10.0, product);

      final state = container.read(
        insertUpdateStateControllerProvider(
          enterpriseCode: 1,
          customerCode: 1,
          saleRequestId: 0,
        ),
      );

      expect(state.value!.products!.first.quantity, 10.0);
    });

    test('addItem should not add product if price is 0 or less', () async {
      final container = ProviderContainer(
        overrides: [
          paymentOptionsStateControllerProvider(1).overrideWith(
            () => FakePaymentOptionsController([]),
          ),
        ],
      );
      addTearDown(container.dispose);

      final controller = container.read(
        insertUpdateStateControllerProvider(
          enterpriseCode: 1,
          customerCode: 1,
          saleRequestId: 0,
        ).notifier,
      );

      await container.read(
        insertUpdateStateControllerProvider(
          enterpriseCode: 1,
          customerCode: 1,
          saleRequestId: 0,
        ).future,
      );

      final productWithZeroPrice = EntityFactory.makeProductEntity(
        productPackingCode: 123,
        enterpriseCode: 1,
        RetailPracticedPrice: 0,
      ).copyWith(Value: 0);

      controller.addItem(productWithZeroPrice);

      final state = container.read(
        insertUpdateStateControllerProvider(
          enterpriseCode: 1,
          customerCode: 1,
          saleRequestId: 0,
        ),
      );

      expect(state.value!.products ?? [], isEmpty);
    });
  });
}
