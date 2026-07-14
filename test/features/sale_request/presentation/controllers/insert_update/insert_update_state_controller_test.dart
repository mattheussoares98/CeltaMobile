import 'dart:async';

import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/request_type/request_type.dart';
import 'package:celta_inventario/core/presentation/controllers/resource/resource.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/exceptions/app_exception.dart';
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

class MockLocalBSFSaleRequestDraftRepository extends Mock
    implements ILocalBSFSaleRequestDraftRepository {}

// Tracks whether the canAccessResourceStateControllerProvider was called with
// the exact (BsRoutine.saleRequest, BsResource.saleRequestChangeTPrice) args.
class FakeCanAccessResourceStateController
    extends CanAccessResourceStateController {
  bool wasCalled = false;

  @override
  Future<bool> build(BsRoutine routine, BsResource resource) async {
    wasCalled = true;
    return true;
  }
}

class FakeRequestTypeStateController extends RequestTypeStateController {
  final FutureOr<List<BSFRequestTypeEntity>?> requestsToReturn;
  FakeRequestTypeStateController(this.requestsToReturn);

  @override
  FutureOr<List<BSFRequestTypeEntity>?> build(
    Modules module,
    int enterpriseCode,
  ) {
    return requestsToReturn;
  }
}

void main() {
  late FakeCanAccessResourceStateController fakeCanAccessResourceController;
  late FakePaymentFinalizationsController fakePaymentsController;
  late FakeSearchedCustomersStateController fakeSearchedCustomersController;
  late FakeRequestTypeStateController fakeRequestTypeStateController;
  late List<BSFPaymentFinalizationEntity> fakePayments;
  late BSFSaleRequestEntity fakeSaleRequest;
  late SaleRequestArgs fakeArgs;
  late MockEcSaleRequestsRepository mockEcSaleRequestsRepository;
  late MockLocalBSFSaleRequestDraftRepository mockLocalBSFSaleRequestDraftRepository;
  late UserSessionModel fakeSession;

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeBSFSaleRequestEntity());
    registerFallbackValue(EntityFactory.makeEcRequestParams());
  });

  ProviderContainer makeProviderContainer({required int saleRequestId}) {
    final args = fakeArgs.copyWith(
      saleRequestId: saleRequestId,
      requestTypeCode: fakeSaleRequest.requestType?.code,
    );
    final container = ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        saleRequestArgsProvider.overrideWithValue(args),
        filteredPaymentFinalizationsStateControllerProvider.overrideWith(
          () => fakePaymentsController,
        ),
        requestTypeStateControllerProvider(
          Modules.saleRequest,
          args.enterpriseCode,
        ).overrideWith(() => fakeRequestTypeStateController),
        saleRequestDetailsStateControllerProvider(
          args,
        ).overrideWith(() => FakeSaleRequestDetailsController(fakeSaleRequest)),
        canAccessResourceStateControllerProvider(
          BsRoutine.saleRequest,
          BsResource.saleRequestChangeTPrice,
        ).overrideWith(() => fakeCanAccessResourceController),
        searchedCustomersStateControllerProvider.overrideWith(
          () => fakeSearchedCustomersController,
        ),
        ecSaleRequestsRepositoryProvider.overrideWithValue(
          mockEcSaleRequestsRepository,
        ),
        localBsfSaleRequestDraftRepositoryProvider.overrideWithValue(
          mockLocalBSFSaleRequestDraftRepository,
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
    fakeCanAccessResourceController = FakeCanAccessResourceStateController();
    mockEcSaleRequestsRepository = MockEcSaleRequestsRepository();
    mockLocalBSFSaleRequestDraftRepository = MockLocalBSFSaleRequestDraftRepository();

    when(() => mockLocalBSFSaleRequestDraftRepository.load(
          enterpriseCode: any(named: 'enterpriseCode'),
          requestTypeCode: any(named: 'requestTypeCode'),
        )).thenAnswer((_) async => null);
    when(() => mockLocalBSFSaleRequestDraftRepository.save(
          any(),
          enterpriseCode: any(named: 'enterpriseCode'),
          requestTypeCode: any(named: 'requestTypeCode'),
        )).thenAnswer((_) async {});
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakeSaleRequest = EntityFactory.makeBSFSaleRequestEntity();
    fakeRequestTypeStateController = FakeRequestTypeStateController([
      ?fakeSaleRequest.requestType,
    ]);
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
        'should return empty with requestType from args entity when saleRequestId is 0 and load payment options',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);

          final result = await container.read(
            insertUpdateStateControllerProvider.future,
          );

          expect(
            result,
            BSFSaleRequestEntity.empty().copyWith(
              requestType: fakeSaleRequest.requestType,
            ),
          );
          expect(fakePaymentsController.wasCalled, isFalse);
        },
      );
      test(
        'should throw when is inserting and didn\'t find the request type',
        () async {
          fakeSaleRequest = fakeSaleRequest.copyWith(
            requestType: fakeSaleRequest.requestType?.copyWith(code: 999),
          );
          final container = makeProviderContainer(saleRequestId: 0);

          expect(
            container.read(insertUpdateStateControllerProvider.future),
            throwsA(
              isA<AppException>().having(
                (e) => e.message,
                'message',
                'Modelo de pedido não encontrado',
              ),
            ),
          );
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

      test(
        'should call canAccessResourceStateControllerProvider with BsRoutine.saleRequest and BsResource.saleRequestChangeTPrice',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);

          await container.read(insertUpdateStateControllerProvider.future);

          expect(fakeCanAccessResourceController.wasCalled, isTrue);
        },
      );

      test(
        'should return the saved local draft when saleRequestId is 0 and draft exists',
        () async {
          final draftEntity = EntityFactory.makeBSFSaleRequestEntity().copyWith(
            code: 0,
            requestType: fakeSaleRequest.requestType,
          );

          when(() => mockLocalBSFSaleRequestDraftRepository.load(
                enterpriseCode: fakeArgs.enterpriseCode,
                requestTypeCode: fakeSaleRequest.requestType?.code ?? 0,
              )).thenAnswer((_) async => draftEntity);

          final container = makeProviderContainer(saleRequestId: 0);

          final result = await container.read(
            insertUpdateStateControllerProvider.future,
          );

          expect(result, draftEntity);
          verify(() => mockLocalBSFSaleRequestDraftRepository.load(
                enterpriseCode: fakeArgs.enterpriseCode,
                requestTypeCode: fakeSaleRequest.requestType?.code ?? 0,
              )).called(1);
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

        final result1 = controller.increaseOrDecreaseUnit(
          state.value!.products!.first,
          true,
        );
        expect(result1.$1, isNull);
        expect(result1.$2, isEmpty);
        final state2 = getCurrentState(container);
        expect(state2.value!.products!.length, 1);
        expect(state2.value!.products!.first.quantity, 2);

        final result2 = controller.increaseOrDecreaseUnit(
          state2.value!.products!.first,
          false,
        );
        expect(result2.$1, isNull);
        expect(result2.$2, isEmpty);
        final state3 = getCurrentState(container);
        expect(state3.value!.products!.length, 1);
        expect(state3.value!.products!.first.quantity, 1);

        final result3 = controller.increaseOrDecreaseUnit(
          state3.value!.products!.first,
          false,
        );
        expect(result3.$1, isNull);
        expect(result3.$2, isEmpty);
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

          final result = controller.increaseOrDecreaseUnit(item, true);
          expect(result.$1, isNull);
          expect(result.$2, isEmpty);
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

          final result = controller.increaseOrDecreaseUnit(item, true);
          expect(result.$1, isNull);
          expect(result.$2, isEmpty);
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

          final result = controller.increaseOrDecreaseUnit(item, true);
          expect(result.$1, isNull);
          expect(result.$2, isEmpty);
          final state2 = getCurrentState(container);
          expect(state2.value!.products!.first.quantity, 2);
          expect(state2.value!.products!.first.value, retailPrice);
        },
      );

      test(
        'increaseOrDecreaseUnit should prioritize wholeSalePricePractice over salePracticedInWholeSale',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);

          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );

          await container.read(insertUpdateStateControllerProvider.future);

          final retailPrice = faker.randomGenerator.decimal();
          final wholePricePractice = faker.randomGenerator.decimal();
          final salePracticedInWholeSale = wholePricePractice + 1.0;

          final product =
              EntityFactory.makeProductEntity(
                plu: faker.guid.guid().toString(),
                enterpriseCode: fakeArgs.enterpriseCode,
              ).copyWith(
                RetailPracticedPrice: retailPrice,
                WholePracticedPrice: wholePricePractice,
                MinimumWholeQuantity: 2,
                Value: 0,
                PriceCost: EntityFactory.makePriceCost().copyWith(
                  RetailPracticedPrice: retailPrice,
                  WholePracticedPrice: wholePricePractice,
                  MinimumWholeQuantity: 2,
                ),
              );

          controller.addItem(product);

          final currentState = container
              .read(insertUpdateStateControllerProvider)
              .value!;
          final addedItem = currentState.products!.first;
          final itemWithDifferentWholePrices = addedItem.copyWith(
            priceCost: addedItem.priceCost?.copyWith(
              salePracticedInWholeSale: salePracticedInWholeSale,
            ),
          );

          controller.updateProcessedCart(
            currentState.copyWith(products: [itemWithDifferentWholePrices]),
          );

          final state = getCurrentState(container);
          expect(state.value!.products!.first.quantity, 1);
          expect(state.value!.products!.first.value, retailPrice);

          final result = controller.increaseOrDecreaseUnit(
            itemWithDifferentWholePrices,
            true,
          );
          expect(result.$1, isNull);
          expect(result.$2, isEmpty);
          final state2 = getCurrentState(container);
          expect(state2.value!.products!.first.quantity, 2);
          expect(state2.value!.products!.first.value, wholePricePractice);
        },
      );

      test(
        'increaseOrDecreaseUnit should prioritize saleRetailPricePractice over salePracticedInSaleRetail',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);

          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );

          await container.read(insertUpdateStateControllerProvider.future);

          final retailPricePractice = faker.randomGenerator.decimal();
          final salePracticedInSaleRetail = retailPricePractice + 1.0;

          final product =
              EntityFactory.makeProductEntity(
                plu: faker.guid.guid().toString(),
                enterpriseCode: fakeArgs.enterpriseCode,
              ).copyWith(
                RetailPracticedPrice: retailPricePractice,
                Value: 0,
                MinimumWholeQuantity: 0,
                PriceCost: EntityFactory.makePriceCost().copyWith(
                  RetailPracticedPrice: retailPricePractice,
                  MinimumWholeQuantity: 0,
                  WholePracticedPrice: 0,
                  WholeSalePrice: 0,
                ),
              );

          controller.addItem(product);

          final currentState = container
              .read(insertUpdateStateControllerProvider)
              .value!;
          final addedItem = currentState.products!.first;
          final itemWithDifferentRetailPrices = addedItem.copyWith(
            priceCost: addedItem.priceCost?.copyWith(
              salePracticedInSaleRetail: salePracticedInSaleRetail,
            ),
          );

          controller.updateProcessedCart(
            currentState.copyWith(products: [itemWithDifferentRetailPrices]),
          );

          final state = getCurrentState(container);
          expect(state.value!.products!.first.quantity, 1);
          expect(state.value!.products!.first.value, retailPricePractice);

          final result = controller.increaseOrDecreaseUnit(
            itemWithDifferentRetailPrices,
            true,
          );
          expect(result.$1, isNull);
          expect(result.$2, isEmpty);
          final state2 = getCurrentState(container);
          expect(state2.value!.products!.first.quantity, 2);
          expect(state2.value!.products!.first.value, retailPricePractice);
        },
      );

      test(
        'Should return error message when item value and retail price are null',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);

          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );

          await container.read(insertUpdateStateControllerProvider.future);

          final item = EntityFactory.makeBSFProductItemEntity().copyWith(
            annulValue: true,
            priceCost: EntityFactory.makeBSFPriceCostEntity().copyWith(
              anullSaleRetailPricePractice: true,
              anullSalePracticedInSaleRetail: true,
            ),
          );

          final currentState = container
              .read(insertUpdateStateControllerProvider)
              .value!;
          controller.updateProcessedCart(
            currentState.copyWith(products: [item]),
          );

          final result = controller.increaseOrDecreaseUnit(item, true);

          expect(result.$1, isA<String>());
          expect(result.$1, isNotNull);
        },
      );
      test(
        'Should remove all discounts if there is any automatic discount',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);
          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );
          await container.read(insertUpdateStateControllerProvider.future);

          final manualDiscount = EntityFactory.makeBSFDiscountEntity().copyWith(
            discountOrigin: DiscountOrigin.manual,
          );

          final automaticDiscount = EntityFactory.makeBSFDiscountEntity()
              .copyWith(discountOrigin: DiscountOrigin.saleOffer);

          final item = EntityFactory.makeBSFProductItemEntity().copyWith(
            quantity: 1,
            value: 100,
            discounts: [manualDiscount, automaticDiscount],
          );

          final currentState = container
              .read(insertUpdateStateControllerProvider)
              .value!;
          controller.updateProcessedCart(
            currentState.copyWith(products: [item]),
          );

          final result = controller.increaseOrDecreaseUnit(item, true);

          expect(result.$1, isNull);
          expect(result.$2, [
            BSFSaleRequestSanitizationAction.productAutomaticDiscountsRemoved,
          ]);

          final stateAfter = getCurrentState(container);
          final updatedItem = stateAfter.value!.products!.first;

          expect(updatedItem.quantity, 2);
          expect(updatedItem.discounts, isEmpty);
        },
      );

      test(
        'Should calculate warnings but NOT modify state when onlyValidating is true',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);
          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );
          await container.read(insertUpdateStateControllerProvider.future);

          final manualDiscount = EntityFactory.makeBSFDiscountEntity().copyWith(
            discountOrigin: DiscountOrigin.manual,
          );

          final automaticDiscount = EntityFactory.makeBSFDiscountEntity()
              .copyWith(discountOrigin: DiscountOrigin.saleOffer);

          final item = EntityFactory.makeBSFProductItemEntity().copyWith(
            quantity: 1,
            value: 100,
            discounts: [manualDiscount, automaticDiscount],
          );

          final currentState = container
              .read(insertUpdateStateControllerProvider)
              .value!;
          controller.updateProcessedCart(
            currentState.copyWith(products: [item]),
          );

          final result = controller.increaseOrDecreaseUnit(
            item,
            true,
            onlyValidating: true,
          );

          expect(result.$1, isNull);
          expect(result.$2.length, 1);
          expect(
            result.$2.first.type,
            BSFSaleRequestSanitizationType.productAutomaticDiscountsRemoved,
          );

          // Verify state did NOT change
          final stateAfter = getCurrentState(container);
          final unchangedItem = stateAfter.value!.products!.first;

          expect(unchangedItem.quantity, 1);
          expect(unchangedItem.discounts, [manualDiscount, automaticDiscount]);
        },
      );
      test('Should modify state when onlyValidating is false', () async {
        final container = makeProviderContainer(saleRequestId: 0);
        final controller = container.read(
          insertUpdateStateControllerProvider.notifier,
        );
        await container.read(insertUpdateStateControllerProvider.future);

        final discounts = [
          EntityFactory.makeBSFDiscountEntity().copyWith(
            discountOrigin: DiscountOrigin.manual,
          ),
          EntityFactory.makeBSFDiscountEntity().copyWith(
            discountOrigin: DiscountOrigin.saleOffer,
          ),
        ];

        final item = EntityFactory.makeBSFProductItemEntity().copyWith(
          quantity: 1,
          value: 100,
          discounts: discounts,
        );

        final currentState = container
            .read(insertUpdateStateControllerProvider)
            .value!;
        controller.updateProcessedCart(currentState.copyWith(products: [item]));

        final result = controller.increaseOrDecreaseUnit(
          item,
          true,
        );

        expect(result.$1, isNull);
        expect(result.$2.length, 1);
        expect(
          result.$2.first.type,
          BSFSaleRequestSanitizationType.productAutomaticDiscountsRemoved,
        );

        final stateAfter = getCurrentState(container);
        final updatedItem = stateAfter.value!.products!.first;

        expect(updatedItem.quantity, 2);
        expect(updatedItem.discounts, isEmpty);
      });

      test(
        'Should NOT remove item when quantity drops to 0 and onlyValidating is true',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);
          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );
          await container.read(insertUpdateStateControllerProvider.future);

          final item = EntityFactory.makeBSFProductItemEntity().copyWith(
            quantity: 1,
            value: 100,
          );

          final currentState = container
              .read(insertUpdateStateControllerProvider)
              .value!;
          controller.updateProcessedCart(
            currentState.copyWith(products: [item]),
          );

          final result = controller.increaseOrDecreaseUnit(
            item,
            false,
            onlyValidating: true,
          );

          expect(result.$1, isNull);
          expect(result.$2, isEmpty);

          // Verify state did NOT change
          final stateAfter = getCurrentState(container);
          expect(stateAfter.value!.products!.length, 1);
        },
      );

      test(
        'Should NOT add item when not in cart and onlyValidating is true',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);
          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );
          await container.read(insertUpdateStateControllerProvider.future);

          final item = EntityFactory.makeBSFProductItemEntity().copyWith(
            quantity: 1,
            value: 100,
          );

          final result = controller.increaseOrDecreaseUnit(
            item,
            true,
            onlyValidating: true,
          );

          expect(result.$1, isNull);
          expect(result.$2, isEmpty);

          // Verify state did NOT change
          final stateAfter = getCurrentState(container);
          expect(stateAfter.value!.products, isNull);
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

        final (errorMessage, actions) = controller.updateItem(
          addedItem,
          updatedItem,
        );
        expect(errorMessage, isNull);

        final state = container.read(insertUpdateStateControllerProvider);
        expect(state.value!.products!.first.quantity, newQuantity);
      });

      test(
        'should not remove manual discounts when there is no automatic discount',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);
          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );
          await container.read(insertUpdateStateControllerProvider.future);

          final manualDiscount = EntityFactory.makeBSFDiscountEntity().copyWith(
            discountOrigin: DiscountOrigin.manual,
          );

          final item = EntityFactory.makeBSFProductItemEntity().copyWith(
            quantity: 1,
            value: 100,
            discounts: [manualDiscount],
          );

          controller.updateProcessedCart(
            container
                .read(insertUpdateStateControllerProvider)
                .value!
                .copyWith(products: [item]),
          );

          final updatedItem = item.copyWith(quantity: 2);
          final (errorMessage, actions) = controller.updateItem(
            item,
            updatedItem,
          );

          expect(errorMessage, isNull);
          expect(actions, isEmpty);

          final state = container.read(insertUpdateStateControllerProvider);
          expect(state.value!.products!.first.discounts, [manualDiscount]);
          expect(state.value!.products!.first.quantity, 2);
        },
      );

      test(
        'should NOT remove automatic discounts and return empty actions when quantity and value are unchanged',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);
          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );
          await container.read(insertUpdateStateControllerProvider.future);

          final automaticDiscount = EntityFactory.makeBSFDiscountEntity()
              .copyWith(discountOrigin: DiscountOrigin.saleOffer);

          final item = EntityFactory.makeBSFProductItemEntity().copyWith(
            quantity: 1,
            value: 100,
            discounts: [automaticDiscount],
          );

          controller.updateProcessedCart(
            container
                .read(insertUpdateStateControllerProvider)
                .value!
                .copyWith(products: [item]),
          );

          final updatedItem = item.copyWith(
            increment: EntityFactory.makeBSFValueTypeEntity(),
            deliveryTax: EntityFactory.makeBSFValueTypeEntity(),
          );
          final (errorMessage, actions) = controller.updateItem(
            item,
            updatedItem,
          );

          expect(errorMessage, isNull);
          expect(actions, isEmpty);

          final state = container.read(insertUpdateStateControllerProvider);
          expect(state.value!.products!.first.discounts, [automaticDiscount]);
          expect(state.value!.products!.first.value, 100);
          expect(state.value!.products!.first.quantity, 1);
        },
      );

      test(
        'should remove automatic discounts and return discountsReset action when quantity or value changed',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);
          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );
          await container.read(insertUpdateStateControllerProvider.future);

          final automaticDiscount = EntityFactory.makeBSFDiscountEntity()
              .copyWith(discountOrigin: DiscountOrigin.saleOffer);
          final manualDiscount = EntityFactory.makeBSFDiscountEntity().copyWith(
            discountOrigin: DiscountOrigin.manual,
          );

          final item = EntityFactory.makeBSFProductItemEntity().copyWith(
            quantity: 1,
            value: 100,
            discounts: [automaticDiscount, manualDiscount],
          );

          controller.updateProcessedCart(
            container
                .read(insertUpdateStateControllerProvider)
                .value!
                .copyWith(products: [item]),
          );

          final changeQuantity = faker.randomGenerator.boolean();
          final newQuantity = changeQuantity ? 2.0 : item.quantity;
          final newValue = changeQuantity
              ? item.value
              : faker.randomGenerator.decimal();

          final updatedItem = item.copyWith(
            quantity: newQuantity,
            value: newValue,
          );
          final (errorMessage, actions) = controller.updateItem(
            item,
            updatedItem,
          );

          expect(errorMessage, isNull);
          expect(actions, [
            BSFSaleRequestSanitizationAction.productAutomaticDiscountsRemoved,
          ]);

          final state = container.read(insertUpdateStateControllerProvider);
          expect(state.value!.products!.first.discounts, [manualDiscount]);
          expect(state.value!.products!.first.quantity, newQuantity);
          expect(state.value!.products!.first.value, newValue);
        },
      );
      test(
        'should remove automatic discounts and return discountsReset action when value is changed',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);
          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );
          await container.read(insertUpdateStateControllerProvider.future);

          final automaticDiscount = EntityFactory.makeBSFDiscountEntity()
              .copyWith(discountOrigin: DiscountOrigin.saleOffer);

          final item = EntityFactory.makeBSFProductItemEntity().copyWith(
            quantity: 1,
            value: 100,
            discounts: [automaticDiscount],
          );

          controller.updateProcessedCart(
            container
                .read(insertUpdateStateControllerProvider)
                .value!
                .copyWith(products: [item]),
          );

          final updatedItem = item.copyWith(value: 110);
          final (errorMessage, actions) = controller.updateItem(
            item,
            updatedItem,
          );

          expect(errorMessage, isNull);
          expect(actions, [
            BSFSaleRequestSanitizationAction.productAutomaticDiscountsRemoved,
          ]);

          final state = container.read(insertUpdateStateControllerProvider);
          expect(state.value!.products!.first.discounts, isEmpty);
          expect(state.value!.products!.first.value, 110);
        },
      );

      test(
        'should calculate actions but not modify state when onlyValidating is true',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);
          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );
          await container.read(insertUpdateStateControllerProvider.future);

          final automaticDiscount = EntityFactory.makeBSFDiscountEntity()
              .copyWith(discountOrigin: DiscountOrigin.saleOffer);

          final item = EntityFactory.makeBSFProductItemEntity().copyWith(
            quantity: 1,
            value: 100,
            discounts: [automaticDiscount],
          );

          controller.updateProcessedCart(
            container
                .read(insertUpdateStateControllerProvider)
                .value!
                .copyWith(products: [item]),
          );

          final updatedItem = item.copyWith(quantity: 2);
          final (errorMessage, actions) = controller.updateItem(
            item,
            updatedItem,
            onlyValidating: true,
          );

          expect(errorMessage, isNull);
          expect(actions, [
            BSFSaleRequestSanitizationAction.productAutomaticDiscountsRemoved,
          ]);

          final state = container.read(insertUpdateStateControllerProvider);
          expect(state.value!.products!.first.quantity, 1);
          expect(state.value!.products!.first.discounts, [automaticDiscount]);
        },
      );
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

      test(
        'Should not return error when value exceeds available by less than 0.01',
        () async {
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
          controller.addPayment(payment: fakePayments.first, value: 9.99);

          // Remaining balance is exactly 0.01 (but float representation can be e.g. 0.009999999999999787)
          // Trying to pay 0.01 (difference between 0.01 and remaining is less than 0.01, it is 0)
          final (success, error) = controller.addPayment(
            payment: fakePayments.first,
            value: 0.01,
          );

          expect(success, isTrue);
          expect(error, isNull);
        },
      );

      test(
        'Should return error when value exceeds available by exactly 0.01 or more',
        () async {
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
          controller.addPayment(payment: fakePayments.first, value: 9.99);

          // Try to pay 0.02 (exceeding remaining 0.01 by exactly 0.01)
          final (success, error) = controller.addPayment(
            payment: fakePayments.first,
            value: 0.02,
          );

          expect(success, isFalse);
          expect(error, isNotNull);
          expect(error, 'Valor excede o disponível');
        },
      );

      test(
        'Should return error when payment is covenant and selectedCovenant is null',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);

          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );

          await container.read(insertUpdateStateControllerProvider.future);

          // Add a product first so there is available balance
          controller.addItem(
            EntityFactory.makeProductEntity(
              enterpriseCode: fakeArgs.enterpriseCode,
            ).copyWith(RetailPracticedPrice: 200, Value: 200),
          );

          // Create a payment finalization of type covenant
          final covenantAction = EntityFactory.makeBSFPaymentActionEntity()
              .copyWith(type: PaymentFinalizationActionType.covenant);
          final covenantPayment =
              EntityFactory.makeBSFPaymentFinalizationEntity().copyWith(
                action: covenantAction,
              );

          // Ensure the customer is null or has no selectedCovenant (so selectedCovenant is null)
          final state = container
              .read(insertUpdateStateControllerProvider)
              .value!;
          expect(state.customer?.selectedCovenant, isNull);

          final (success, error) = controller.addPayment(
            payment: covenantPayment,
            value: 100.0,
          );

          expect(success, isFalse);
          expect(error, 'Selecione um convênio');
        },
      );

      test(
        'Should add payment successfully when payment is covenant and selectedCovenant is not null',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);

          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );

          await container.read(insertUpdateStateControllerProvider.future);

          // Add a product first so there is available balance
          controller.addItem(
            EntityFactory.makeProductEntity(
              enterpriseCode: fakeArgs.enterpriseCode,
            ).copyWith(RetailPracticedPrice: 200, Value: 200),
          );

          // Create a covenant info and select it on the customer
          final covenant = EntityFactory.makeBsfCovenantEntity();
          final customer = EntityFactory.makeBSFCustomerEntity().copyWith(
            covenants: [covenant],
            selectedCovenant: covenant,
          );

          // Update the controller state to have this customer with covenant selected
          controller.updateCustomerOrCovenant(
            customer,
            covenant: covenant,
            isChangingCovenant: true,
          );

          // Create a payment finalization of type covenant
          final covenantAction = EntityFactory.makeBSFPaymentActionEntity()
              .copyWith(type: PaymentFinalizationActionType.covenant);
          final covenantPayment =
              EntityFactory.makeBSFPaymentFinalizationEntity().copyWith(
                action: covenantAction,
              );

          final (success, error) = controller.addPayment(
            payment: covenantPayment,
            value: 100.0,
          );

          expect(success, isTrue);
          expect(error, isNull);
        },
      );
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

        controller.removePayment(0, 1);

        final state2 = container.read(insertUpdateStateControllerProvider);

        expect(state2.value!.financials!.first.paymentFinalizations!.length, 1);

        controller.removePayment(0, 0);

        final state3 = container.read(insertUpdateStateControllerProvider);

        expect(state3.value!.financials, isEmpty);
      });

      test(
        'removePayment with non-existent indexes should not modify state',
        () async {
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

          final stateBefore = container.read(
            insertUpdateStateControllerProvider,
          );
          expect(stateBefore.value!.financials!.length, 1);
          expect(
            stateBefore.value!.financials!.first.paymentFinalizations!.length,
            2,
          );

          // Try removing with non-existent financial index
          controller.removePayment(99, 0);
          var state = container.read(insertUpdateStateControllerProvider);
          expect(state.value!.financials!.length, 1);

          // Try removing with negative financial index
          controller.removePayment(-1, 0);
          state = container.read(insertUpdateStateControllerProvider);
          expect(state.value!.financials!.length, 1);

          // Try removing with non-existent payment index
          controller.removePayment(0, 99);
          state = container.read(insertUpdateStateControllerProvider);
          expect(
            state.value!.financials!.first.paymentFinalizations!.length,
            2,
          );

          // Try removing with negative payment index
          controller.removePayment(0, -1);
          state = container.read(insertUpdateStateControllerProvider);
          expect(
            state.value!.financials!.first.paymentFinalizations!.length,
            2,
          );
        },
      );
    });

    group('Financial Increment', () {
      test(
        'updateFinancialIncrement should update financial increment if allowed, value > 0, and type is selected',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);
          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );
          await container.read(insertUpdateStateControllerProvider.future);

          final stateBefore = container
              .read(insertUpdateStateControllerProvider)
              .value!;
          final updatedRequestType = stateBefore.requestType?.copyWith(
            allowFinancialIncrement: true,
          );
          controller.updateProcessedCart(
            stateBefore.copyWith(requestType: updatedRequestType),
          );

          final incrementValue = EntityFactory.makeBSFValueTypeEntity()
              .copyWith(type: PercentageOrValue.reais, value: 10.0);

          final error = controller.updateFinancialIncrement(incrementValue);
          expect(error, isNull);

          final stateAfter = container
              .read(insertUpdateStateControllerProvider)
              .value!;
          expect(stateAfter.financialIncrement, incrementValue);
        },
      );

      test(
        'updateFinancialIncrement should return error if requestType does not allow financial increment',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);
          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );
          await container.read(insertUpdateStateControllerProvider.future);

          final stateBefore = container
              .read(insertUpdateStateControllerProvider)
              .value!;
          final updatedRequestType = stateBefore.requestType?.copyWith(
            allowFinancialIncrement: false,
          );
          controller.updateProcessedCart(
            stateBefore.copyWith(requestType: updatedRequestType),
          );

          final incrementValue = EntityFactory.makeBSFValueTypeEntity()
              .copyWith(type: PercentageOrValue.reais, value: 10.0);

          final error = controller.updateFinancialIncrement(incrementValue);
          expect(error, isNotEmpty);

          final stateAfter = container
              .read(insertUpdateStateControllerProvider)
              .value!;
          expect(stateAfter.financialIncrement, isNot(incrementValue));
        },
      );

      test(
        'updateFinancialIncrement should return error if value is 0 or less',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);
          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );
          await container.read(insertUpdateStateControllerProvider.future);

          final stateBefore = container
              .read(insertUpdateStateControllerProvider)
              .value!;
          final updatedRequestType = stateBefore.requestType?.copyWith(
            allowFinancialIncrement: true,
          );
          controller.updateProcessedCart(
            stateBefore.copyWith(requestType: updatedRequestType),
          );

          final incrementValue = EntityFactory.makeBSFValueTypeEntity()
              .copyWith(type: PercentageOrValue.reais, value: 0.0);

          final error = controller.updateFinancialIncrement(incrementValue);
          expect(error, isNotEmpty);
        },
      );

      test(
        'updateFinancialIncrement should return error if type is null',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);
          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );
          await container.read(insertUpdateStateControllerProvider.future);

          final stateBefore = container
              .read(insertUpdateStateControllerProvider)
              .value!;
          final updatedRequestType = stateBefore.requestType?.copyWith(
            allowFinancialIncrement: true,
          );
          controller.updateProcessedCart(
            stateBefore.copyWith(requestType: updatedRequestType),
          );

          final incrementValue = EntityFactory.makeBSFValueTypeEntity()
              .copyWith(value: 10.0, annulType: true);

          final error = controller.updateFinancialIncrement(incrementValue);
          expect(error, 'Selecione o tipo de acréscimo');
        },
      );

      test(
        'removeFinancialIncrement should set financial increment to null',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);
          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );
          await container.read(insertUpdateStateControllerProvider.future);

          final stateBefore = container
              .read(insertUpdateStateControllerProvider)
              .value!;
          final updatedRequestType = stateBefore.requestType?.copyWith(
            allowFinancialIncrement: true,
          );
          controller.updateProcessedCart(
            stateBefore.copyWith(
              requestType: updatedRequestType,
              financialIncrement: EntityFactory.makeBSFValueTypeEntity()
                  .copyWith(type: PercentageOrValue.reais, value: 10.0),
            ),
          );

          expect(
            container
                .read(insertUpdateStateControllerProvider)
                .value!
                .financialIncrement,
            isNotNull,
          );

          controller.removeFinancialIncrement();

          expect(
            container
                .read(insertUpdateStateControllerProvider)
                .value!
                .financialIncrement,
            isNull,
          );
        },
      );
    });

    group('Financial discount', () {
      test(
        'updateFinancialDiscount should update financial discount if allowed, value > 0, and type is selected',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);
          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );
          await container.read(insertUpdateStateControllerProvider.future);

          final stateBefore = container
              .read(insertUpdateStateControllerProvider)
              .value!;
          final updatedRequestType = stateBefore.requestType?.copyWith(
            allowFinancialDiscount: true,
          );
          controller.updateProcessedCart(
            stateBefore.copyWith(requestType: updatedRequestType),
          );

          final discountValue = EntityFactory.makeBSFValueTypeEntity().copyWith(
            type: PercentageOrValue.reais,
            value: 5.0,
          );

          final error = controller.updateFinancialDiscount(discountValue);
          expect(error, isNull);

          final stateAfter = container
              .read(insertUpdateStateControllerProvider)
              .value!;
          expect(stateAfter.financialDiscount, discountValue);
        },
      );

      test(
        'updateFinancialDiscount should return error if requestType does not allow financial discount',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);
          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );
          await container.read(insertUpdateStateControllerProvider.future);

          final stateBefore = container
              .read(insertUpdateStateControllerProvider)
              .value!;
          final updatedRequestType = stateBefore.requestType?.copyWith(
            allowFinancialDiscount: false,
          );
          controller.updateProcessedCart(
            stateBefore.copyWith(requestType: updatedRequestType),
          );

          final discountValue = EntityFactory.makeBSFValueTypeEntity().copyWith(
            type: PercentageOrValue.reais,
            value: 5.0,
          );

          final error = controller.updateFinancialDiscount(discountValue);
          expect(error, isNotEmpty);
        },
      );

      test(
        'updateFinancialDiscount should return error if value is 0 or less',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);
          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );
          await container.read(insertUpdateStateControllerProvider.future);

          final stateBefore = container
              .read(insertUpdateStateControllerProvider)
              .value!;
          final updatedRequestType = stateBefore.requestType?.copyWith(
            allowFinancialDiscount: true,
          );
          controller.updateProcessedCart(
            stateBefore.copyWith(requestType: updatedRequestType),
          );

          final discountValue = EntityFactory.makeBSFValueTypeEntity().copyWith(
            type: PercentageOrValue.reais,
            value: -1.0,
          );

          final error = controller.updateFinancialDiscount(discountValue);
          expect(error, isNotEmpty);
        },
      );

      test(
        'updateFinancialDiscount should return error if type is null',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);
          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );
          await container.read(insertUpdateStateControllerProvider.future);

          final stateBefore = container
              .read(insertUpdateStateControllerProvider)
              .value!;
          final updatedRequestType = stateBefore.requestType?.copyWith(
            allowFinancialDiscount: true,
          );
          controller.updateProcessedCart(
            stateBefore.copyWith(requestType: updatedRequestType),
          );

          final discountValue = EntityFactory.makeBSFValueTypeEntity().copyWith(
            value: 5.0,
            annulType: true,
          );

          final error = controller.updateFinancialDiscount(discountValue);
          expect(error, isNotEmpty);
        },
      );

      test(
        'removeFinancialDiscount should set financial discount to null',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);
          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );
          await container.read(insertUpdateStateControllerProvider.future);

          final stateBefore = container
              .read(insertUpdateStateControllerProvider)
              .value!;
          final updatedRequestType = stateBefore.requestType?.copyWith(
            allowFinancialDiscount: true,
          );
          controller.updateProcessedCart(
            stateBefore.copyWith(
              requestType: updatedRequestType,
              financialDiscount: EntityFactory.makeBSFValueTypeEntity()
                  .copyWith(type: PercentageOrValue.reais, value: 5.0),
            ),
          );

          expect(
            container
                .read(insertUpdateStateControllerProvider)
                .value!
                .financialDiscount,
            isNotNull,
          );

          controller.removeFinancialDiscount();

          expect(
            container
                .read(insertUpdateStateControllerProvider)
                .value!
                .financialDiscount,
            isNull,
          );
        },
      );
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
          controller.updateCustomerOrCovenant(customer1);
          final state = container.read(insertUpdateStateControllerProvider);
          expect(
            state.value!.customer,
            customer1.copyWith(annulSelectedCovenant: true),
          );

          final customer2 = EntityFactory.makeBSFCustomerEntity().copyWith(
            code: 2,
          );
          controller.updateCustomerOrCovenant(customer2);
          final state2 = container.read(insertUpdateStateControllerProvider);
          expect(
            state2.value!.customer,
            customer2.copyWith(annulSelectedCovenant: true),
          );

          final customer3 = EntityFactory.makeBSFCustomerEntity().copyWith(
            code: 2,
          );
          //annul when is the same customer code from the previous
          controller.updateCustomerOrCovenant(customer3);
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
                code: 100,
                paymentFinalizations: const [],
              ),
              products: const [],
              discounts: const [],
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
              code: 200,
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
                code: 100,
                paymentFinalizations: const [],
              ),
              products: const [],
              discounts: const [],
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
              code: 200,
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
                  code: 999,
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
                  code: 999,
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
          );

          final state = container
              .read(insertUpdateStateControllerProvider)
              .value!;
          expect(state.customer!.selectedCovenant, customer.covenants![0]);

          controller.updateCustomerOrCovenant(
            state.customer!,
            covenant: customer.covenants![0],
            isChangingCovenant: true,
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

            final baseCustomerCode = fakeSaleRequest.customer?.code ?? 100;

            final initialCustomer = EntityFactory.makeBSFCustomerEntity()
                .copyWith(
                  code: baseCustomerCode + 1,
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
            );

            // Create new customer with payment restrictions to trigger actions
            final allowedPayment =
                EntityFactory.makeBSFPaymentFinalizationEntity().copyWith(
                  code: baseCustomerCode + 2,
                );
            final restrictedCustomer = EntityFactory.makeBSFCustomerEntity()
                .copyWith(
                  code: baseCustomerCode + 2,
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
          controller.updateProcessedCart(
            container.read(insertUpdateStateControllerProvider).value!,
          );

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

      test(
        'updateProcessedCart should maintain the last selected covenant of the customer',
        () async {
          final container = makeProviderContainer(saleRequestId: 1);
          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );
          await container.read(insertUpdateStateControllerProvider.future);

          final covenant = faker.randomGenerator.boolean()
              ? EntityFactory.makeBsfCovenantEntity().copyWith(code: 123)
              : null;
          final customer = EntityFactory.makeBSFCustomerEntity().copyWith(
            code: 1,
            covenants: [?covenant],
            selectedCovenant: covenant,
          );

          controller.updateCustomerOrCovenant(
            customer,
            covenant: covenant,
            isChangingCovenant: true,
          );

          final state = container
              .read(insertUpdateStateControllerProvider)
              .value!;
          expect(state.customer?.selectedCovenant, covenant);

          final processedCustomerWithoutCovenant = customer.copyWith(
            annulSelectedCovenant: true,
          );
          final processedCart = state.copyWith(
            customer: processedCustomerWithoutCovenant,
          );

          controller.updateProcessedCart(processedCart);

          final updatedState = container
              .read(insertUpdateStateControllerProvider)
              .value!;
          expect(updatedState.customer?.selectedCovenant, covenant);
        },
      );
    });

    group('Update Instructions and Observations', () {
      test(
        'updateInstructions should update instructions when state is AsyncData',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);
          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );

          await container.read(insertUpdateStateControllerProvider.future);

          final instructions = faker.lorem.sentence();
          controller.updateInstructions(instructions);

          final state = container.read(insertUpdateStateControllerProvider);
          expect(state.value!.instructions, instructions);
        },
      );

      test(
        'updateInstructions should do nothing if state is not AsyncData',
        () {
          final container = makeProviderContainer(saleRequestId: 0);
          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );

          final stateBefore = container.read(
            insertUpdateStateControllerProvider,
          );
          expect(stateBefore, isA<AsyncLoading<BSFSaleRequestEntity>>());

          controller.updateInstructions(faker.lorem.sentence());

          final stateAfter = container.read(
            insertUpdateStateControllerProvider,
          );
          expect(stateAfter, isA<AsyncLoading<BSFSaleRequestEntity>>());
        },
      );

      test(
        'updateObservations should update observations when state is AsyncData',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);
          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );

          await container.read(insertUpdateStateControllerProvider.future);

          final observations = faker.lorem.sentence();
          controller.updateObservations(observations);

          final state = container.read(insertUpdateStateControllerProvider);
          expect(state.value!.observations, observations);
        },
      );

      test(
        'updateObservations should do nothing if state is not AsyncData',
        () {
          final container = makeProviderContainer(saleRequestId: 0);
          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );

          final stateBefore = container.read(
            insertUpdateStateControllerProvider,
          );
          expect(stateBefore, isA<AsyncLoading<BSFSaleRequestEntity>>());

          controller.updateObservations(faker.lorem.sentence());

          final stateAfter = container.read(
            insertUpdateStateControllerProvider,
          );
          expect(stateAfter, isA<AsyncLoading<BSFSaleRequestEntity>>());
        },
      );
    });

    group('Update increment', () {
      test(
        'updateIncrement should update increment when state is AsyncData',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);
          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );

          // We wait for the asynchronous build method of the controller to complete, transitioning
          // the state from AsyncLoading to AsyncData.
          await container.read(insertUpdateStateControllerProvider.future);

          final incrementValue = EntityFactory.makeBSFValueTypeEntity();
          controller.updateIncrement(incrementValue);

          final state = container.read(insertUpdateStateControllerProvider);
          expect(state.value!.increment, incrementValue);
        },
      );

      test('updateIncrement should do nothing if state is not AsyncData', () {
        final container = makeProviderContainer(saleRequestId: 0);
        final controller = container.read(
          insertUpdateStateControllerProvider.notifier,
        );

        // We verify the initial state is AsyncLoading to ensure the Guard Clause 'state is! AsyncData' triggers.
        final stateBefore = container.read(insertUpdateStateControllerProvider);
        expect(stateBefore, isA<AsyncLoading<BSFSaleRequestEntity>>());

        final incrementValue = EntityFactory.makeBSFValueTypeEntity();
        controller.updateIncrement(incrementValue);

        // The state must remain AsyncLoading, verifying that updateIncrement is safely ignored.
        final stateAfter = container.read(insertUpdateStateControllerProvider);
        expect(stateAfter, isA<AsyncLoading<BSFSaleRequestEntity>>());
      });
    });
    group('Remove increment', () {
      test(
        'removeIncrement should nullify increment when state is AsyncData',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);
          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );

          await container.read(insertUpdateStateControllerProvider.future);

          // First, we set an increment to establish a baseline state.
          final incrementValue = EntityFactory.makeBSFValueTypeEntity();
          controller.updateIncrement(incrementValue);
          expect(
            container
                .read(insertUpdateStateControllerProvider)
                .value!
                .increment,
            incrementValue,
          );

          // We execute removeIncrement to clear the state.
          controller.removeIncrement();

          final state = container.read(insertUpdateStateControllerProvider);
          expect(state.value!.increment, isNull);
        },
      );

      test('removeIncrement should do nothing if state is not AsyncData', () {
        final container = makeProviderContainer(saleRequestId: 0);
        final controller = container.read(
          insertUpdateStateControllerProvider.notifier,
        );

        final stateBefore = container.read(insertUpdateStateControllerProvider);
        expect(stateBefore, isA<AsyncLoading<BSFSaleRequestEntity>>());

        controller.removeIncrement();

        final stateAfter = container.read(insertUpdateStateControllerProvider);
        expect(stateAfter, isA<AsyncLoading<BSFSaleRequestEntity>>());
      });
    });
    group('Update Delivery tax', () {
      test(
        'updateDeliveryTax should update increment when state is AsyncData',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);
          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );

          // We wait for the asynchronous build method of the controller to complete, transitioning
          // the state from AsyncLoading to AsyncData.
          await container.read(insertUpdateStateControllerProvider.future);

          final deliveryTax = EntityFactory.makeBSFValueTypeEntity();
          controller.updateDeliveryTax(deliveryTax);

          final state = container.read(insertUpdateStateControllerProvider);
          expect(
            state.value!.deliveryTax,
            BSFDeliveryTaxWrapperEntity(
              deliveryTax: deliveryTax,
              mailFreightType: state.value?.deliveryTax?.mailFreightType,
              isFob: state.value?.deliveryTax?.isFob,
              isDiscounted: state.value?.deliveryTax?.isDiscounted,
            ),
          );
        },
      );

      test('updateDeliveryTax should do nothing if state is not AsyncData', () {
        final container = makeProviderContainer(saleRequestId: 0);
        final controller = container.read(
          insertUpdateStateControllerProvider.notifier,
        );

        // We verify the initial state is AsyncLoading to ensure the Guard Clause 'state is! AsyncData' triggers.
        final stateBefore = container.read(insertUpdateStateControllerProvider);
        expect(stateBefore, isA<AsyncLoading<BSFSaleRequestEntity>>());

        final deliveryTax = EntityFactory.makeBSFValueTypeEntity();
        controller.updateDeliveryTax(deliveryTax);

        // The state must remain AsyncLoading, verifying that updateDeliveryTax is safely ignored.
        final stateAfter = container.read(insertUpdateStateControllerProvider);
        expect(stateAfter, isA<AsyncLoading<BSFSaleRequestEntity>>());
      });
    });
    group('Remove Delivery tax', () {
      test(
        'removeDeliveryTax should nullify deliveryTax when state is AsyncData',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);
          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );

          await container.read(insertUpdateStateControllerProvider.future);

          // First, we set an increment to establish a baseline state.
          final deliveryTax = EntityFactory.makeBSFValueTypeEntity();
          controller.updateDeliveryTax(deliveryTax);
          expect(
            container
                .read(insertUpdateStateControllerProvider)
                .value!
                .deliveryTax
                ?.deliveryTax,
            deliveryTax,
          );

          // We execute removeDeliveryTax to clear the state.
          controller.removeDeliveryTax();

          final state = container.read(insertUpdateStateControllerProvider);
          expect(state.value!.deliveryTax, isNull);
        },
      );

      test('removeDeliveryTax should do nothing if state is not AsyncData', () {
        final container = makeProviderContainer(saleRequestId: 0);
        final controller = container.read(
          insertUpdateStateControllerProvider.notifier,
        );

        final stateBefore = container.read(insertUpdateStateControllerProvider);
        expect(stateBefore, isA<AsyncLoading<BSFSaleRequestEntity>>());

        controller.removeIncrement();

        final stateAfter = container.read(insertUpdateStateControllerProvider);
        expect(stateAfter, isA<AsyncLoading<BSFSaleRequestEntity>>());
      });
    });
    group('Update discount', () {
      test(
        'updateDiscount should update discounts when state is AsyncData',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);
          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );

          await container.read(insertUpdateStateControllerProvider.future);

          final discountValue = EntityFactory.makeBSFValueTypeEntity();
          controller.updateDiscount(discountValue);

          final state = container.read(insertUpdateStateControllerProvider);
          expect(state.value!.discounts, [
            BSFDiscountEntity(
              order: 0,
              discountOrigin: DiscountOrigin.manual,
              user: null,
              justification: 'Desconto manual',
              discount: discountValue,
            ),
          ]);
        },
      );

      test('updateDiscount should do nothing if state is not AsyncData', () {
        final container = makeProviderContainer(saleRequestId: 0);
        final controller = container.read(
          insertUpdateStateControllerProvider.notifier,
        );

        final stateBefore = container.read(insertUpdateStateControllerProvider);
        expect(stateBefore, isA<AsyncLoading<BSFSaleRequestEntity>>());

        final discountValue = EntityFactory.makeBSFValueTypeEntity();
        controller.updateDiscount(discountValue);

        final stateAfter = container.read(insertUpdateStateControllerProvider);
        expect(stateAfter, isA<AsyncLoading<BSFSaleRequestEntity>>());
      });
    });

    group('Remove discount', () {
      test(
        'removeDiscount should nullify discounts when state is AsyncData',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);
          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );

          await container.read(insertUpdateStateControllerProvider.future);

          // Set a discount as baseline
          final discountValue = EntityFactory.makeBSFValueTypeEntity();
          controller.updateDiscount(discountValue);
          expect(
            container
                .read(insertUpdateStateControllerProvider)
                .value!
                .discounts,
            isNotEmpty,
          );

          // Execute removeDiscount
          controller.removeDiscount();

          final state = container.read(insertUpdateStateControllerProvider);
          expect(state.value!.discounts, isNull);
        },
      );

      test('removeDiscount should do nothing if state is not AsyncData', () {
        final container = makeProviderContainer(saleRequestId: 0);
        final controller = container.read(
          insertUpdateStateControllerProvider.notifier,
        );

        final stateBefore = container.read(insertUpdateStateControllerProvider);
        expect(stateBefore, isA<AsyncLoading<BSFSaleRequestEntity>>());

        controller.removeDiscount();

        final stateAfter = container.read(insertUpdateStateControllerProvider);
        expect(stateAfter, isA<AsyncLoading<BSFSaleRequestEntity>>());
      });
    });

    group('saleRequestHasChanges', () {
      test(
        'should return false for new request with empty entity (no customer or products)',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);
          await container.read(insertUpdateStateControllerProvider.future);

          final hasChanges = container.read(saleRequestHasChangesProvider);
          expect(hasChanges, isFalse);
        },
      );

      test(
        'should return true for new request after adding a product',
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

          final hasChanges = container.read(saleRequestHasChangesProvider);
          expect(hasChanges, isTrue);
        },
      );

      test(
        'should return true for new request after selecting a customer',
        () async {
          final container = makeProviderContainer(saleRequestId: 0);
          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );
          await container.read(insertUpdateStateControllerProvider.future);

          final customer = EntityFactory.makeBSFCustomerEntity();
          controller.updateCustomerOrCovenant(customer);

          final hasChanges = container.read(saleRequestHasChangesProvider);
          expect(hasChanges, isTrue);
        },
      );

      test(
        'should return false for existing request when no changes are made',
        () async {
          final container = makeProviderContainer(saleRequestId: 1);
          await container.read(insertUpdateStateControllerProvider.future);

          final hasChanges = container.read(saleRequestHasChangesProvider);
          // original == current, so no changes
          expect(hasChanges, isFalse);
        },
      );

      test(
        'should return true for existing request after modifying a field',
        () async {
          final container = makeProviderContainer(saleRequestId: 1);
          final controller = container.read(
            insertUpdateStateControllerProvider.notifier,
          );
          await container.read(insertUpdateStateControllerProvider.future);

          controller.updateObservations(faker.lorem.sentence());

          final hasChanges = container.read(saleRequestHasChangesProvider);
          expect(hasChanges, isTrue);
        },
      );
    });

    group('set state override debounce', () {
      test(
        'should save the draft to the repository after 500ms when state changes and saleRequestId is 0',
        () async {
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

          final expectedEntity = BSFSaleRequestEntity.empty()
              .copyWith(
                requestType: fakeSaleRequest.requestType,
              )
              .copyWith(
                products: [
                  product.toBSFProductItemEntity().copyWith(quantity: 1),
                ],
              );

          verifyNever(() => mockLocalBSFSaleRequestDraftRepository.save(
                expectedEntity,
                enterpriseCode: fakeArgs.enterpriseCode,
                requestTypeCode: fakeSaleRequest.requestType?.code ?? 0,
              ));

          await Future.delayed(const Duration(milliseconds: 550));

          verify(() => mockLocalBSFSaleRequestDraftRepository.save(
                expectedEntity,
                enterpriseCode: fakeArgs.enterpriseCode,
                requestTypeCode: fakeSaleRequest.requestType?.code ?? 0,
              )).called(1);
        },
      );
    });
  });
}
