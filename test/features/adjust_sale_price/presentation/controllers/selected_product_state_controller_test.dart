import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/core/providers/products/products.dart';
import 'package:celta_inventario/features/enterprises/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/adjust_sale_price/presentation/controllers/controllers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late SoapProductsRepositorySpy mockSoapProductsRepository;
  late UserSessionEntity userSessionEntity;
  late ProductEntity productEntity;
  late int enterpriseCode;

  setUp(() {
    enterpriseCode = faker.randomGenerator.integer(100);
    mockSoapProductsRepository = SoapProductsRepositorySpy();
    userSessionEntity = EntityFactory.makeUserSessionEntity(
      selectedEnterpriseCode: enterpriseCode,
    );
    productEntity = EntityFactory.makeProductEntity();

    registerFallbackValue(BsRoutine.adjustSalePrice);
    registerFallbackValue(SearchType.dynamic);

    mockSoapProductsRepository.mockLoad([productEntity]);
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeEnterpriseEntity());
    registerFallbackValue(EntityFactory.makeGetProductsJsonParams());
  });

  ProviderContainer makeProviderContainer() {
    return ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        soapLoadProductsRepositoryProvider.overrideWithValue(
          mockSoapProductsRepository,
        ),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(
            UserSessionModel.fromEntity(userSessionEntity),
          ),
        ),
        enterprisesStateControllerProvider(
          enterpriseCode: enterpriseCode,
        ).overrideWith(
          () => FakeEnterprisesStateController([
            userSessionEntity.supabaseEnterprise!,
          ]),
        ),
      ],
    );
  }

  group('build', () {
    test('should return null when build', () async {
      final container = makeProviderContainer();
      final state = await container.read(
        selectedProductStateControllerProvider(
          enterpriseCode,
          productEntity.PLU!,
        ).future,
      );

      expect(state, isNull);
    });
  });

  group('Update selected product', () {
    test(
      'should load the product remotely when select product with null value',
      () async {
        final provider = selectedProductStateControllerProvider(
          enterpriseCode,
          productEntity.PLU!,
        );
        final container = makeProviderContainer();

        final result = await container.read(provider.future);
        expect(result, isNull);

        await container.read(provider.notifier).updateSelectedProduct(null);

        final state = await container.read(provider.future);
        expect(state, productEntity);

        verify(
          () => mockSoapProductsRepository.load(
            workingUrl: any(named: 'workingUrl'),
            searchType: any(named: 'searchType'),
            crossIdentity: any(named: 'crossIdentity'),
            enterpriseEntity: any(named: 'enterpriseEntity'),
            getProductsDefaultParams: any(named: 'getProductsDefaultParams'),
          ),
        ).called(1);
      },
    );

    test('should not call repository when product is not null', () async {
      final provider = selectedProductStateControllerProvider(
        enterpriseCode,
        productEntity.PLU!,
      );
      final container = makeProviderContainer();
      final states = <AsyncValue<ProductEntity?>>[];
      container.listen(provider, (_, next) => states.add(next));

      final result = await container.read(provider.future);

      expect(result, isNull);

      await container
          .read(provider.notifier)
          .updateSelectedProduct(productEntity);

      expect(states, [isA<AsyncData>()]);

      final state = await container.read(provider.future);
      expect(state, productEntity);

      verifyNever(
        () => mockSoapProductsRepository.load(
          workingUrl: any(named: 'workingUrl'),
          searchType: any(named: 'searchType'),
          crossIdentity: any(named: 'crossIdentity'),
          enterpriseEntity: any(named: 'enterpriseEntity'),
          getProductsDefaultParams: any(named: 'getProductsDefaultParams'),
        ),
      );
    });
  });
}
