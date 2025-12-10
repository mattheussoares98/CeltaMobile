import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/presentation/controllers/products/products.dart';
import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_intelligence/features/receipt/domain/repository/repository.dart';
import 'package:celta_intelligence/features/receipt/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/receipt/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../mocks/mocks.dart';

class MockSoapUpdateProductRepository extends Mock
    implements ISoapUpdateProductRepository {
  MockSoapUpdateProductRepository() {
    when(
      () => this.update(
        baseUrl: any(named: 'baseUrl'),
        crossIdentity: any(named: 'crossIdentity'),
        grDocCode: any(named: 'grDocCode'),
        productCode: any(named: 'productCode'),
        productPackingCode: any(named: 'productPackingCode'),
        newQuantity: any(named: 'newQuantity'),
        newValidityDate: any(named: 'newValidityDate'),
      ),
    ).thenAnswer((_) async {});
  }
}

void main() {
  late MockSoapUpdateProductRepository mockRepository;
  late UserSessionModel fakeSession;

  // Test data variables
  late int fakeGrDocCode;
  late int fakeProductCode;
  late int fakeProductPackingCode;
  late ProductEntity fakeProduct;
  late SearchProductKey fakeSearchKey;

  setUpAll(() {
    registerFallbackValue(DateTime.now());
    registerFallbackValue(1.0);
    registerFallbackValue(null);
    registerFallbackValue(ProductEntity.empty());
    registerFallbackValue(
      const SearchProductKey(1, BsRoutine.adjustStock, Modules.adjustStock),
    );
  });

  setUp(() {
    mockRepository = MockSoapUpdateProductRepository();

    // Initialize required data
    fakeGrDocCode = faker.randomGenerator.integer(100);
    fakeProductCode = 50;
    fakeProductPackingCode = 100;

    // Create the product that will be in the cart
    fakeProduct = EntityFactory.makeProductEntity(
      productCode: fakeProductCode,
      productPackingCode: fakeProductPackingCode,
      Quantidade_ProcRecebDocProEmb: 50.0,
      DataValidade_ProcRecebDocProEmb: DateTime(2026, 1, 1),
    );

    // Create the search key for the family provider
    fakeSearchKey = SearchProductKey(
      faker.randomGenerator.integer(10),
      BsRoutine.adjustStock,
      Modules.adjustStock,
    );

    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );

    // Stub the repository update method to succeed for all tests
    when(
      () => mockRepository.update(
        baseUrl: any(named: 'baseUrl'),
        crossIdentity: any(named: 'crossIdentity'),
        grDocCode: any(named: 'grDocCode'),
        productCode: any(named: 'productCode'),
        productPackingCode: any(named: 'productPackingCode'),
        newValidityDate: any(named: 'newValidityDate'),
        newQuantity: any(named: 'newQuantity'),
      ),
    ).thenAnswer((_) async {});
  });

  ProviderContainer makeProviderContainer({
    UserSessionModel? session,
    required FakeSearchProductsStateController spySearchProducts,
  }) {
    return ProviderContainer(
      overrides: [
        soapUpdateProductRepositoryProvider.overrideWithValue(mockRepository),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
        // Override the SearchProducts controller with the Spy
        searchProductsStateControllerProvider(
          fakeSearchKey,
        ).overrideWith(() => spySearchProducts),
      ],
    );
  }

  group('UpdateProductController', () {
    test(
      'updateValidity should update remote API and perform local optimistic update',
      () async {
        // ARRANGE
        final newValidityDate = DateTime.now();
        final spySearchProducts = FakeSearchProductsStateController([
          fakeProduct,
        ]);
        final container = makeProviderContainer(
          session: fakeSession,
          spySearchProducts: spySearchProducts,
        );
        addTearDown(container.dispose);

        // ACT
        await container
            .read(updateProductControllerProvider(fakeSearchKey).notifier)
            .updateValidity(
              grDocCode: fakeGrDocCode,
              newValidityDate: newValidityDate,
              productCode: fakeProductCode,
              productPackingCode: fakeProductPackingCode,
            );

        // ASSERT
        // 1. Verify remote API call
        verify(
          () => mockRepository.update(
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            baseUrl: fakeSession.enterprise!.baseUrl!,
            newQuantity: null,
            productCode: fakeProductCode,
            productPackingCode: fakeProductPackingCode,
            newValidityDate: newValidityDate,
            grDocCode: fakeGrDocCode,
          ),
        ).called(1);

        // 2. Verify local optimistic update
        expect(spySearchProducts.updatedProduct, isNotNull);
        expect(
          spySearchProducts.updatedProduct!.DataValidade_ProcRecebDocProEmb,
          newValidityDate,
        );
        expect(
          spySearchProducts.updatedProduct!.ProductPackingCode,
          fakeProductPackingCode,
        );
      },
    );

    test(
      'updateQuantity should calculate final quantity, call remote API, and perform local update',
      () async {
        // ARRANGE
        const quantityToSubtract = 10.0;
        const expectedNewQuantity = 40.0; // 50.0 - 10.0
        final spySearchProducts = FakeSearchProductsStateController([
          fakeProduct,
        ]);
        final container = makeProviderContainer(
          session: fakeSession,
          spySearchProducts: spySearchProducts,
        );
        addTearDown(container.dispose);

        // ACT
        await container
            .read(updateProductControllerProvider(fakeSearchKey).notifier)
            .updateQuantity(
              grDocCode: fakeGrDocCode,
              productPackingCode: fakeProductPackingCode,
              isSubtract: true,
              quantity: quantityToSubtract,
            );

        // ASSERT
        // 1. Verify remote API call (uses calculated new quantity)
        verify(
          () => mockRepository.update(
            productCode: fakeProductCode,
            productPackingCode: fakeProductPackingCode,
            newQuantity: expectedNewQuantity, // Critical check
            newValidityDate: null,
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            baseUrl: fakeSession.enterprise!.baseUrl!,
            grDocCode: fakeGrDocCode,
          ),
        ).called(1);

        // 2. Verify local optimistic update
        expect(spySearchProducts.updatedProduct, isNotNull);
        expect(
          spySearchProducts.updatedProduct!.Quantidade_ProcRecebDocProEmb,
          expectedNewQuantity,
        );
      },
    );

    test('should not update when session is invalid', () async {
      // ARRANGE
      final spySearchProducts = FakeSearchProductsStateController([
        fakeProduct,
      ]);
      final container = makeProviderContainer(
        session: null,
        spySearchProducts: spySearchProducts,
      );
      addTearDown(container.dispose);

      // ACT & ASSERT
      await container
          .read(updateProductControllerProvider(fakeSearchKey).notifier)
          .updateValidity(
            grDocCode: fakeGrDocCode,
            newValidityDate: DateTime.now(),
            productCode: fakeProductCode,
            productPackingCode: fakeProductPackingCode,
          );

      // Verify no update product side effect occurred
      expect(spySearchProducts.updatedProduct, isNull);
    });
  });
}
