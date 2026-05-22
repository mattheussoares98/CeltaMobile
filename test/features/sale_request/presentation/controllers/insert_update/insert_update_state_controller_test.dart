import 'dart:async';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/presentation/models/models.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../mocks/mocks.dart';
import '../fakers.dart';

class FakePaymentFinalizationsController
    extends FilteredPaymentFinalizationsStateController {
  final List<BSFPaymentFinalizationEntity> entities;
  bool wasCalled = false;
  FakePaymentFinalizationsController(this.entities);

  @override
  FutureOr<List<BSFPaymentFinalizationEntity>> build() {
    wasCalled = true;
    return entities;
  }
}

void main() {
  late FakePaymentFinalizationsController fakePaymentsController;
  late FakeSearchedCustomersStateController fakeSearchedCustomersController;
  late List<BSFPaymentFinalizationEntity> fakePayments;
  late BSFSaleRequestEntity fakeSaleRequest;
  late SaleRequestArgs fakeArgs;

  ProviderContainer makeProviderContainer({required int saleRequestId}) {
    final args = fakeArgs.copyWith(saleRequestId: saleRequestId);
    final container = ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        saleRequestArgsProvider.overrideWithValue(args),
        filteredPaymentFinalizationsStateControllerProvider.overrideWith(
          () => fakePaymentsController,
        ),
        saleRequestDetailsStateControllerProvider(
          args,
        ).overrideWith(() => FakeSaleRequestDetailsController(fakeSaleRequest)),
        searchedCustomersStateControllerProvider.overrideWith(
          () => fakeSearchedCustomersController,
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() {
    fakeSaleRequest = EntityFactory.makeBSFSaleRequestEntity();
    fakePayments = [
      EntityFactory.makeBSFPaymentFinalizationEntity().copyWith(
        action: EntityFactory.makeBSFPaymentActionEntity().copyWith(
          type: PaymentFinalizationActionType.money,
        ),
      ),
      EntityFactory.makeBSFPaymentFinalizationEntity().copyWith(
        action: EntityFactory.makeBSFPaymentActionEntity().copyWith(
          type: PaymentFinalizationActionType.money,
        ),
      ),
      EntityFactory.makeBSFPaymentFinalizationEntity().copyWith(
        action: EntityFactory.makeBSFPaymentActionEntity().copyWith(
          type: PaymentFinalizationActionType.money,
        ),
      ),
    ];

    fakePaymentsController = FakePaymentFinalizationsController(fakePayments);
    fakeSearchedCustomersController = FakeSearchedCustomersStateController(
      SearchedCustomersState(
        customers: [
          EntityFactory.makeBSFCustomerEntity(),
          EntityFactory.makeBSFCustomerEntity(),
        ],
        errorMessage: null,
      ),
    );
    fakeArgs = SaleRequestArgs(
      customerCode: fakeSaleRequest.customer?.code ?? 0,
      enterpriseCode: fakeSaleRequest.enterprise?.code ?? 0,
      saleRequestId: fakeSaleRequest.code ?? 0,
    );
  });

  group('InsertUpdateStateController', () {
    group('build', () {
      test(
        'should return empty entity when saleRequestId is 0 and load payment options',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);

          final result = await container.read(
            insertUpdateStateControllerProvider.future,
          );

          expect(result, BSFSaleRequestEntity.empty());
          expect(fakePaymentsController.wasCalled, isFalse);
        },
      );

      test(
        'should return data from saleRequestDetailsStateControllerProvider when saleRequestId is not 0 and load payment options',
        () async {
          final container = makeProviderContainer(saleRequestId: 1);

          final result = await container.read(
            insertUpdateStateControllerProvider.future,
          );

          expect(result, fakeSaleRequest);
          expect(fakePaymentsController.wasCalled, isFalse);
        },
      );
    });

    group('Add Item', () {
      test('addItem should add a new product to the cart', () async {
        final container = makeProviderContainer(saleRequestId: 0);

        final controller = container.read(
          insertUpdateStateControllerProvider.notifier,
        );

        await container.read(insertUpdateStateControllerProvider.future);

        final product = EntityFactory.makeProductEntity(
          productPackingCode: faker.randomGenerator.integer(100),
          enterpriseCode: fakeArgs.enterpriseCode,
        );

        controller.addItem(product);

        final state = container.read(insertUpdateStateControllerProvider);

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
            insertUpdateStateControllerProvider.notifier,
          );

          await container.read(insertUpdateStateControllerProvider.future);

          final product = EntityFactory.makeProductEntity(
            plu: faker.guid.guid(),
            enterpriseCode: fakeArgs.enterpriseCode,
          );

          controller.addItem(product);
          controller.addItem(product);

          final state = container.read(insertUpdateStateControllerProvider);

          expect(state.value!.products!.length, 1);
          expect(state.value!.products!.first.quantity, 2);
        },
      );

      test('addItem should not add product if price is 0 or less', () async {
        final container = makeProviderContainer(saleRequestId: 0);

        final controller = container.read(
          insertUpdateStateControllerProvider.notifier,
        );

        await container.read(insertUpdateStateControllerProvider.future);

        final productWithZeroPrice = EntityFactory.makeProductEntity(
          plu: faker.guid.guid().toString(),
          enterpriseCode: fakeArgs.enterpriseCode,
          RetailPracticedPrice: 0,
        ).copyWith(Value: 0);

        controller.addItem(productWithZeroPrice);

        final state = container.read(insertUpdateStateControllerProvider);

        expect(state.value!.products ?? [], isEmpty);
      });
    });

    group("Increase or decrease unit", () {
      AsyncValue<BSFSaleRequestEntity> getCurrentState(
        ProviderContainer container,
      ) => container.read(insertUpdateStateControllerProvider);
      test('increaseOrDecreaseUnit should behave correctly', () async {
        final container = makeProviderContainer(saleRequestId: 0);

        final controller = container.read(
          insertUpdateStateControllerProvider.notifier,
        );

        await container.read(insertUpdateStateControllerProvider.future);

        final product = EntityFactory.makeProductEntity(
          plu: faker.guid.guid().toString(),
          enterpriseCode: fakeArgs.enterpriseCode,
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
            insertUpdateStateControllerProvider.notifier,
          );

          await container.read(insertUpdateStateControllerProvider.future);

          final retailPrice = faker.randomGenerator.decimal();
          final wholePrice = faker.randomGenerator.decimal();

          final product =
              EntityFactory.makeProductEntity(
                plu: faker.guid.guid().toString(),
                enterpriseCode: fakeArgs.enterpriseCode,
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
              .read(insertUpdateStateControllerProvider)
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
            insertUpdateStateControllerProvider.notifier,
          );

          await container.read(insertUpdateStateControllerProvider.future);

          final retailPrice = faker.randomGenerator.decimal();

          final product =
              EntityFactory.makeProductEntity(
                plu: faker.guid.guid().toString(),
                enterpriseCode: fakeArgs.enterpriseCode,
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
              .read(insertUpdateStateControllerProvider)
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
            insertUpdateStateControllerProvider.notifier,
          );

          await container.read(insertUpdateStateControllerProvider.future);

          final retailPrice = faker.randomGenerator.decimal();
          final wholePrice = faker.randomGenerator.decimal();

          final product =
              EntityFactory.makeProductEntity(
                plu: faker.guid.guid().toString(),
                enterpriseCode: fakeArgs.enterpriseCode,
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
              .read(insertUpdateStateControllerProvider)
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
            insertUpdateStateControllerProvider.notifier,
          );

          await container.read(insertUpdateStateControllerProvider.future);

          final product = EntityFactory.makeProductEntity(
            plu: faker.guid.guid().toString(),
            enterpriseCode: fakeArgs.enterpriseCode,
          );
          controller.addItem(product);

          // Get the added item
          final addedItem = container
              .read(insertUpdateStateControllerProvider)
              .value!
              .products!
              .first;

          // Create a "different" instance with same productPackingCode
          final sameItemDifferentInstance = addedItem.copyWith(quantity: 99);

          controller.removeItem(sameItemDifferentInstance);

          final state = container.read(insertUpdateStateControllerProvider);
          expect(state.value!.products, isEmpty);
        },
      );
    });

    group("Update item", () {
      test('updateItem should replace item in cart by matching PLU', () async {
        final container = makeProviderContainer(saleRequestId: 0);

        final controller = container.read(
          insertUpdateStateControllerProvider.notifier,
        );

        await container.read(insertUpdateStateControllerProvider.future);

        final product = EntityFactory.makeProductEntity(
          plu: faker.guid.guid().toString(),
          enterpriseCode: fakeArgs.enterpriseCode,
        );
        controller.addItem(product);

        final addedItem = container
            .read(insertUpdateStateControllerProvider)
            .value!
            .products!
            .first;

        final newQuantity = faker.randomGenerator.decimal();
        final updatedItem = addedItem.copyWith(quantity: newQuantity);

        controller.updateItem(addedItem, updatedItem);

        final state = container.read(insertUpdateStateControllerProvider);
        expect(state.value!.products!.first.quantity, newQuantity);
      });
    });
    group('Add Payment', () {
      test(
        'addPayment should add a new payment without credit card properties',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);

          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );

          await container.read(insertUpdateStateControllerProvider.future);

          final payment = fakePayments.first;
          const value = 100.0;

          // Add a product first so there is available balance
          controller.addItem(
            EntityFactory.makeProductEntity(
              enterpriseCode: fakeArgs.enterpriseCode,
            ).copyWith(RetailPracticedPrice: 200, Value: 200),
          );

          final (success, error) = controller.addPayment(
            payment: payment,
            value: value,
          );

          expect(success, isTrue);
          expect(error, isNull);

          final state = container.read(insertUpdateStateControllerProvider);

          expect(state.value!.financials!.length, 1);
          expect(
            state.value!.financials!.first.paymentFinalizations!.length,
            1,
          );
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
            insertUpdateStateControllerProvider.notifier,
          );

          await container.read(insertUpdateStateControllerProvider.future);

          final payment = fakePayments.first;
          const value = 100.0;
          final creditCardProperties =
              EntityFactory.makeCreditCardPropertiesEntity();

          // Add a product first so there is available balance
          controller.addItem(
            EntityFactory.makeProductEntity(
              enterpriseCode: fakeArgs.enterpriseCode,
            ).copyWith(RetailPracticedPrice: 200, Value: 200),
          );

          final (success, error) = controller.addPayment(
            payment: payment,
            value: value,
            creditCardProperties: creditCardProperties,
          );

          expect(success, isTrue);
          expect(error, isNull);

          final state = container.read(insertUpdateStateControllerProvider);

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

      test('Should add finalization with correct condition payment', () async {
        final container = makeProviderContainer(saleRequestId: 0);

        final controller = container.read(
          insertUpdateStateControllerProvider.notifier,
        );

        await container.read(insertUpdateStateControllerProvider.future);

        //select the payment condition
        final paymentCondition = EntityFactory.makeBSFPaymentConditionEntity();
        container
            .read(selectedPaymentConditionStateControllerProvider.notifier)
            .select(paymentCondition);

        expect(
          container.read(selectedPaymentConditionStateControllerProvider),
          paymentCondition,
        );

        // Add a product first so there is available balance
        controller.addItem(
          EntityFactory.makeProductEntity(
            enterpriseCode: fakeArgs.enterpriseCode,
          ).copyWith(RetailPracticedPrice: 200, Value: 200),
        );

        // Call addPayment
        final (success, error) = controller.addPayment(
          payment: fakePayments.first,
          value: 100.0,
        );

        expect(success, isTrue);
        expect(error, isNull);

        final state = container.read(insertUpdateStateControllerProvider);

        final addedPayment =
            state.value!.financials!.first.paymentFinalizations!.first;
        expect(addedPayment.paymentCondition, paymentCondition);
      });

      test(
        'addPayment should invalidate selectedPaymentType, selectedPaymentCondition and selectedCovenant providers',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);

          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );

          await container.read(insertUpdateStateControllerProvider.future);

          // Set initial values in selection providers
          final paymentType = EntityFactory.makeBSFPaymentFinalizationEntity();
          final paymentCondition =
              EntityFactory.makeBSFPaymentConditionEntity();

          container
              .read(selectedPaymentTypeStateControllerProvider.notifier)
              .select(paymentType);
          container
              .read(selectedPaymentConditionStateControllerProvider.notifier)
              .select(paymentCondition);

          expect(
            container.read(selectedPaymentTypeStateControllerProvider),
            paymentType,
          );
          expect(
            container.read(selectedPaymentConditionStateControllerProvider),
            paymentCondition,
          );

          // Add a product first so there is available balance
          controller.addItem(
            EntityFactory.makeProductEntity(
              enterpriseCode: fakeArgs.enterpriseCode,
            ).copyWith(RetailPracticedPrice: 200, Value: 200),
          );

          // Call addPayment
          final (success, error) = controller.addPayment(
            payment: fakePayments.first,
            value: 100.0,
          );

          expect(success, isTrue);
          expect(error, isNull);

          // Verify they are now null
          expect(
            container.read(selectedPaymentTypeStateControllerProvider),
            isNull,
          );
          expect(
            container.read(selectedPaymentConditionStateControllerProvider),
            isNull,
          );
        },
      );

      test('Should return error when value exceeds available', () async {
        final container = makeProviderContainer(saleRequestId: 0);

        final controller = container.read(
          insertUpdateStateControllerProvider.notifier,
        );

        await container.read(insertUpdateStateControllerProvider.future);

        // Add a product with price 50
        controller.addItem(
          EntityFactory.makeProductEntity(
            enterpriseCode: fakeArgs.enterpriseCode,
          ).copyWith(RetailPracticedPrice: 50, Value: 50),
        );

        // Try to add a payment of 100
        final (success, error) = controller.addPayment(
          payment: fakePayments.first,
          value: 100.0,
        );

        expect(success, isFalse);
        expect(error, isNotEmpty);
        expect(error, isNotNull);
      });
    });

    group('Remove Payment', () {
      test('removePayment should remove a payment', () async {
        final container = makeProviderContainer(saleRequestId: 0);

        final controller = container.read(
          insertUpdateStateControllerProvider.notifier,
        );

        await container.read(insertUpdateStateControllerProvider.future);

        controller.addItem(
          EntityFactory.makeProductEntity(
            enterpriseCode: fakeArgs.enterpriseCode,
          ).copyWith(RetailPracticedPrice: 200, Value: 200),
        );
        final value = faker.randomGenerator.decimal() * 100;

        controller.addPayment(payment: fakePayments[0], value: value);
        controller.addPayment(payment: fakePayments[1], value: value);

        final state = container.read(insertUpdateStateControllerProvider);

        expect(state.value!.financials!.first.paymentFinalizations!.length, 2);

        controller.removePayment(1);

        final state2 = container.read(insertUpdateStateControllerProvider);

        expect(state2.value!.financials!.first.paymentFinalizations!.length, 1);

        controller.removePayment(0);

        final state3 = container.read(insertUpdateStateControllerProvider);

        expect(state3.value!.financials!.first.paymentFinalizations, isEmpty);
      });
    });
    group('disposeFlow', () {
      test('should invalidate selection providers and itself', () async {
        const saleRequestId = 0; // Test with a new request
        final container = makeProviderContainer(saleRequestId: saleRequestId);

        final controller = container.read(
          insertUpdateStateControllerProvider.notifier,
        );

        //load the initial state
        await container.read(insertUpdateStateControllerProvider.future);

        // 1. Set some initial state in related providers
        final paymentType = EntityFactory.makeBSFPaymentFinalizationEntity();
        final paymentCondition = EntityFactory.makeBSFPaymentConditionEntity();

        container
            .read(selectedPaymentTypeStateControllerProvider.notifier)
            .select(paymentType);
        container
            .read(selectedPaymentConditionStateControllerProvider.notifier)
            .select(paymentCondition);

        // Load searched customers first so it's initialized (rebuildCount = 2)
        await container.read(searchedCustomersStateControllerProvider.future);
        expect(fakeSearchedCustomersController.rebuildCount, 2);

        // 2. Call disposeFlow and simulate UI disposal
        controller.disposeFlow();
        container.invalidate(searchedCustomersStateControllerProvider);

        // 3. Verify selection providers are reset
        expect(
          container.read(selectedPaymentTypeStateControllerProvider),
          isNull,
        );
        expect(
          container.read(selectedPaymentConditionStateControllerProvider),
          isNull,
        );
        await container.read(searchedCustomersStateControllerProvider.future);
        expect(fakeSearchedCustomersController.rebuildCount, 3);

        // 4. Verify main controller was reset to initial state (empty)
        final stateAfterDispose = await container.read(
          insertUpdateStateControllerProvider.future,
        );
        expect(stateAfterDispose.products ?? [], isEmpty);
      });
    });
    group('updateCustomer', () {
      test('Should toggle the selected customer correctly', () async {
        final container = makeProviderContainer(saleRequestId: 0);

        final controller = container.read(
          insertUpdateStateControllerProvider.notifier,
        );

        await container.read(insertUpdateStateControllerProvider.future);

        final customer1 = EntityFactory.makeBSFCustomerEntity();
        controller.updateCustomer(customer1);
        final state = container.read(insertUpdateStateControllerProvider);
        expect(
          state.value!.customer,
          customer1.copyWith(annulCovenantCode: true),
        );

        final customer2 = EntityFactory.makeBSFCustomerEntity();
        controller.updateCustomer(customer2);
        final state2 = container.read(insertUpdateStateControllerProvider);
        expect(
          state2.value!.customer,
          customer2.copyWith(annulCovenantCode: true),
        );

        final customer3 = EntityFactory.makeBSFCustomerEntity().copyWith(
          code: customer2.code,
        );
        //annul when is the same customer code from the previous
        controller.updateCustomer(customer3);
        final state3 = container.read(insertUpdateStateControllerProvider);
        expect(state3.value!.customer, null);
      });
      test(
        'Should reset payment type, condition and covenant when a customer is selected',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);

          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );

          await container.read(insertUpdateStateControllerProvider.future);

          //select paymentType, condition and covenant
          container
              .read(selectedPaymentTypeStateControllerProvider.notifier)
              .select(EntityFactory.makeBSFPaymentFinalizationEntity());
          container
              .read(selectedPaymentConditionStateControllerProvider.notifier)
              .select(EntityFactory.makeBSFPaymentConditionEntity());

          //confirm is selected
          expect(
            container.read(selectedPaymentConditionStateControllerProvider),
            isNotNull,
          );
          expect(
            container.read(selectedPaymentTypeStateControllerProvider),
            isNotNull,
          );

          //update customer
          controller.updateCustomer(EntityFactory.makeBSFCustomerEntity());

          //confirm is updated to null value
          expect(
            container.read(selectedPaymentConditionStateControllerProvider),
            isNull,
          );
          expect(
            container.read(selectedPaymentTypeStateControllerProvider),
            isNull,
          );
        },
      );
    });

    group('changeSeller', () {
      test('Should change the seller and set annulSeller correctly', () async {
        final container = makeProviderContainer(saleRequestId: 0);

        final controller = container.read(
          insertUpdateStateControllerProvider.notifier,
        );

        await container.read(insertUpdateStateControllerProvider.future);

        // Change to a new seller
        final seller1 = EntityFactory.makeSellerEntity();
        controller.changeSeller(seller1);
        final state1 = container.read(insertUpdateStateControllerProvider);
        expect(state1.value!.seller?.code, seller1.Id);
        
        // Change to a different seller
        final seller2 = EntityFactory.makeSellerEntity();
        controller.changeSeller(seller2);
        final state2 = container.read(insertUpdateStateControllerProvider);
        expect(state2.value!.seller?.code, seller2.Id);

        // Change to the same seller should annul it
        final seller3 = EcSellerEntity(Id: seller2.Id, Name: seller2.Name);
        controller.changeSeller(seller3);
        final state3 = container.read(insertUpdateStateControllerProvider);
        expect(state3.value!.seller, isNull);
      });
    });

    group('updateCustomerData', () {
      test(
        'Should update selected customer details without annulling selection',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);

          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );

          await container.read(insertUpdateStateControllerProvider.future);

          final originalCustomer = EntityFactory.makeBSFCustomerEntity()
              .copyWith(code: 1);

          controller.updateCustomer(originalCustomer);

          final updatedCustomer = EntityFactory.makeBSFCustomerEntity()
              .copyWith(code: 1);

          controller.updateCustomerData(updatedCustomer);

          final state = container.read(insertUpdateStateControllerProvider);
          expect(state.value!.customer!.code, 1);
          expect(state.value!.customer, updatedCustomer.copyWith(code: 1, annulCovenantCode: true, annulSelectedCovenant: true));
        },
      );

      test(
        'Should preserve selected covenant if still valid in updated customer covenants',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);

          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );

          await container.read(insertUpdateStateControllerProvider.future);

          final covenant = EntityFactory.makeBsfCovenantEntity().copyWith(
            code: 123,
          );
          final originalCustomer = EntityFactory.makeBSFCustomerEntity()
              .copyWith(code: 1, covenants: [covenant]);

          controller.updateCustomer(originalCustomer);
          controller.updateCovenant(originalCustomer, covenant);

          final stateBefore = container.read(
            insertUpdateStateControllerProvider,
          );
          expect(stateBefore.value!.customer!.covenantCode, 123);
          expect(stateBefore.value!.customer!.selectedCovenant, covenant);

          // Updated customer with new name but same covenant is still valid
          final updatedCustomer = originalCustomer.copyWith(
            name: 'Updated Customer Name',
            covenants: [covenant],
          );

          controller.updateCustomerData(updatedCustomer);

          final stateAfter = container.read(
            insertUpdateStateControllerProvider,
          );
          expect(stateAfter.value!.customer!.name, 'Updated Customer Name');
          expect(stateAfter.value!.customer!.covenantCode, 123);
          expect(stateAfter.value!.customer!.selectedCovenant, covenant);
        },
      );

      test(
        'Should annul selected covenant if no longer valid in updated customer covenants',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);

          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );

          await container.read(insertUpdateStateControllerProvider.future);

          final covenant = EntityFactory.makeBsfCovenantEntity().copyWith(
            code: 123,
          );
          final originalCustomer = EntityFactory.makeBSFCustomerEntity()
              .copyWith(code: 1, covenants: [covenant]);

          controller.updateCustomer(originalCustomer);
          controller.updateCovenant(originalCustomer, covenant);

          // Updated customer has different/no covenants now
          final otherCovenant = EntityFactory.makeBsfCovenantEntity().copyWith(
            code: 456,
          );
          final updatedCustomer = originalCustomer.copyWith(
            name: 'Updated Customer Name',
            covenants: [otherCovenant],
          );

          controller.updateCustomerData(updatedCustomer);

          final stateAfter = container.read(
            insertUpdateStateControllerProvider,
          );
          expect(stateAfter.value!.customer!.name, 'Updated Customer Name');
          expect(stateAfter.value!.customer!.covenantCode, isNull);
          expect(stateAfter.value!.customer!.selectedCovenant, isNull);
        },
      );
    });

    group('updateCovenant', () {
      test(
        'Should set covenant when a new covenant is selected for the same customer',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);

          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );

          await container.read(insertUpdateStateControllerProvider.future);

          final customer = EntityFactory.makeBSFCustomerEntity();
          controller.updateCustomer(customer);

          final covenant = EntityFactory.makeBsfCovenantEntity();

          controller.updateCovenant(customer, covenant);

          final state = container.read(insertUpdateStateControllerProvider);
          expect(state.value!.customer!.covenantCode, covenant.code);
          expect(state.value!.customer!.selectedCovenant, covenant);
        },
      );

      test(
        'Should toggle/annul covenant when the same covenant is selected again',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);

          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );

          await container.read(insertUpdateStateControllerProvider.future);

          final covenant = EntityFactory.makeBsfCovenantEntity();
          final customer = EntityFactory.makeBSFCustomerEntity().copyWith(
            covenantCode: covenant.code,
            selectedCovenant: covenant,
          );
          controller.updateCustomer(customer);

          // First call sets the covenant code because updateCustomer annulled it
          controller.updateCovenant(customer, covenant);
          var state = container.read(insertUpdateStateControllerProvider);
          expect(state.value!.customer!.covenantCode, covenant.code);
          expect(state.value!.customer!.selectedCovenant, covenant);

          // Second call toggles/annuls the covenant code
          controller.updateCovenant(customer, covenant);
          state = container.read(insertUpdateStateControllerProvider);
          expect(state.value!.customer!.covenantCode, isNull);
          expect(state.value!.customer!.selectedCovenant, isNull);
        },
      );

      test(
        'Should update customer and then set covenant when customer is different',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);

          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );

          await container.read(insertUpdateStateControllerProvider.future);

          final initialCustomer = EntityFactory.makeBSFCustomerEntity()
              .copyWith(code: 1);
          controller.updateCustomer(initialCustomer);

          final newCustomer = EntityFactory.makeBSFCustomerEntity().copyWith(
            code: 2,
          );
          final covenant = EntityFactory.makeBsfCovenantEntity();

          controller.updateCovenant(newCustomer, covenant);

          final state = container.read(insertUpdateStateControllerProvider);
          expect(state.value!.customer!.code, newCustomer.code);
          expect(state.value!.customer!.covenantCode, covenant.code);
          expect(state.value!.customer!.selectedCovenant, covenant);
        },
      );

      test('Should do nothing if state is not AsyncData', () async {
        final container = makeProviderContainer(saleRequestId: 0);

        final controller = container.read(
          insertUpdateStateControllerProvider.notifier,
        );

        final customer = EntityFactory.makeBSFCustomerEntity();
        final covenant = EntityFactory.makeBsfCovenantEntity();

        controller.updateCovenant(customer, covenant);

        final state = container.read(insertUpdateStateControllerProvider);
        expect(state, isA<AsyncLoading>());
      });
    });
  });
}
