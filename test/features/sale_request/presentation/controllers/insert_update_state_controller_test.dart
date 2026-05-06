import 'dart:async';

import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:faker/faker.dart';
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
  late int enterpriseCode;
  late int customerCode;
  late int saleRequestId;
  late FakePaymentOptionsController fakePaymentsController;
  late List<BSFPaymentFinalizationEntity> fakePayments;
  late BSFSaleRequestEntity fakeSaleRequest;

  ProviderContainer makeProviderContainer() {
    final container = ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        paymentOptionsStateControllerProvider(
          enterpriseCode,
        ).overrideWith(() => fakePaymentsController),
        saleRequestDetailsStateControllerProvider(
          customerCode: customerCode,
          enterpriseCode: enterpriseCode,
          saleRequestCode: saleRequestId,
        ).overrideWith(() => FakeSaleRequestDetailsController(fakeSaleRequest)),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() {
    enterpriseCode = faker.randomGenerator.integer(100);
    customerCode = faker.randomGenerator.integer(100);
    saleRequestId = faker.randomGenerator.integer(100);
    fakeSaleRequest = EntityFactory.makeBSFSaleRequestEntity();
    fakePayments = [
      EntityFactory.makeBSFPaymentFinalizationEntity(),
      EntityFactory.makeBSFPaymentFinalizationEntity(),
      EntityFactory.makeBSFPaymentFinalizationEntity(),
    ];

    fakePaymentsController = FakePaymentOptionsController(fakePayments);
  });

  group('InsertUpdateStateController', () {
    group('build', () {
      test(
        'should return empty entity when saleRequestId is 0 and load payment options',
        () async {
          final container = makeProviderContainer();

          final result = await container.read(
            insertUpdateStateControllerProvider(
              enterpriseCode: enterpriseCode,
              customerCode: customerCode,
              saleRequestId: 0,
            ).future,
          );

          expect(result, BSFSaleRequestEntity.empty());
          expect(fakePaymentsController.wasCalled, isTrue);
        },
      );

      test(
        'should return data from saleRequestDetailsStateControllerProvider when saleRequestId is not 0 and load payment options',
        () async {
          final container = makeProviderContainer();
          addTearDown(container.dispose);

          final result = await container.read(
            insertUpdateStateControllerProvider(
              enterpriseCode: enterpriseCode,
              customerCode: customerCode,
              saleRequestId: saleRequestId,
            ).future,
          );

          expect(result, fakeSaleRequest);
          expect(fakePaymentsController.wasCalled, isTrue);
        },
      );
    });

    group('Add Item', () {
      test('addItem should add a new product to the cart', () async {
        final container = makeProviderContainer();

        final controller = container.read(
          insertUpdateStateControllerProvider(
            enterpriseCode: enterpriseCode,
            customerCode: customerCode,
            saleRequestId: 0,
          ).notifier,
        );

        await container.read(
          insertUpdateStateControllerProvider(
            enterpriseCode: enterpriseCode,
            customerCode: customerCode,
            saleRequestId: 0,
          ).future,
        );

        final product = EntityFactory.makeProductEntity(
          productPackingCode: faker.randomGenerator.integer(100),
          enterpriseCode: enterpriseCode,
        );

        controller.addItem(product);

        final state = container.read(
          insertUpdateStateControllerProvider(
            enterpriseCode: enterpriseCode,
            customerCode: customerCode,
            saleRequestId: 0,
          ),
        );

        expect(state.value!.products!.length, 1);
        expect(
          state.value!.products!.first.productPackingCode,
          product.ProductPackingCode,
        );
        expect(state.value!.products!.first.quantity, 1);
      });

      test(
        'addItem should increment quantity if product is already in cart',
        () async {
          final container = makeProviderContainer();

          final controller = container.read(
            insertUpdateStateControllerProvider(
              enterpriseCode: enterpriseCode,
              customerCode: customerCode,
              saleRequestId: 0,
            ).notifier,
          );

          await container.read(
            insertUpdateStateControllerProvider(
              enterpriseCode: enterpriseCode,
              customerCode: customerCode,
              saleRequestId: 0,
            ).future,
          );

          final product = EntityFactory.makeProductEntity(
            plu: faker.guid.guid(),
            enterpriseCode: enterpriseCode,
          );

          controller.addItem(product);
          controller.addItem(product);

          final state = container.read(
            insertUpdateStateControllerProvider(
              enterpriseCode: enterpriseCode,
              customerCode: customerCode,
              saleRequestId: 0,
            ),
          );

          expect(state.value!.products!.length, 1);
          expect(state.value!.products!.first.quantity, 2);
        },
      );
    });

    test(
      'updateItemQuantity should update quantity when item is in cart',
      () async {
        final container = ProviderContainer(
          overrides: [
            paymentOptionsStateControllerProvider(
              1,
            ).overrideWith(() => FakePaymentOptionsController([])),
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

        controller.updateItemQuantity(item, 5.0);

        final state = container.read(
          insertUpdateStateControllerProvider(
            enterpriseCode: 1,
            customerCode: 1,
            saleRequestId: 0,
          ),
        );

        expect(state.value!.products!.length, 1);
        expect(state.value!.products!.first.quantity, 5.0);
      },
    );

    test(
      'updateItemQuantity should update quantity when item is not null',
      () async {
        final container = ProviderContainer(
          overrides: [
            paymentOptionsStateControllerProvider(
              1,
            ).overrideWith(() => FakePaymentOptionsController([])),
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

        controller.updateItemQuantity(item, 10.0);

        final state = container.read(
          insertUpdateStateControllerProvider(
            enterpriseCode: 1,
            customerCode: 1,
            saleRequestId: 0,
          ),
        );

        expect(state.value!.products!.first.quantity, 10.0);
      },
    );

    test('addItem should not add product if price is 0 or less', () async {
      final container = ProviderContainer(
        overrides: [
          paymentOptionsStateControllerProvider(
            1,
          ).overrideWith(() => FakePaymentOptionsController([])),
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

    test(
      'updateItemQuantity should use WholePracticedPrice when quantity >= MinimumWholeQuantity',
      () async {
        final container = ProviderContainer(
          overrides: [
            paymentOptionsStateControllerProvider(
              1,
            ).overrideWith(() => FakePaymentOptionsController([])),
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

        final product =
            EntityFactory.makeProductEntity(
              productPackingCode: 123,
              enterpriseCode: 1,
            ).copyWith(
              RetailPracticedPrice: 10.0,
              WholePracticedPrice: 8.0,
              MinimumWholeQuantity: 5.0,
              Value: 0,
              PriceCost: EntityFactory.makePriceCost().copyWith(
                RetailPracticedPrice: 10.0,
                WholePracticedPrice: 8.0,
                MinimumWholeQuantity: 5.0,
              ),
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

        controller.updateItemQuantity(item, 5.0);

        final state = container.read(
          insertUpdateStateControllerProvider(
            enterpriseCode: 1,
            customerCode: 1,
            saleRequestId: 0,
          ),
        );

        expect(state.value!.products!.first.quantity, 5.0);
        expect(state.value!.products!.first.value, 8.0);
      },
    );

    test(
      'updateItemQuantity should use getPrice (retail) when quantity < MinimumWholeQuantity',
      () async {
        final container = ProviderContainer(
          overrides: [
            paymentOptionsStateControllerProvider(
              1,
            ).overrideWith(() => FakePaymentOptionsController([])),
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

        final product =
            EntityFactory.makeProductEntity(
              productPackingCode: 123,
              enterpriseCode: 1,
            ).copyWith(
              RetailPracticedPrice: 10.0,
              WholePracticedPrice: 8.0,
              MinimumWholeQuantity: 5.0,
              Value: 0,
              PriceCost: EntityFactory.makePriceCost().copyWith(
                RetailPracticedPrice: 10.0,
                WholePracticedPrice: 8.0,
                MinimumWholeQuantity: 5.0,
              ),
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

        controller.updateItemQuantity(item, 3.0);

        final state = container.read(
          insertUpdateStateControllerProvider(
            enterpriseCode: 1,
            customerCode: 1,
            saleRequestId: 0,
          ),
        );

        expect(state.value!.products!.first.quantity, 3.0);
        expect(state.value!.products!.first.value, 10.0);
      },
    );

    test(
      'updateItemQuantity should use getPrice (retail) when WholePracticedPrice is 0',
      () async {
        final container = ProviderContainer(
          overrides: [
            paymentOptionsStateControllerProvider(
              1,
            ).overrideWith(() => FakePaymentOptionsController([])),
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

        final product =
            EntityFactory.makeProductEntity(
              productPackingCode: 123,
              enterpriseCode: 1,
            ).copyWith(
              RetailPracticedPrice: 10.0,
              WholePracticedPrice: 0.0,
              MinimumWholeQuantity: 5.0,
              Value: 0,
              PriceCost: EntityFactory.makePriceCost().copyWith(
                RetailPracticedPrice: 10.0,
                WholePracticedPrice: 0.0,
                MinimumWholeQuantity: 5.0,
              ),
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

        controller.updateItemQuantity(item, 10.0);

        final state = container.read(
          insertUpdateStateControllerProvider(
            enterpriseCode: 1,
            customerCode: 1,
            saleRequestId: 0,
          ),
        );

        expect(state.value!.products!.first.quantity, 10.0);
        expect(state.value!.products!.first.value, 10.0);
      },
    );

    test(
      'updateItemQuantity should use getPrice (retail) when MinimumWholeQuantity is 0',
      () async {
        final container = ProviderContainer(
          overrides: [
            paymentOptionsStateControllerProvider(
              1,
            ).overrideWith(() => FakePaymentOptionsController([])),
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

        final product =
            EntityFactory.makeProductEntity(
              productPackingCode: 123,
              enterpriseCode: 1,
            ).copyWith(
              RetailPracticedPrice: 10.0,
              WholePracticedPrice: 8.0,
              MinimumWholeQuantity: 0.0,
              Value: 0,
              PriceCost: EntityFactory.makePriceCost().copyWith(
                RetailPracticedPrice: 10.0,
                WholePracticedPrice: 8.0,
                MinimumWholeQuantity: 0.0,
              ),
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

        controller.updateItemQuantity(item, 10.0);

        final state = container.read(
          insertUpdateStateControllerProvider(
            enterpriseCode: 1,
            customerCode: 1,
            saleRequestId: 0,
          ),
        );

        expect(state.value!.products!.first.quantity, 10.0);
        expect(state.value!.products!.first.value, 10.0);
      },
    );

    test(
      'updateItemQuantity should update quantity when item is not null and quantity is between 0 and 1',
      () async {
        final container = ProviderContainer(
          overrides: [
            paymentOptionsStateControllerProvider(
              1,
            ).overrideWith(() => FakePaymentOptionsController([])),
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

        // ACT: Update to 0.5
        controller.updateItemQuantity(item, 0.5);

        final state = container.read(
          insertUpdateStateControllerProvider(
            enterpriseCode: 1,
            customerCode: 1,
            saleRequestId: 0,
          ),
        );

        expect(state.value!.products!.first.quantity, 0.5);
      },
    );

    test(
      'updateItemQuantity should remove item when quantity is 0 or less',
      () async {
        final container = ProviderContainer(
          overrides: [
            paymentOptionsStateControllerProvider(
              1,
            ).overrideWith(() => FakePaymentOptionsController([])),
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

        controller.updateItemQuantity(item, 0);

        final state = container.read(
          insertUpdateStateControllerProvider(
            enterpriseCode: 1,
            customerCode: 1,
            saleRequestId: 0,
          ),
        );

        expect(state.value!.products, isEmpty);
      },
    );
    test(
      'updateItemQuantity should remove item when quantity is negative',
      () async {
        final container = ProviderContainer(
          overrides: [
            paymentOptionsStateControllerProvider(
              1,
            ).overrideWith(() => FakePaymentOptionsController([])),
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

        controller.updateItemQuantity(item, -1.0);

        final state = container.read(
          insertUpdateStateControllerProvider(
            enterpriseCode: 1,
            customerCode: 1,
            saleRequestId: 0,
          ),
        );

        // ASSERT: Cart should be empty (item was removed)
        expect(state.value!.products, isEmpty);
      },
    );

    test('updateItemQuantity should remove item when quantity is 0', () async {
      final container = ProviderContainer(
        overrides: [
          paymentOptionsStateControllerProvider(
            1,
          ).overrideWith(() => FakePaymentOptionsController([])),
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

      controller.updateItemQuantity(item, 0.0);

      final state = container.read(
        insertUpdateStateControllerProvider(
          enterpriseCode: 1,
          customerCode: 1,
          saleRequestId: 0,
        ),
      );

      // ASSERT: Cart should be empty (item was removed)
      expect(state.value!.products, isEmpty);
    });

    test(
      'removeItem should remove item from cart by matching productPackingCode',
      () async {
        final container = ProviderContainer(
          overrides: [
            paymentOptionsStateControllerProvider(
              1,
            ).overrideWith(() => FakePaymentOptionsController([])),
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

        // Get the added item
        final addedItem = container
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

        // Create a "different" instance with same productPackingCode
        final sameItemDifferentInstance = addedItem.copyWith(quantity: 99);

        controller.removeItem(sameItemDifferentInstance);

        final state = container.read(
          insertUpdateStateControllerProvider(
            enterpriseCode: 1,
            customerCode: 1,
            saleRequestId: 0,
          ),
        );
        expect(state.value!.products, isEmpty);
      },
    );

    test(
      'updateItem should replace item in cart by matching productPackingCode',
      () async {
        final container = ProviderContainer(
          overrides: [
            paymentOptionsStateControllerProvider(
              1,
            ).overrideWith(() => FakePaymentOptionsController([])),
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

        final addedItem = container
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

        final updatedItem = addedItem.copyWith(quantity: 10);

        controller.updateItem(addedItem, updatedItem);

        final state = container.read(
          insertUpdateStateControllerProvider(
            enterpriseCode: 1,
            customerCode: 1,
            saleRequestId: 0,
          ),
        );
        expect(state.value!.products!.first.quantity, 10);
      },
    );
  });
}
