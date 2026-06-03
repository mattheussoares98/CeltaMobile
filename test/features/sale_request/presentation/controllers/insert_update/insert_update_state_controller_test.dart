import 'dart:async';

import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/repository/repository.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/presentation/models/models.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

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

class MockEcSaleRequestsRepository extends Mock
    implements IEcSaleRequestsRepository {}

void main() {
  late FakePaymentFinalizationsController fakePaymentsController;
  late FakeSearchedCustomersStateController fakeSearchedCustomersController;
  late List<BSFPaymentFinalizationEntity> fakePayments;
  late BSFSaleRequestEntity fakeSaleRequest;
  late SaleRequestArgs fakeArgs;
  late MockEcSaleRequestsRepository mockEcSaleRequestsRepository;
  late UserSessionModel fakeSession;

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeBSFSaleRequestEntity());
    registerFallbackValue(EntityFactory.makeEcRequestParams());
  });

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
        ecSaleRequestsRepositoryProvider.overrideWithValue(
          mockEcSaleRequestsRepository,
        ),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(fakeSession),
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() {
    mockEcSaleRequestsRepository = MockEcSaleRequestsRepository();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
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

        final productWithZeroPrice =
            EntityFactory.makeProductEntity(
              plu: faker.guid.guid().toString(),
              enterpriseCode: fakeArgs.enterpriseCode,
              RetailPracticedPrice: 0,
            ).copyWith(
              Value: 0,
              PriceCost: EntityFactory.makePriceCost().copyWith(
                RetailPracticedPrice: 0,
              ),
            );

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

      test('Should not return error when value exceeds available by less than 0.01', () async {
        final container = makeProviderContainer(saleRequestId: 0);

        final controller = container.read(
          insertUpdateStateControllerProvider.notifier,
        );

        await container.read(insertUpdateStateControllerProvider.future);

        // Add a product with price 10.00
        controller.addItem(
          EntityFactory.makeProductEntity(
            enterpriseCode: fakeArgs.enterpriseCode,
          ).copyWith(RetailPracticedPrice: 10.00, Value: 10.00),
        );

        // Add a payment of 9.99
        controller.addPayment(
          payment: fakePayments.first,
          value: 9.99,
        );

        // Remaining balance is exactly 0.01 (but float representation can be e.g. 0.009999999999999787)
        // Trying to pay 0.01 (difference between 0.01 and remaining is less than 0.01, it is 0)
        final (success, error) = controller.addPayment(
          payment: fakePayments.first,
          value: 0.01,
        );

        expect(success, isTrue);
        expect(error, isNull);
      });

      test('Should return error when value exceeds available by exactly 0.01 or more', () async {
        final container = makeProviderContainer(saleRequestId: 0);

        final controller = container.read(
          insertUpdateStateControllerProvider.notifier,
        );

        await container.read(insertUpdateStateControllerProvider.future);

        // Add a product with price 10.00
        controller.addItem(
          EntityFactory.makeProductEntity(
            enterpriseCode: fakeArgs.enterpriseCode,
          ).copyWith(RetailPracticedPrice: 10.00, Value: 10.00),
        );

        // Add a payment of 9.99
        controller.addPayment(
          payment: fakePayments.first,
          value: 9.99,
        );

        // Try to pay 0.02 (exceeding remaining 0.01 by exactly 0.01)
        final (success, error) = controller.addPayment(
          payment: fakePayments.first,
          value: 0.02,
        );

        expect(success, isFalse);
        expect(error, isNotNull);
        expect(error, 'Valor excede o disponível');
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

    group("Update customer or covenant", () {
      group('updateCustomer', () {
        test('Should toggle the selected customer correctly', () async {
          final container = makeProviderContainer(saleRequestId: 0);

          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );

          await container.read(insertUpdateStateControllerProvider.future);

          final customer1 = EntityFactory.makeBSFCustomerEntity().copyWith(
            code: 1,
          );
          controller.updateCustomerOrCovenant(customer1, onlyValidating: false);
          final state = container.read(insertUpdateStateControllerProvider);
          expect(
            state.value!.customer,
            customer1.copyWith(annulSelectedCovenant: true),
          );

          final customer2 = EntityFactory.makeBSFCustomerEntity().copyWith(
            code: 2,
          );
          controller.updateCustomerOrCovenant(customer2, onlyValidating: false);
          final state2 = container.read(insertUpdateStateControllerProvider);
          expect(
            state2.value!.customer,
            customer2.copyWith(annulSelectedCovenant: true),
          );

          final customer3 = EntityFactory.makeBSFCustomerEntity().copyWith(
            code: 2,
          );
          //annul when is the same customer code from the previous
          controller.updateCustomerOrCovenant(customer3, onlyValidating: false);
          final state3 = container.read(insertUpdateStateControllerProvider);
          expect(state3.value!.customer, null);
        });
        test(
          'updateCustomer with onlyValidating: true should return empty actions and not modify state, and subsequent call with onlyValidating: false should modify state',
          () async {
            final container = makeProviderContainer(saleRequestId: 0);

            final controller = container.read(
              insertUpdateStateControllerProvider.notifier,
            );

            await container.read(insertUpdateStateControllerProvider.future);

            final customer = EntityFactory.makeBSFCustomerEntity().copyWith(
              code: 1,
            );

            // First call with onlyValidating: true should NOT update customer
            final actions = controller.updateCustomerOrCovenant(
              customer,
              onlyValidating: true,
            );
            expect(actions, isEmpty);

            var state = container.read(insertUpdateStateControllerProvider);
            expect(state.value!.customer, isNull);

            // Second call with onlyValidating: false should update customer successfully
            final actionsForce = controller.updateCustomerOrCovenant(
              customer,
              onlyValidating: false,
            );
            expect(actionsForce, isEmpty);

            state = container.read(insertUpdateStateControllerProvider);
            expect(state.value!.customer!.code, customer.code);
          },
        );
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
            controller.updateCustomerOrCovenant(
              EntityFactory.makeBSFCustomerEntity(),
              onlyValidating: false,
            );

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

        test(
          'Should clear incompatible payments based on customer restrictions when customer is updated',
          () async {
            final paymentAllowedByCustomer =
                EntityFactory.makeBSFPaymentFinalizationEntity().copyWith(
                  code: 2,
                );
            // Use money action type to avoid flakiness from random faker sequences.
            // If it were covenant type and the new customer has no selectedCovenant, Rule 2
            // would also try to clean it (but Rule 1 would handle it either way).
            final moneyAction = EntityFactory.makeBSFPaymentActionEntity()
                .copyWith(type: PaymentFinalizationActionType.money);
            final paymentInRequest =
                EntityFactory.makeBSFPaymentFinalizationEntity().copyWith(
                  code: 1,
                  action: moneyAction,
                );

            fakeSaleRequest = EntityFactory.makeBSFSaleRequestEntity().copyWith(
              customer: EntityFactory.makeBSFCustomerEntity().copyWith(
                paymentFinalizations: const [],
              ),
              products: const [],
              discounts: const [],
              increment: null,
              deliveryTax: null,
              financials: [
                BSFFinancialEntity(
                  paymentFinalizations: [
                    EntityFactory.makeBSFPaymentFinalizationWrapperEntity()
                        .copyWith(paymentFinalization: paymentInRequest),
                  ],
                  paybackValue: 0,
                ),
              ],
            );

            final container = makeProviderContainer(saleRequestId: 1);
            final controller = container.read(
              insertUpdateStateControllerProvider.notifier,
            );
            await container.read(insertUpdateStateControllerProvider.future);

            // Update customer to one with restrictions (only allows code 2)
            final newCustomer = EntityFactory.makeBSFCustomerEntity().copyWith(
              paymentFinalizations: [paymentAllowedByCustomer],
              saleBlockade: const BsfSaleBlockadeEntity(
                code: 0,
                personalizedCode: null,
                legacyCode: null,
                description: null,
                allowSale: true,
                allowSaleRequest: true,
                allowSaleWithPaymentFinalizationTypeCheckOrPortion: true,
                stringAllowSale: null,
                stringAllowSaleRequest: null,
                stringAllowSaleWithPaymentFinalizationTypeCheckOrPortion: null,
              ),
            );

            controller.updateCustomerOrCovenant(
              newCustomer,
              onlyValidating: false,
            );

            final state = container.read(insertUpdateStateControllerProvider);
            // Payment should be cleared because code 1 is incompatible with new customer's restriction (allows only code 2)
            expect(
              state.value!.financials!.first.paymentFinalizations,
              isEmpty,
            );
          },
        );

        test(
          'Should fail and return action warning when onlyValidating is true and customer has payment restrictions',
          () async {
            final paymentAllowedByCustomer =
                EntityFactory.makeBSFPaymentFinalizationEntity().copyWith(
                  code: 2,
                );
            final paymentInRequest =
                EntityFactory.makeBSFPaymentFinalizationEntity().copyWith(
                  code: 1,
                );

            fakeSaleRequest = EntityFactory.makeBSFSaleRequestEntity().copyWith(
              customer: EntityFactory.makeBSFCustomerEntity().copyWith(
                paymentFinalizations: const [],
              ),
              products: const [],
              discounts: const [],
              increment: null,
              deliveryTax: null,
              financials: [
                BSFFinancialEntity(
                  paymentFinalizations: [
                    EntityFactory.makeBSFPaymentFinalizationWrapperEntity()
                        .copyWith(paymentFinalization: paymentInRequest),
                  ],
                  paybackValue: 0,
                ),
              ],
            );

            final container = makeProviderContainer(saleRequestId: 1);
            final controller = container.read(
              insertUpdateStateControllerProvider.notifier,
            );
            await container.read(insertUpdateStateControllerProvider.future);

            // Update customer to one with restrictions (only allows code 2)
            final newCustomer = EntityFactory.makeBSFCustomerEntity().copyWith(
              paymentFinalizations: [paymentAllowedByCustomer],
            );

            final actions = controller.updateCustomerOrCovenant(
              newCustomer,
              onlyValidating: true,
            );

            expect(actions, isNotEmpty);
            expect(
              actions.first.type,
              BSFSaleRequestSanitizationType.paymentsCleared,
            );

            // State should NOT be updated because onlyValidating is true
            final state = container.read(insertUpdateStateControllerProvider);
            expect(state.value!.customer!.code, isNot(newCustomer.code));
            expect(
              state.value!.financials!.first.paymentFinalizations,
              isNotEmpty,
            );
          },
        );

        test(
          'Should clear covenant payment when customer is updated to one with different covenants and no selected covenant',
          () async {
            final covenant = EntityFactory.makeBsfCovenantEntity().copyWith(
              code: 10,
            );
            final otherCovenant = EntityFactory.makeBsfCovenantEntity()
                .copyWith(code: 20);

            final paymentAction = EntityFactory.makeBSFPaymentActionEntity()
                .copyWith(type: PaymentFinalizationActionType.covenant);
            final paymentFinalization =
                EntityFactory.makeBSFPaymentFinalizationEntity().copyWith(
                  action: paymentAction,
                );

            fakeSaleRequest = EntityFactory.makeBSFSaleRequestEntity().copyWith(
              customer: EntityFactory.makeBSFCustomerEntity().copyWith(
                paymentFinalizations: const [],
                covenants: [covenant],
              ),
              products: const [],
              discounts: const [],
              increment: null,
              deliveryTax: null,
              financials: [
                BSFFinancialEntity(
                  paymentFinalizations: [
                    EntityFactory.makeBSFPaymentFinalizationWrapperEntity()
                        .copyWith(
                          paymentFinalization: paymentFinalization,
                          identificationCode: '10',
                        ),
                  ],
                  paybackValue: 0,
                ),
              ],
            );

            final container = makeProviderContainer(saleRequestId: 1);
            final controller = container.read(
              insertUpdateStateControllerProvider.notifier,
            );
            await container.read(insertUpdateStateControllerProvider.future);

            // Update customer to one that has only otherCovenant (code 20)
            final newCustomer = EntityFactory.makeBSFCustomerEntity().copyWith(
              paymentFinalizations: const [],
              covenants: [otherCovenant],
            );

            controller.updateCustomerOrCovenant(
              newCustomer,
              onlyValidating: false,
            );

            final state = container.read(insertUpdateStateControllerProvider);
            // Covenant payment should be removed because new customer has no selected covenant.
            // When onlyValidating: false and no blockade, the controller applies changes and returns []
            // The verification is in the state, not in the return value.
            expect(
              state.value!.financials!.first.paymentFinalizations,
              isEmpty,
            );
          },
        );

        test(
          'Should preserve covenant payment if the covenant is inside the new customer covenants and selected simultaneously',
          () async {
            // Use a deterministic personalizedCode so the sanitizer produces a predictable identificationCode.
            // The sanitizer uses personalizedCode first, then falls back to code.toString().
            final covenant = EntityFactory.makeBsfCovenantEntity().copyWith(
              code: 10,
              personalizedCode: '10',
            );

            final paymentAction = EntityFactory.makeBSFPaymentActionEntity()
                .copyWith(type: PaymentFinalizationActionType.covenant);
            final paymentFinalization =
                EntityFactory.makeBSFPaymentFinalizationEntity().copyWith(
                  action: paymentAction,
                );

            fakeSaleRequest = EntityFactory.makeBSFSaleRequestEntity().copyWith(
              customer: EntityFactory.makeBSFCustomerEntity().copyWith(
                paymentFinalizations: const [],
                covenants: [covenant],
              ),
              products: const [],
              discounts: const [],
              increment: null,
              deliveryTax: null,
              financials: [
                BSFFinancialEntity(
                  paymentFinalizations: [
                    EntityFactory.makeBSFPaymentFinalizationWrapperEntity()
                        .copyWith(
                          paymentFinalization: paymentFinalization,
                          identificationCode: '10',
                        ),
                  ],
                  paybackValue: 0,
                ),
              ],
            );

            final container = makeProviderContainer(saleRequestId: 1);
            final controller = container.read(
              insertUpdateStateControllerProvider.notifier,
            );
            await container.read(insertUpdateStateControllerProvider.future);

            // Update customer and select covenant at the same time
            final newCustomer = EntityFactory.makeBSFCustomerEntity().copyWith(
              paymentFinalizations: const [],
              covenants: [covenant],
            );

            controller.updateCustomerOrCovenant(
              newCustomer,
              covenant: covenant,
              isChangingCovenant: true,
              onlyValidating: false,
            );

            final state = container.read(insertUpdateStateControllerProvider);
            // Covenant payment should be preserved because covenant 10 was selected simultaneously
            expect(
              state.value!.financials!.first.paymentFinalizations,
              isNotEmpty,
            );
            // The identificationCode is updated using personalizedCode (which we set to '10')
            expect(
              state
                  .value!
                  .financials!
                  .first
                  .paymentFinalizations!
                  .first
                  .identificationCode,
              '10',
            );
          },
        );

        test(
          'Should return customerBlocked action and not change customer when customer is blocked and onlyValidating is true',
          () async {
            fakeSaleRequest = EntityFactory.makeBSFSaleRequestEntity().copyWith(
              products: const [],
              discounts: const [],
              increment: null,
              deliveryTax: null,
              financials: const [],
            );

            final container = makeProviderContainer(saleRequestId: 1);
            final controller = container.read(
              insertUpdateStateControllerProvider.notifier,
            );
            await container.read(insertUpdateStateControllerProvider.future);

            // Create blocked customer
            final blockedCustomer = EntityFactory.makeBSFCustomerEntity()
                .copyWith(
                  paymentFinalizations: const [],
                  saleBlockade: const BsfSaleBlockadeEntity(
                    code: 1,
                    personalizedCode: null,
                    legacyCode: null,
                    description: 'Blocked description',
                    allowSale: false,
                    allowSaleRequest: false,
                    allowSaleWithPaymentFinalizationTypeCheckOrPortion: false,
                    stringAllowSale: null,
                    stringAllowSaleRequest: null,
                    stringAllowSaleWithPaymentFinalizationTypeCheckOrPortion:
                        null,
                  ),
                  saleBlockadeInstruction:
                      const BsfSaleBlockadeInstructionEntity(
                        code: 1,
                        personalizedCode: null,
                        legacyCode: null,
                        description: 'Blocked instruction description',
                      ),
                );

            final actions = controller.updateCustomerOrCovenant(
              blockedCustomer,
              onlyValidating: true,
            );

            expect(actions, isNotEmpty);
            expect(
              actions.first.type,
              BSFSaleRequestSanitizationType.customerBlocked,
            );
            expect(
              actions.first.message,
              contains('Blocked instruction description'),
            );

            // State should NOT be updated because it is a hard block
            final state = container.read(insertUpdateStateControllerProvider);
            expect(state.value!.customer?.code, isNot(blockedCustomer.code));
          },
        );

        test(
          'Should return customerBlocked action and not change customer even when onlyValidating is false',
          () async {
            fakeSaleRequest = EntityFactory.makeBSFSaleRequestEntity().copyWith(
              products: const [],
              discounts: const [],
              increment: null,
              deliveryTax: null,
              financials: const [],
            );

            final container = makeProviderContainer(saleRequestId: 1);
            final controller = container.read(
              insertUpdateStateControllerProvider.notifier,
            );
            await container.read(insertUpdateStateControllerProvider.future);

            // Create blocked customer
            final blockedCustomer = EntityFactory.makeBSFCustomerEntity()
                .copyWith(
                  paymentFinalizations: const [],
                  saleBlockade: const BsfSaleBlockadeEntity(
                    code: 1,
                    personalizedCode: null,
                    legacyCode: null,
                    description: 'Blocked description',
                    allowSale: false,
                    allowSaleRequest: false,
                    allowSaleWithPaymentFinalizationTypeCheckOrPortion: false,
                    stringAllowSale: null,
                    stringAllowSaleRequest: null,
                    stringAllowSaleWithPaymentFinalizationTypeCheckOrPortion:
                        null,
                  ),
                  saleBlockadeInstruction:
                      const BsfSaleBlockadeInstructionEntity(
                        code: 1,
                        personalizedCode: null,
                        legacyCode: null,
                        description: 'Blocked instruction description',
                      ),
                );

            final actions = controller.updateCustomerOrCovenant(
              blockedCustomer,
              onlyValidating: false,
            );

            expect(actions, isNotEmpty);
            expect(
              actions.first.type,
              BSFSaleRequestSanitizationType.customerBlocked,
            );

            // State should NOT be updated because it is a hard block
            final state = container.read(insertUpdateStateControllerProvider);
            expect(state.value!.customer?.code, isNot(blockedCustomer.code));
          },
        );

        test(
          'Should ignore customerBlocked action and update customer successfully when customer allowSaleRequest is false but blockade code is 0 (due to ERP bug)',
          () async {
            fakeSaleRequest = EntityFactory.makeBSFSaleRequestEntity().copyWith(
              products: const [],
              discounts: const [],
              increment: null,
              deliveryTax: null,
              financials: const [],
            );

            final container = makeProviderContainer(saleRequestId: 1);
            final controller = container.read(
              insertUpdateStateControllerProvider.notifier,
            );
            await container.read(insertUpdateStateControllerProvider.future);

            // Create blocked customer but with code 0
            final blockedCustomer = EntityFactory.makeBSFCustomerEntity()
                .copyWith(
                  paymentFinalizations: const [],
                  saleBlockade: const BsfSaleBlockadeEntity(
                    code: 0, // Code 0 implies no blockade due to ERP bug
                    personalizedCode: null,
                    legacyCode: null,
                    description: 'Blocked description',
                    allowSale: false,
                    allowSaleRequest: false,
                    allowSaleWithPaymentFinalizationTypeCheckOrPortion: false,
                    stringAllowSale: null,
                    stringAllowSaleRequest: null,
                    stringAllowSaleWithPaymentFinalizationTypeCheckOrPortion:
                        null,
                  ),
                  saleBlockadeInstruction:
                      const BsfSaleBlockadeInstructionEntity(
                        code: 0,
                        personalizedCode: null,
                        legacyCode: null,
                        description: 'Blocked instruction description',
                      ),
                );

            final actions = controller.updateCustomerOrCovenant(
              blockedCustomer,
              onlyValidating: true,
            );
            expect(actions, isEmpty);

            controller.updateCustomerOrCovenant(
              blockedCustomer,
              onlyValidating: false,
            );

            // State should be updated successfully because the blockade is ignored
            final state = container.read(insertUpdateStateControllerProvider);
            expect(state.value!.customer?.code, blockedCustomer.code);
          },
        );
      });

      group('updateCovenant', () {
        test('Should toggle the selected covenant correctly', () async {
          final container = makeProviderContainer(saleRequestId: 0);

          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );

          await container.read(insertUpdateStateControllerProvider.future);

          final customer = EntityFactory.makeBSFCustomerEntity().copyWith(
            annulSelectedCovenant: true,
          );

          controller.updateCustomerOrCovenant(
            customer,
            covenant: customer.covenants![0],
            isChangingCovenant: true,
            onlyValidating: false,
          );

          final state = container
              .read(insertUpdateStateControllerProvider)
              .value!;
          expect(state.customer!.selectedCovenant, customer.covenants![0]);

          controller.updateCustomerOrCovenant(
            state.customer!,
            covenant: customer.covenants![0],
            isChangingCovenant: true,
            onlyValidating: false,
          );

          final state2 = container
              .read(insertUpdateStateControllerProvider)
              .value!;
          expect(state2.customer?.selectedCovenant, null);
        });

        test(
          'updateCustomerOrCovenant with onlyValidating: true should not modify the state, and subsequent call with onlyValidating: false should modify the state once',
          () async {
            final container = makeProviderContainer(saleRequestId: 0);

            final controller = container.read(
              insertUpdateStateControllerProvider.notifier,
            );

            await container.read(insertUpdateStateControllerProvider.future);

            final customer = EntityFactory.makeBSFCustomerEntity().copyWith(
              annulSelectedCovenant: true,
            );
            controller.updateCustomerOrCovenant(
              customer,
              onlyValidating: false,
            );

            final covenant = EntityFactory.makeBsfCovenantEntity();

            // First call with onlyValidating: true should NOT set the covenant
            final actions = controller.updateCustomerOrCovenant(
              customer,
              covenant: covenant,
              isChangingCovenant: true,
              onlyValidating: true,
            );
            expect(actions, isEmpty);

            var state = container.read(insertUpdateStateControllerProvider);
            expect(state.value!.customer!.selectedCovenant, isNull);

            // Second call with onlyValidating: false should set the covenant successfully
            final actionsForce = controller.updateCustomerOrCovenant(
              customer,
              covenant: covenant,
              isChangingCovenant: true,
              onlyValidating: false,
            );
            expect(actionsForce, isEmpty);

            state = container.read(insertUpdateStateControllerProvider);
            expect(state.value!.customer!.selectedCovenant, covenant);
          },
        );

        test(
          'updateCustomerOrCovenant should not toggle covenant to null on the second call when the first call was onlyValidating: true',
          () async {
            final container = makeProviderContainer(saleRequestId: 0);

            final controller = container.read(
              insertUpdateStateControllerProvider.notifier,
            );

            await container.read(insertUpdateStateControllerProvider.future);

            final customer = EntityFactory.makeBSFCustomerEntity().copyWith(
              annulSelectedCovenant: true,
            );
            controller.updateCustomerOrCovenant(
              customer,
              onlyValidating: false,
            );
            expect(
              container
                  .read(insertUpdateStateControllerProvider)
                  .value
                  ?.customer
                  ?.selectedCovenant,
              isNull,
            );

            final covenant = EntityFactory.makeBsfCovenantEntity();

            // First call with onlyValidating: true
            controller.updateCustomerOrCovenant(
              customer,
              covenant: covenant,
              isChangingCovenant: true,
              onlyValidating: true,
            );

            // Covenant code should still be null in the state
            var state = container.read(insertUpdateStateControllerProvider);
            expect(state.value!.customer!.selectedCovenant, isNull);

            // Second call with onlyValidating: false
            controller.updateCustomerOrCovenant(
              customer,
              covenant: covenant,
              isChangingCovenant: true,
              onlyValidating: false,
            );

            // Covenant code should be set to covenant.code (not null)
            state = container.read(insertUpdateStateControllerProvider);
            expect(state.value!.customer!.selectedCovenant, covenant);
          },
        );

        test(
          'updateCovenant with different customer and onlyValidating: true should return actions and not modify the state',
          () async {
            final incompatiblePayment =
                EntityFactory.makeBSFPaymentFinalizationEntity().copyWith(
                  code: 1,
                );

            // Put incompatible payment in request to trigger paymentsCleared action
            fakeSaleRequest = fakeSaleRequest.copyWith(
              financials: [
                BSFFinancialEntity(
                  paymentFinalizations: [
                    EntityFactory.makeBSFPaymentFinalizationWrapperEntity()
                        .copyWith(paymentFinalization: incompatiblePayment),
                  ],
                  paybackValue: 0,
                ),
              ],
            );

            final container = makeProviderContainer(saleRequestId: 1);

            final controller = container.read(
              insertUpdateStateControllerProvider.notifier,
            );

            await container.read(insertUpdateStateControllerProvider.future);

            final initialCustomer = EntityFactory.makeBSFCustomerEntity()
                .copyWith(
                  code: 1,
                  paymentFinalizations: [incompatiblePayment],
                  saleBlockade: const BsfSaleBlockadeEntity(
                    code: 0,
                    personalizedCode: null,
                    legacyCode: null,
                    description: null,
                    allowSale: true,
                    allowSaleRequest: true,
                    allowSaleWithPaymentFinalizationTypeCheckOrPortion: true,
                    stringAllowSale: null,
                    stringAllowSaleRequest: null,
                    stringAllowSaleWithPaymentFinalizationTypeCheckOrPortion:
                        null,
                  ),
                );
            controller.updateCustomerOrCovenant(
              initialCustomer,
              onlyValidating: false,
            );

            // Create new customer with payment restrictions to trigger actions
            final allowedPayment =
                EntityFactory.makeBSFPaymentFinalizationEntity().copyWith(
                  code: 2,
                );
            final restrictedCustomer = EntityFactory.makeBSFCustomerEntity()
                .copyWith(
                  code: 2,
                  paymentFinalizations: [allowedPayment],
                  saleBlockade: const BsfSaleBlockadeEntity(
                    code: 0,
                    personalizedCode: null,
                    legacyCode: null,
                    description: null,
                    allowSale: true,
                    allowSaleRequest: true,
                    allowSaleWithPaymentFinalizationTypeCheckOrPortion: true,
                    stringAllowSale: null,
                    stringAllowSaleRequest: null,
                    stringAllowSaleWithPaymentFinalizationTypeCheckOrPortion:
                        null,
                  ),
                );

            final covenant = EntityFactory.makeBsfCovenantEntity();

            // First call with onlyValidating: true should return warning actions and not update customer
            final actions = controller.updateCustomerOrCovenant(
              restrictedCustomer,
              covenant: covenant,
              isChangingCovenant: true,
              onlyValidating: true,
            );
            expect(actions, isNotEmpty);
            expect(
              actions.first.type,
              BSFSaleRequestSanitizationType.paymentsCleared,
            );

            final state = container.read(insertUpdateStateControllerProvider);
            expect(state.value!.customer!.code, initialCustomer.code);
          },
        );

        test('Should do nothing if state is not AsyncData', () async {
          final container = makeProviderContainer(saleRequestId: 0);

          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );

          final customer = EntityFactory.makeBSFCustomerEntity();
          final covenant = EntityFactory.makeBsfCovenantEntity();

          controller.updateCustomerOrCovenant(
            customer,
            covenant: covenant,
            isChangingCovenant: true,
            onlyValidating: false,
          );

          final state = container.read(insertUpdateStateControllerProvider);
          expect(state, isA<AsyncLoading>());
        });
      });
    });

    group('changeSeller', () {
      test('Should change the seller when state is AsyncData', () async {
        final container = makeProviderContainer(saleRequestId: 0);

        final controller = container.read(
          insertUpdateStateControllerProvider.notifier,
        );

        await container.read(insertUpdateStateControllerProvider.future);

        // Change to a new seller
        const seller1 = EcSellerEntity(Id: 1, Name: 'Seller 1');
        controller.changeSeller(seller1);
        final state1 = container.read(insertUpdateStateControllerProvider);
        expect(state1.value!.seller?.code, seller1.Id);

        // Change to a different seller
        const seller2 = EcSellerEntity(Id: 2, Name: 'Seller 2');
        controller.changeSeller(seller2);
        final state2 = container.read(insertUpdateStateControllerProvider);
        expect(state2.value!.seller?.code, seller2.Id);

        // Change to the same seller should not annul it anymore
        const seller3 = EcSellerEntity(Id: 2, Name: 'Seller 2');
        controller.changeSeller(seller3);
        final state3 = container.read(insertUpdateStateControllerProvider);
        expect(state3.value!.seller?.code, seller3.Id);
      });

      test('Should do nothing if state is not AsyncData', () async {
        final container = makeProviderContainer(saleRequestId: 0);

        final controller = container.read(
          insertUpdateStateControllerProvider.notifier,
        );

        const seller = EcSellerEntity(Id: 1, Name: 'Seller 1');
        controller.changeSeller(seller);

        final state = container.read(insertUpdateStateControllerProvider);
        expect(state, isA<AsyncLoading>());
      });
    });

    group('removeSeller', () {
      test('Should remove the seller when state is AsyncData', () async {
        final container = makeProviderContainer(saleRequestId: 0);

        final controller = container.read(
          insertUpdateStateControllerProvider.notifier,
        );

        await container.read(insertUpdateStateControllerProvider.future);

        // Set a seller first
        const seller = EcSellerEntity(Id: 1, Name: 'Seller 1');
        controller.changeSeller(seller);
        final stateWithSeller = container.read(
          insertUpdateStateControllerProvider,
        );
        expect(stateWithSeller.value!.seller?.code, seller.Id);

        // Now remove it
        controller.removeSeller();
        final stateWithoutSeller = container.read(
          insertUpdateStateControllerProvider,
        );
        expect(stateWithoutSeller.value!.seller, isNull);
      });

      test('Should do nothing if state is not AsyncData', () async {
        final container = makeProviderContainer(saleRequestId: 0);

        final controller = container.read(
          insertUpdateStateControllerProvider.notifier,
        );

        controller.removeSeller();

        final state = container.read(insertUpdateStateControllerProvider);
        expect(state, isA<AsyncLoading>());
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

          controller.updateCustomerOrCovenant(
            originalCustomer,
            onlyValidating: false,
          );

          final updatedCustomer = EntityFactory.makeBSFCustomerEntity()
              .copyWith(code: 1);

          controller.updateCustomerData(updatedCustomer);

          final state = container.read(insertUpdateStateControllerProvider);
          expect(state.value!.customer!.code, 1);
          expect(
            state.value!.customer,
            updatedCustomer.copyWith(
              code: 1,
              annulCovenantCode: true,
              annulSelectedCovenant: true,
            ),
          );
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
              .copyWith(
                code: 1,
                covenants: [covenant],
                selectedCovenant: covenant,
              );

          controller.updateCustomerOrCovenant(
            originalCustomer,
            covenant: covenant,
            isChangingCovenant: true,
            onlyValidating: false,
          );

          final stateBefore = container.read(
            insertUpdateStateControllerProvider,
          );
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

          controller.updateCustomerOrCovenant(
            originalCustomer,
            onlyValidating: false,
          );

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

    group('ProcessCart & NeedsProcessing', () {
      test(
        'needsProcessing should start as false for existing request, become true on edit, and revert to false when undone',
        () async {
          final container = makeProviderContainer(saleRequestId: 1);
          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );
          await container.read(insertUpdateStateControllerProvider.future);

          // Initially matches the database loaded value, so no processing is needed
          expect(controller.needsProcessing, isFalse);

          // Edit cart
          final product = EntityFactory.makeProductEntity(
            plu: 'plu123',
            enterpriseCode: fakeArgs.enterpriseCode,
          );
          controller.addItem(product);

          // Now it needs processing
          expect(controller.needsProcessing, isTrue);

          // Revert change
          final addedItem = container
              .read(insertUpdateStateControllerProvider)
              .value!
              .products!
              .last;
          controller.removeItem(addedItem);

          // Back to false
          expect(controller.needsProcessing, isFalse);
        },
      );
    });
  });
}
