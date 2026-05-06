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

      test('addItem should not add product if price is 0 or less', () async {
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

        final productWithZeroPrice = EntityFactory.makeProductEntity(
          plu: faker.guid.guid().toString(),
          enterpriseCode: enterpriseCode,
          RetailPracticedPrice: 0,
        ).copyWith(Value: 0);

        controller.addItem(productWithZeroPrice);

        final state = container.read(
          insertUpdateStateControllerProvider(
            enterpriseCode: enterpriseCode,
            customerCode: customerCode,
            saleRequestId: 0,
          ),
        );

        expect(state.value!.products ?? [], isEmpty);
      });
    });

    group("Update quantity", () {
      test(
        'updateItemQuantity should update quantity when item is in cart',
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
            plu: faker.guid.guid().toString(),
            enterpriseCode: enterpriseCode,
          );

          controller.addItem(product);
          final item = container
              .read(
                insertUpdateStateControllerProvider(
                  enterpriseCode: enterpriseCode,
                  customerCode: customerCode,
                  saleRequestId: 0,
                ),
              )
              .value!
              .products!
              .first;

          final newQuantity = faker.randomGenerator.decimal();
          controller.updateItemQuantity(item, newQuantity);

          final state = container.read(
            insertUpdateStateControllerProvider(
              enterpriseCode: enterpriseCode,
              customerCode: customerCode,
              saleRequestId: 0,
            ),
          );

          expect(state.value!.products!.length, 1);
          expect(state.value!.products!.first.quantity, newQuantity);
        },
      );
      test(
        'updateItemQuantity should update quantity when item is not null',
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
            plu: faker.guid.guid().toString(),
            enterpriseCode: enterpriseCode,
          );

          controller.addItem(product);
          final item = container
              .read(
                insertUpdateStateControllerProvider(
                  enterpriseCode: enterpriseCode,
                  customerCode: customerCode,
                  saleRequestId: 0,
                ),
              )
              .value!
              .products!
              .first;

          final newQuantity = faker.randomGenerator.decimal();
          controller.updateItemQuantity(item, newQuantity);

          final state = container.read(
            insertUpdateStateControllerProvider(
              enterpriseCode: enterpriseCode,
              customerCode: customerCode,
              saleRequestId: 0,
            ),
          );

          expect(state.value!.products!.first.quantity, newQuantity);
        },
      );

      test(
        'updateItemQuantity should use WholePracticedPrice when quantity >= MinimumWholeQuantity',
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

          final retailPrice = faker.randomGenerator.decimal();
          final wholePrice = faker.randomGenerator.decimal();
          final minimumWholeQuantity = faker.randomGenerator.decimal();

          final product =
              EntityFactory.makeProductEntity(
                plu: faker.guid.guid().toString(),
                enterpriseCode: enterpriseCode,
              ).copyWith(
                RetailPracticedPrice: retailPrice,
                WholePracticedPrice: wholePrice,
                MinimumWholeQuantity: minimumWholeQuantity,
                Value: 0,
                PriceCost: EntityFactory.makePriceCost().copyWith(
                  RetailPracticedPrice: retailPrice,
                  WholePracticedPrice: wholePrice,
                  MinimumWholeQuantity: minimumWholeQuantity,
                ),
              );

          controller.addItem(product);
          final item = container
              .read(
                insertUpdateStateControllerProvider(
                  enterpriseCode: enterpriseCode,
                  customerCode: customerCode,
                  saleRequestId: 0,
                ),
              )
              .value!
              .products!
              .first;

          controller.updateItemQuantity(item, minimumWholeQuantity);

          final state = container.read(
            insertUpdateStateControllerProvider(
              enterpriseCode: enterpriseCode,
              customerCode: customerCode,
              saleRequestId: 0,
            ),
          );

          expect(state.value!.products!.first.quantity, minimumWholeQuantity);
          expect(state.value!.products!.first.value, wholePrice);
        },
      );

      test(
        'updateItemQuantity should use getPrice (retail) when quantity < MinimumWholeQuantity',
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

          final retailPrice = faker.randomGenerator.integer(100).toDouble();
          final wholePrice = faker.randomGenerator.integer(100).toDouble();
          final minimumWholeQuantity = faker.randomGenerator
              .integer(100)
              .toDouble();

          final product =
              EntityFactory.makeProductEntity(
                plu: faker.guid.guid().toString(),
                enterpriseCode: enterpriseCode,
              ).copyWith(
                RetailPracticedPrice: retailPrice,
                WholePracticedPrice: wholePrice,
                MinimumWholeQuantity: minimumWholeQuantity,
                Value: 0,
                PriceCost: EntityFactory.makePriceCost().copyWith(
                  RetailPracticedPrice: retailPrice,
                  WholePracticedPrice: wholePrice,
                  MinimumWholeQuantity: minimumWholeQuantity,
                ),
              );

          controller.addItem(product);
          final item = container
              .read(
                insertUpdateStateControllerProvider(
                  enterpriseCode: enterpriseCode,
                  customerCode: customerCode,
                  saleRequestId: 0,
                ),
              )
              .value!
              .products!
              .first;

          final newQuantity = minimumWholeQuantity - 0.001;
          controller.updateItemQuantity(item, newQuantity);

          final state = container.read(
            insertUpdateStateControllerProvider(
              enterpriseCode: enterpriseCode,
              customerCode: customerCode,
              saleRequestId: 0,
            ),
          );

          expect(state.value!.products!.first.quantity, newQuantity);
          expect(state.value!.products!.first.value, retailPrice);
        },
      );

      test(
        'updateItemQuantity should use getPrice (retail) when WholePracticedPrice is 0',
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

          final retailPrice = faker.randomGenerator.integer(100).toDouble();
          final minimumWholeQuantity = faker.randomGenerator
              .integer(100)
              .toDouble();

          final product =
              EntityFactory.makeProductEntity(
                plu: faker.guid.guid().toString(),
                enterpriseCode: enterpriseCode,
              ).copyWith(
                RetailPracticedPrice: retailPrice,
                WholePracticedPrice: 0.0,
                MinimumWholeQuantity: minimumWholeQuantity,
                Value: 0,
                PriceCost: EntityFactory.makePriceCost().copyWith(
                  RetailPracticedPrice: retailPrice,
                  WholePracticedPrice: 0.0,
                  MinimumWholeQuantity: minimumWholeQuantity,
                ),
              );

          controller.addItem(product);
          final item = container
              .read(
                insertUpdateStateControllerProvider(
                  enterpriseCode: enterpriseCode,
                  customerCode: customerCode,
                  saleRequestId: 0,
                ),
              )
              .value!
              .products!
              .first;

          final newQuantity = faker.randomGenerator.integer(100).toDouble();
          controller.updateItemQuantity(item, newQuantity);

          final state = container.read(
            insertUpdateStateControllerProvider(
              enterpriseCode: enterpriseCode,
              customerCode: customerCode,
              saleRequestId: 0,
            ),
          );

          expect(state.value!.products!.first.quantity, newQuantity);
          expect(state.value!.products!.first.value, retailPrice);
        },
      );

      test(
        'updateItemQuantity should remove item when quantity is 0 or less',
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
            plu: faker.guid.guid().toString(),
            enterpriseCode: enterpriseCode,
          );

          controller.addItem(product);
          final item = container
              .read(
                insertUpdateStateControllerProvider(
                  enterpriseCode: enterpriseCode,
                  customerCode: customerCode,
                  saleRequestId: 0,
                ),
              )
              .value!
              .products!
              .first;

          controller.updateItemQuantity(item, 0);

          final state = container.read(
            insertUpdateStateControllerProvider(
              enterpriseCode: enterpriseCode,
              customerCode: customerCode,
              saleRequestId: 0,
            ),
          );

          expect(state.value!.products, isEmpty);
        },
      );

      test(
        'updateItemQuantity should remove item when quantity is equal or less than zero',
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
            plu: faker.guid.guid().toString(),
            enterpriseCode: enterpriseCode,
          );

          controller.addItem(product);
          final item = container
              .read(
                insertUpdateStateControllerProvider(
                  enterpriseCode: enterpriseCode,
                  customerCode: customerCode,
                  saleRequestId: 0,
                ),
              )
              .value!
              .products!
              .first;

          final newQuantity = faker.randomGenerator.boolean()
              ? 0.0
              : (0 - faker.randomGenerator.decimal());
          controller.updateItemQuantity(item, newQuantity);

          final state = container.read(
            insertUpdateStateControllerProvider(
              enterpriseCode: enterpriseCode,
              customerCode: customerCode,
              saleRequestId: 0,
            ),
          );

          // ASSERT: Cart should be empty (item was removed)
          expect(state.value!.products, isEmpty);
        },
      );
    });

    group("Remove item", () {
      test(
        'removeItem should remove item from cart by matching productPackingCode',
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
            plu: faker.guid.guid().toString(),
            enterpriseCode: enterpriseCode,
          );
          controller.addItem(product);

          // Get the added item
          final addedItem = container
              .read(
                insertUpdateStateControllerProvider(
                  enterpriseCode: enterpriseCode,
                  customerCode: customerCode,
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
              enterpriseCode: enterpriseCode,
              customerCode: customerCode,
              saleRequestId: 0,
            ),
          );
          expect(state.value!.products, isEmpty);
        },
      );
    });

    group("Update item", () {
      test('updateItem should replace item in cart by matching PLU', () async {
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
          plu: faker.guid.guid().toString(),
          enterpriseCode: enterpriseCode,
        );
        controller.addItem(product);

        final addedItem = container
            .read(
              insertUpdateStateControllerProvider(
                enterpriseCode: enterpriseCode,
                customerCode: customerCode,
                saleRequestId: 0,
              ),
            )
            .value!
            .products!
            .first;

        final newQuantity = faker.randomGenerator.decimal();
        final updatedItem = addedItem.copyWith(quantity: newQuantity);

        controller.updateItem(addedItem, updatedItem);

        final state = container.read(
          insertUpdateStateControllerProvider(
            enterpriseCode: enterpriseCode,
            customerCode: customerCode,
            saleRequestId: 0,
          ),
        );
        expect(state.value!.products!.first.quantity, newQuantity);
      });
    });
  });
}
