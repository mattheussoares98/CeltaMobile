import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/presentation/controllers/products/products.dart';
import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_intelligence/exceptions/app_exception.dart';
import 'package:celta_intelligence/features/competing_prices/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/competing_prices/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/competing_prices/providers/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockSoapInsertUpdatePricesDatasource extends Mock
    implements ISoapInsertUpdatePricesDatasource {}

class SpySearchProductsStateController extends SearchProductsStateController {
  ProductEntity? capturedProduct;

  // The build method is required by the base class
  @override
  Future<List<ProductEntity>> build(SearchProductKey searchProductKey) async =>
      [];

  // This is the method we spy on
  @override
  void updateProduct(ProductEntity updatedProduct) {
    capturedProduct = updatedProduct;
  }
}

void main() {
  late MockSoapInsertUpdatePricesDatasource mockDatasource;
  late UserSessionModel fakeSession;

  // Test data variables
  late int researchCode;
  late int concurrentCode;
  late double priceRetail;
  late double offerRetail;
  late double priceWhole;
  late double offerWhole;
  late double priceECommerce;
  late double offerECommerce;
  late int enterpriseCode;
  late ProductEntity product;

  const BsRoutine fakeRoutine = BsRoutine.researchOfPrice;
  const Modules fakeModule = Modules.competingPrices;

  setUpAll(() {
    // Register nullable doubles for mocktail
    registerFallbackValue(faker.randomGenerator.decimal());
    registerFallbackValue(null);
  });

  setUp(() {
    mockDatasource = MockSoapInsertUpdatePricesDatasource();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );

    // Initialize test data using faker
    researchCode = faker.randomGenerator.integer(100);
    concurrentCode = faker.randomGenerator.integer(100);
    enterpriseCode = faker.randomGenerator.integer(100);
    priceRetail = faker.randomGenerator.decimal();
    offerRetail = faker.randomGenerator.decimal();
    priceWhole = faker.randomGenerator.decimal();
    offerWhole = faker.randomGenerator.decimal();
    priceECommerce = faker.randomGenerator.decimal();
    offerECommerce = faker.randomGenerator.decimal();
    product = EntityFactory.makeProductEntity(enterpriseCode: enterpriseCode);
  });

  ProviderContainer makeProviderContainer({
    UserSessionModel? session,
    required SpySearchProductsStateController spySearchProducts,
  }) {
    return ProviderContainer(
      overrides: [
        soapInsertUpdatePricesDatasourceProvider.overrideWithValue(
          mockDatasource,
        ),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
        searchProductsStateControllerProvider(
          SearchProductKey(enterpriseCode, fakeRoutine, fakeModule),
        ).overrideWith(() => spySearchProducts),
      ],
    );
  }

  group('UpdatePricesController', () {
    test(
      'insertUpdatePrices should emit [loading, data] and call datasource with all parameters',
      () async {
        // ARRANGE
        when(
          () => mockDatasource.insert(
            urlInUse: any(named: 'urlInUse'),
            crossIdentity: any(named: 'crossIdentity'),
            researchCode: any(named: 'researchCode'),
            concurrentCode: any(named: 'concurrentCode'),
            productPackingCode: any(named: 'productPackingCode'),
            priceLookUp: any(named: 'priceLookUp'),
            priceRetail: any(named: 'priceRetail'),
            offerRetail: any(named: 'offerRetail'),
            priceWhole: any(named: 'priceWhole'),
            offerWhole: any(named: 'offerWhole'),
            priceECommerce: any(named: 'priceECommerce'),
            offerECommerce: any(named: 'offerECommerce'),
          ),
        ).thenAnswer((_) async {});
        final spySearchProducts = SpySearchProductsStateController();

        final container = makeProviderContainer(
          session: fakeSession,
          spySearchProducts: spySearchProducts,
        );
        addTearDown(container.dispose);

        final states = <AsyncValue<void>>[];
        container.listen(
          updatePricesControllerProvider,
          (_, next) => states.add(next),
        );

        // ACT
        await container
            .read(updatePricesControllerProvider.notifier)
            .insertUpdate(
              enterpriseCode: enterpriseCode,
              researchCode: researchCode,
              concurrentCode: concurrentCode,
              priceRetail: priceRetail,
              offerRetail: offerRetail,
              priceWhole: priceWhole,
              offerWhole: offerWhole,
              priceECommerce: priceECommerce,
              offerECommerce: offerECommerce,
              product: product,
            );

        // ASSERT
        expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);

        // Verify datasource call
        verify(
          () => mockDatasource.insert(
            urlInUse: any(named: 'urlInUse'),
            crossIdentity: any(named: 'crossIdentity'),
            researchCode: any(named: 'researchCode'),
            concurrentCode: any(named: 'concurrentCode'),
            productPackingCode: any(named: 'productPackingCode'),
            priceLookUp: any(named: 'priceLookUp'),
            priceRetail: any(named: 'priceRetail'),
            offerRetail: any(named: 'offerRetail'),
            priceWhole: any(named: 'priceWhole'),
            offerWhole: any(named: 'offerWhole'),
            priceECommerce: any(named: 'priceECommerce'),
            offerECommerce: any(named: 'offerECommerce'),
          ),
        ).called(1);

        expect(spySearchProducts.capturedProduct, isNotNull);

        final capturedProduct = spySearchProducts.capturedProduct!;
        expect(capturedProduct.ProductPackingCode, product.ProductPackingCode);
        expect(capturedProduct.ConcurrentCode, concurrentCode);
        expect(capturedProduct.PLU, product.PLU);
        expect(capturedProduct.RetailPracticedPrice, priceRetail);
        expect(capturedProduct.RetailOfferPrice, offerRetail);
        expect(capturedProduct.WholePracticedPrice, priceWhole);
        expect(capturedProduct.WholeOfferPrice, offerWhole);
        expect(capturedProduct.ECommercePracticedPrice, priceECommerce);
        expect(capturedProduct.ECommerceOfferPrice, offerECommerce);
        expect(capturedProduct.Name, product.Name);
      },
    );

    test('should emit [loading, error] when session is invalid', () async {
      // ARRANGE
      final spySearchProducts = SpySearchProductsStateController();
      final container = makeProviderContainer(
        session: null,
        spySearchProducts: spySearchProducts,
      ); // Invalid session
      addTearDown(container.dispose);

      final states = <AsyncValue<void>>[];
      container.listen(
        updatePricesControllerProvider,
        (_, next) => states.add(next),
      );

      // ACT
      await container
          .read(updatePricesControllerProvider.notifier)
          .insertUpdate(
            enterpriseCode: enterpriseCode,
            researchCode: researchCode,
            concurrentCode: concurrentCode,
            priceRetail: priceRetail,
            offerRetail: offerRetail,
            priceWhole: priceWhole,
            offerWhole: offerWhole,
            priceECommerce: priceECommerce,
            offerECommerce: offerECommerce,
            product: product,
          );

      // ASSERT
      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
      expect(states.last.error, isA<AppException>());

      // Verify datasource was never called
      verifyNever(
        () => mockDatasource.insert(
          urlInUse: any(named: 'urlInUse'),
          crossIdentity: any(named: 'crossIdentity'),
          researchCode: any(named: 'researchCode'),
          concurrentCode: any(named: 'concurrentCode'),
          productPackingCode: any(named: 'productPackingCode'),
          priceLookUp: any(named: 'priceLookUp'),
          priceRetail: any(named: 'priceRetail'),
          offerRetail: any(named: 'offerRetail'),
          priceWhole: any(named: 'priceWhole'),
          offerWhole: any(named: 'offerWhole'),
          priceECommerce: any(named: 'priceECommerce'),
          offerECommerce: any(named: 'offerECommerce'),
        ),
      );
    });
  });
}
