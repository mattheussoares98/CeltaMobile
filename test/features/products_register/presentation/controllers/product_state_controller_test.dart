// test/features/products_register/presentation/controllers/product_state_controller_test.dart
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/products_register/domain/repositories/repositories.dart';
import 'package:celta_inventario/features/products_register/presentation/controllers/product_state_controller.dart';
import 'package:celta_inventario/features/products_register/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockEcProductRepository extends Mock implements IEcProductRepository {}

void main() {
  late MockEcProductRepository mockRepository;
  late UserSessionModel fakeSession;
  late ProductEntity fakeProduct;
  late int enterpriseCode;
  late int productCode;
  late EcRequestParams expectedParams;

  setUp(() {
    mockRepository = MockEcProductRepository();

    // Enforce EntityFactory pattern as required by the senior mentor instructions
    final sessionEntity = EntityFactory.makeUserSessionEntity();
    fakeSession = UserSessionModel.fromEntity(sessionEntity);

    fakeProduct = EntityFactory.makeProductEntity();
    enterpriseCode = fakeProduct.EnterpriseCode!;
    productCode = fakeProduct.ProductCode!;

    expectedParams = EcRequestParams(
      workingUrl: fakeSession.enterprise!.workingUrl!,
      user: fakeSession.user.name!,
      accessKey: fakeSession.user.AccessKey!,
    );
  });

  ProviderContainer makeProviderContainer() {
    return ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        ecProductRepositoryProvider.overrideWithValue(mockRepository),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(fakeSession),
        ),
      ],
    );
  }

  group('ProductStateController', () {
    test(
      'should fetch and return product from repository successfully',
      () async {
        // ARRANGE
        when(
          () => mockRepository.get(
            expectedParams,
            productCode: productCode,
            enterpriseCode: enterpriseCode,
          ),
        ).thenAnswer((_) async => fakeProduct);

        final container = makeProviderContainer();
        addTearDown(container.dispose);

        // Listen to the provider to keep it active
        container.listen(
          productStateControllerProvider(
            enterpriseCode: enterpriseCode,
            productCode: productCode,
          ),
          (previous, next) {},
        );

        // ACT
        final result = await container.read(
          productStateControllerProvider(
            enterpriseCode: enterpriseCode,
            productCode: productCode,
          ).future,
        );

        // ASSERT
        expect(result, equals(fakeProduct));
        verify(
          () => mockRepository.get(
            expectedParams,
            productCode: productCode,
            enterpriseCode: enterpriseCode,
          ),
        ).called(1);
      },
    );

    test(
      'should propagate error if repository.get throws an exception',
      () async {
        // ARRANGE
        final exception = Exception('Failed to fetch product');
        when(
          () => mockRepository.get(
            expectedParams,
            productCode: productCode,
            enterpriseCode: enterpriseCode,
          ),
        ).thenAnswer((_) async => throw exception);

        final container = makeProviderContainer();
        addTearDown(container.dispose);

        // ACT & ASSERT
        await expectLater(
          container.read(
            productStateControllerProvider(
              enterpriseCode: enterpriseCode,
              productCode: productCode,
            ).future,
          ),
          throwsA(isA<Exception>()),
        );

        verify(
          () => mockRepository.get(
            expectedParams,
            productCode: productCode,
            enterpriseCode: enterpriseCode,
          ),
        ).called(1);
      },
    );
  });
}
