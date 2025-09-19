import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/providers/providers.dart';
import 'package:celta_intelligence/features/auth/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/enterprises/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/adjust_sale_price/presentation/controllers/controllers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late SoapProductsRepositorySpy mockSoapProductsRepository;
  late UserEntity userEntity;
  late UserSessionModel userSession;
  late EnterpriseEntity enterpriseEntity;
  late ProductEntity productEntity;

  setUp(() {
    mockSoapProductsRepository = SoapProductsRepositorySpy();
    userEntity = EntityFactory.makeUserEntity();
    userSession = EntityFactory.makeUserSessionModel();
    enterpriseEntity = EntityFactory.makeEnterpriseEntity();
    productEntity = EntityFactory.makeProductEntity();

    registerFallbackValue(Routine.adjustSalePrice);
    registerFallbackValue(SearchType.dynamic);

    mockSoapProductsRepository.mockGetProductsJson([productEntity]);
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeEnterpriseEntity());
  });

  ProviderContainer makeProviderContainer() {
    return ProviderContainer(
      overrides: [
        soapProductsRepositoryProvider.overrideWithValue(
          mockSoapProductsRepository,
        ),
        authStateControllerProvider.overrideWith(
          () => FakeAuthStateController(userEntity),
        ),
        userSessionProvider.overrideWith(() => FakeUserSession(userSession)),
        enterprisesStateControllerProvider.overrideWith(
          () => FakeEnterprisesStateController([enterpriseEntity]),
        ),
      ],
    );
  }

  group('SelectedProductStateController', () {
    test('should return the initialProduct immediately if provided', () async {
      final container = makeProviderContainer();
      final states = <AsyncValue<ProductEntity?>>[];
      container.listen(
        selectedProductStateControllerProvider(
          enterpriseEntity.Code!,
          productEntity.PLU,
          productEntity,
        ),
        (_, next) => states.add(next),
      );

      final result = await container.read(
        selectedProductStateControllerProvider(
          enterpriseEntity.Code!,
          productEntity.PLU,
          productEntity,
        ).future,
      );

      expect(result, productEntity);

      verifyNever(
        () => mockSoapProductsRepository.getProductsJson(
          baseUrl: any(named: 'baseUrl'),
          crossIdentity: any(named: 'crossIdentity'),
          searchValue: any(named: 'searchValue'),
          routine: any(named: 'routine'),
          searchType: any(named: 'searchType'),
          enterpriseCodes: any(named: 'enterpriseCodes'),
          enterpriseEntity: any(named: 'enterpriseEntity'),
          lastBuyEntranceQuantity: any(named: 'lastBuyEntranceQuantity'),
        ),
      );
    });

    test(
      'should fetch product from repository if initialProduct is null',
      () async {
        final container = makeProviderContainer();
        final states = <AsyncValue<ProductEntity?>>[];
        container.listen(
          selectedProductStateControllerProvider(
            enterpriseEntity.Code!,
            productEntity.PLU,
            null,
          ),
          (_, next) => states.add(next),
        );

        await container.read(
          selectedProductStateControllerProvider(
            enterpriseEntity.Code!,
            productEntity.PLU,
            null,
          ).future,
        );

        expect(states, [isA<AsyncData<ProductEntity?>>()]);
        expect(states.last.value, productEntity);

        verify(
          () => mockSoapProductsRepository.getProductsJson(
            baseUrl: userSession.baseUrl!,
            searchValue: productEntity.PLU,
            routine: Routine.adjustSalePrice,
            searchType: SearchType.dynamic,
            enterpriseCodes: [enterpriseEntity.Code!],
            enterpriseEntity: enterpriseEntity,
            lastBuyEntranceQuantity: null,
            crossIdentity: userEntity.CrossIdentity_Usuario!,
          ),
        ).called(1);
      },
    );
  });
}
