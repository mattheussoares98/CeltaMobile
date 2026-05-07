import 'dart:async';

import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../mocks/mocks.dart';
import 'fakers.dart';

class FakePaymentOptionsController extends PaymentOptionsStateController {
  final List<BSFPaymentFinalizationEntity> entities;
  bool wasCalled = false;
  FakePaymentOptionsController(this.entities);

  @override
  FutureOr<List<BSFPaymentFinalizationEntity>> build({
    required int customerCode,
    required int enterpriseCode,
    required int saleRequestCode,
  }) {
    wasCalled = true;
    return entities;
  }
}

void main() {
  late int enterpriseCode;
  late int customerCode;
  late FakePaymentOptionsController fakePaymentsController;
  late List<BSFPaymentFinalizationEntity> fakePayments;
  late BSFSaleRequestEntity fakeSaleRequest;

  ProviderContainer makeProviderContainer({required int saleRequestId}) {
    final container = ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        paymentOptionsStateControllerProvider(
          enterpriseCode: enterpriseCode,
          customerCode: customerCode,
          saleRequestCode: saleRequestId,
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
          final container = makeProviderContainer(saleRequestId: 0);

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
          final container = makeProviderContainer(saleRequestId: 1);

          final result = await container.read(
            insertUpdateStateControllerProvider(
              enterpriseCode: enterpriseCode,
              customerCode: customerCode,
              saleRequestId: 1,
            ).future,
          );

          expect(result, fakeSaleRequest);
          expect(fakePaymentsController.wasCalled, isTrue);
        },
      );
    });

    group('Add Item', () {
      test('addItem should add a new product to the cart', () async {
        final container = makeProviderContainer(saleRequestId: 0);

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
          final container = makeProviderContainer(saleRequestId: 0);

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
        final container = makeProviderContainer(saleRequestId: 0);

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

    group("Increase or decrease unit", () {
      AsyncValue<BSFSaleRequestEntity> getCurrentState(
        ProviderContainer container,
      ) => container.read(
        insertUpdateStateControllerProvider(
          enterpriseCode: enterpriseCode,
          customerCode: customerCode,
          saleRequestId: 0,
        ),
      );
      test('increaseOrDecreaseUnit should behave correctly', () async {
        final container = makeProviderContainer(saleRequestId: 0);

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

        final state = getCurrentState(container);
        expect(state.value!.products!.length, 1);
        expect(state.value!.products!.first.quantity, 1);

        controller.increaseOrDecreaseUnit(state.value!.products!.first, true);
        final state2 = getCurrentState(container);
        expect(state2.value!.products!.length, 1);
        expect(state2.value!.products!.first.quantity, 2);

        controller.increaseOrDecreaseUnit(state2.value!.products!.first, false);
        final state3 = getCurrentState(container);
        expect(state3.value!.products!.length, 1);
        expect(state3.value!.products!.first.quantity, 1);

        controller.increaseOrDecreaseUnit(state3.value!.products!.first, false);
        final state4 = getCurrentState(container);
        expect(state4.value!.products!, isEmpty);
      });

      test(
        'increaseOrDecreaseUnit use the correct price when there is minimum whole quantity and whole price',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);

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

          final product =
              EntityFactory.makeProductEntity(
                plu: faker.guid.guid().toString(),
                enterpriseCode: enterpriseCode,
              ).copyWith(
                RetailPracticedPrice: retailPrice,
                WholePracticedPrice: wholePrice,
                MinimumWholeQuantity: 2,
                Value: 0,
                PriceCost: EntityFactory.makePriceCost().copyWith(
                  RetailPracticedPrice: retailPrice,
                  WholePracticedPrice: wholePrice,
                  MinimumWholeQuantity: 2,
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

          final state = getCurrentState(container);
          expect(state.value!.products!.first.quantity, 1);
          expect(state.value!.products!.first.value, retailPrice);

          controller.increaseOrDecreaseUnit(item, true);
          final state2 = getCurrentState(container);
          expect(state2.value!.products!.first.quantity, 2);
          expect(state2.value!.products!.first.value, wholePrice);
        },
      );

      test(
        'Should use retail price when has minimum whole quantity but whole price is zero',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);

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

          final product =
              EntityFactory.makeProductEntity(
                plu: faker.guid.guid().toString(),
                enterpriseCode: enterpriseCode,
              ).copyWith(
                RetailPracticedPrice: retailPrice,
                WholePracticedPrice: 0,
                MinimumWholeQuantity: 2,
                Value: 0,
                PriceCost: EntityFactory.makePriceCost().copyWith(
                  RetailPracticedPrice: retailPrice,
                  WholePracticedPrice: 0,
                  MinimumWholeQuantity: 2,
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

          final state = getCurrentState(container);
          expect(state.value!.products!.first.quantity, 1);
          expect(state.value!.products!.first.value, retailPrice);

          controller.increaseOrDecreaseUnit(item, true);
          final state2 = getCurrentState(container);
          expect(state2.value!.products!.first.quantity, 2);
          expect(state2.value!.products!.first.value, retailPrice);
        },
      );
      test(
        "Should use retail price when doesn't has minimum whole quantity and has whole price",
        () async {
          final container = makeProviderContainer(saleRequestId: 0);

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

          final product =
              EntityFactory.makeProductEntity(
                plu: faker.guid.guid().toString(),
                enterpriseCode: enterpriseCode,
              ).copyWith(
                RetailPracticedPrice: retailPrice,
                WholePracticedPrice: wholePrice,
                MinimumWholeQuantity: 0,
                Value: 0,
                PriceCost: EntityFactory.makePriceCost().copyWith(
                  RetailPracticedPrice: retailPrice,
                  WholePracticedPrice: wholePrice,
                  MinimumWholeQuantity: 0,
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

          final state = getCurrentState(container);
          expect(state.value!.products!.first.quantity, 1);
          expect(state.value!.products!.first.value, retailPrice);

          controller.increaseOrDecreaseUnit(item, true);
          final state2 = getCurrentState(container);
          expect(state2.value!.products!.first.quantity, 2);
          expect(state2.value!.products!.first.value, retailPrice);
        },
      );
    });

    group("Remove item", () {
      test(
        'removeItem should remove item from cart by matching productPackingCode',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);

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
        final container = makeProviderContainer(saleRequestId: 0);

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
    group('Add Payment', () {
      test(
        'addPayment should add a new payment without credit card properties',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);

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

          final payment = fakePayments.first;
          final value = faker.randomGenerator.decimal() * 100;

          controller.addPayment(payment: payment, value: value);

          final state = container.read(
            insertUpdateStateControllerProvider(
              enterpriseCode: enterpriseCode,
              customerCode: customerCode,
              saleRequestId: 0,
            ),
          );

          expect(state.value!.financials!.length, 1);
          expect(state.value!.financials!.first.paymentFinalizations!.length, 1);
          final addedPayment =
              state.value!.financials!.first.paymentFinalizations!.first;
          expect(addedPayment.paymentFinalization, payment);
          expect(addedPayment.value, value);
          expect(addedPayment.creditCardNumber, isNull);
          expect(addedPayment.creditCardValidate, isNull);
        },
      );

      test(
        'addPayment should add a new payment with credit card properties',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);

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

          final payment = fakePayments.first;
          final value = faker.randomGenerator.decimal() * 100;
          final creditCardProperties = CreditCardPropertiesEntity(
            creditCardNumber: faker.randomGenerator.numberOfLength(16),
            creditCardValidate: faker.date.dateTime(),
            quantityOfPortions: faker.randomGenerator.integer(12, min: 1),
          );

          controller.addPayment(
            payment: payment,
            value: value,
            creditCardProperties: creditCardProperties,
          );

          final state = container.read(
            insertUpdateStateControllerProvider(
              enterpriseCode: enterpriseCode,
              customerCode: customerCode,
              saleRequestId: 0,
            ),
          );

          final addedPayment =
              state.value!.financials!.first.paymentFinalizations!.first;
          expect(
            addedPayment.creditCardNumber,
            creditCardProperties.creditCardNumber,
          );
          expect(
            addedPayment.creditCardValidate,
            creditCardProperties.creditCardValidate,
          );
          expect(
            addedPayment.quantityOfPortions,
            creditCardProperties.quantityOfPortions,
          );
        },
      );
    });
  });
}
