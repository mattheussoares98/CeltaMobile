import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/products/products.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/receipt/data/datasource/datasource.dart';
import 'package:celta_inventario/features/receipt/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/receipt/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockSoapUpdateProductDatasource extends Mock
    implements ISoapUpdateProductDatasource {
  MockSoapUpdateProductDatasource() {
    when(
      () => this.update(
        workingUrl: any(named: 'workingUrl'),
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
  late MockSoapUpdateProductDatasource mockDatasource;
  late UserSessionModel fakeSession;

  // Test data variables
  late int fakeGrDocCode;
  late int fakeProductCode;
  late int fakeProductPackingCode;
  late ProductEntity fakeProduct;
  late SearchProductKey fakeSearchKey;
  late DateTime? newValidityDate;

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
    mockDatasource = MockSoapUpdateProductDatasource();

    // Initialize required data
    fakeGrDocCode = faker.randomGenerator.integer(100);
    fakeProductCode = 50;
    fakeProductPackingCode = 100;
    newValidityDate = faker.randomGenerator.boolean()
        ? faker.date.dateTime()
        : null;

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
      () => mockDatasource.update(
        workingUrl: any(named: 'workingUrl'),
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
      retry: (retryCount, error) => null,
      overrides: [
        soapUpdateProductDatasourceProvider.overrideWithValue(mockDatasource),
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
    test('updateQuantity should behave correctly on success', () async {
      // ARRANGEF
      final spySearchProducts = FakeSearchProductsStateController([
        fakeProduct.copyWith(
          Quantidade_ProcRecebDocProEmb: 20, //first quantity
        ),
      ]);
      final isSubtract = faker.randomGenerator.boolean();

      final container = makeProviderContainer(
        session: fakeSession,
        spySearchProducts: spySearchProducts,
      );
      addTearDown(container.dispose);

      // ACT
      await container
          .read(updateProductControllerProvider(fakeSearchKey).notifier)
          .updateValues(
            grDocCode: fakeGrDocCode,
            productPackingCode: fakeProductPackingCode,
            isSubtract: isSubtract,
            newValidityDate: newValidityDate,
            quantity: 10,
          );

      // ASSERT
      // 1. Verify remote API call (uses calculated new quantity)
      verify(
        () => mockDatasource.update(
          productCode: fakeProductCode,
          productPackingCode: fakeProductPackingCode,
          newQuantity: isSubtract
              ? -10
              : 10, // Critical check. 20 - 10 = 10 || 20 + 10 = 30
          newValidityDate: newValidityDate,
          crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
          workingUrl: fakeSession.enterprise!.workingUrl!,
          grDocCode: fakeGrDocCode,
        ),
      ).called(1);

      // 2. Verify local optimistic update
      expect(spySearchProducts.updatedProduct, isNotNull);
      expect(
        spySearchProducts.updatedProduct?.DataValidade_ProcRecebDocProEmb,
        newValidityDate,
      );
      expect(
        spySearchProducts.updatedProduct!.Quantidade_ProcRecebDocProEmb,
        isSubtract ? 10 : 30, //20 - 10 = 10 || 20 + 10 = 30
      );
    });

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
          .updateValues(
            grDocCode: fakeGrDocCode,
            newValidityDate: DateTime.now(),
            isSubtract: false,
            quantity: 1,
            productPackingCode: fakeProductPackingCode,
          );

      // Verify no update product side effect occurred
      expect(spySearchProducts.updatedProduct, isNull);
    });
    test(
      'should throw error when new quantity will be less than zero',
      () async {
        // ARRANGE
        final spySearchProducts = FakeSearchProductsStateController([
          fakeProduct.copyWith(Quantidade_ProcRecebDocProEmb: 10),
        ]);
        final container = makeProviderContainer(
          session: fakeSession,
          spySearchProducts: spySearchProducts,
        );
        addTearDown(container.dispose);

        // ACT & ASSERT
        await container
            .read(updateProductControllerProvider(fakeSearchKey).notifier)
            .updateValues(
              grDocCode: fakeGrDocCode,
              newValidityDate: DateTime.now(),
              isSubtract: true,
              quantity: 11,
              productPackingCode: fakeProductPackingCode,
            );

        expect(
          container.read(updateProductControllerProvider(fakeSearchKey)),
          isA<AsyncError>(),
        );
      },
    );

    test('Should clear date when pass null value in the request', () async {
      // ARRANGEF
      final spySearchProducts = FakeSearchProductsStateController([
        fakeProduct,
      ]);
      final isSubtract = faker.randomGenerator.boolean();

      final container = makeProviderContainer(
        session: fakeSession,
        spySearchProducts: spySearchProducts,
      );
      addTearDown(container.dispose);

      // ACT
      await container
          .read(updateProductControllerProvider(fakeSearchKey).notifier)
          .updateValues(
            grDocCode: fakeGrDocCode,
            productPackingCode: fakeProductPackingCode,
            isSubtract: isSubtract,
            newValidityDate: null,
            quantity: faker.randomGenerator.decimal(),
          );

      // ASSERT

      // 2. Verify local optimistic update
      expect(
        spySearchProducts.updatedProduct?.DataValidade_ProcRecebDocProEmb,
        isNull,
      );
    });
  });
}
