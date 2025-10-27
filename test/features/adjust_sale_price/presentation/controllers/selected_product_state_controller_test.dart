import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_intelligence/core/providers/products/products.dart';
import 'package:celta_intelligence/features/enterprises/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/adjust_sale_price/presentation/controllers/controllers.dart';
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

  group('SelectedProductStateController', () {
    test(
      'should return the previous product when call more than once the same provider',
      () async {
        final container = makeProviderContainer();
        final states = <AsyncValue<ProductEntity?>>[];
        container.listen(
          selectedProductStateControllerProvider(
            enterpriseCode,
            productEntity.PLU,
          ),
          (_, next) => states.add(next),
        );

        final result = await container.read(
          selectedProductStateControllerProvider(
            enterpriseCode,
            productEntity.PLU,
          ).future,
        );

        expect(result, productEntity);

        await container.read(
          selectedProductStateControllerProvider(
            enterpriseCode,
            productEntity.PLU,
          ).future,
        );

        verify(
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
        ).called(1);
      },
    );

    test(
      'should fetch product from repository if initialProduct is null',
      () async {
        final container = makeProviderContainer();
        final states = <AsyncValue<ProductEntity?>>[];
        container.listen(
          selectedProductStateControllerProvider(
            enterpriseCode,
            productEntity.PLU,
          ),
          (_, next) => states.add(next),
        );

        await container.read(
          selectedProductStateControllerProvider(
            enterpriseCode,
            productEntity.PLU,
          ).future,
        );

        expect(states, [isA<AsyncData<ProductEntity?>>()]);
        expect(states.last.value, productEntity);

        verify(
          () => mockSoapProductsRepository.getProductsJson(
            baseUrl: userSessionEntity.supabaseEnterprise!.baseUrl!,
            searchValue: productEntity.PLU,
            routine: BsRoutine.adjustSalePrice,
            searchType: SearchType.dynamic,
            enterpriseCodes: [enterpriseCode],
            enterpriseEntity: userSessionEntity.supabaseEnterprise!,
            lastBuyEntranceQuantity: null,
            crossIdentity: userSessionEntity.user.CrossIdentity_Usuario!,
          ),
        ).called(1);
      },
    );
  });
}
