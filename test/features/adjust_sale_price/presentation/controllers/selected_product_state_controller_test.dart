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

    mockSoapProductsRepository.mockLoad([productEntity]);
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeEnterpriseEntity());
    registerFallbackValue(EntityFactory.makeGetProductsJsonParams());
  });

  ProviderContainer makeProviderContainer() {
    return ProviderContainer(
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

  group('SelectedProductStateController', () {
    test(
      'should return the previous product when call more than once the same provider',
      () async {
        final container = makeProviderContainer();
        final states = <AsyncValue<ProductEntity?>>[];
        container.listen(
          selectedProductStateControllerProvider(
            enterpriseCode,
            productEntity.PLU!,
          ),
          (_, next) => states.add(next),
        );

        final result = await container.read(
          selectedProductStateControllerProvider(
            enterpriseCode,
            productEntity.PLU!,
          ).future,
        );

        expect(result, productEntity);

        await container.read(
          selectedProductStateControllerProvider(
            enterpriseCode,
            productEntity.PLU!,
          ).future,
        );

        verify(
          () => mockSoapProductsRepository.load(
            baseUrl: any(named: 'baseUrl'),
            searchType: any(named: 'searchType'),
            crossIdentity: any(named: 'crossIdentity'),
            enterpriseEntity: any(named: 'enterpriseEntity'),
            getProductsDefaultParams: any(named: 'getProductsDefaultParams'),
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
            productEntity.PLU!,
          ),
          (_, next) => states.add(next),
        );

        await container.read(
          selectedProductStateControllerProvider(
            enterpriseCode,
            productEntity.PLU!,
          ).future,
        );

        expect(states, [isA<AsyncData<ProductEntity?>>()]);
        expect(states.last.value, productEntity);

        verify(
          () => mockSoapProductsRepository.load(
            baseUrl: userSessionEntity.supabaseEnterprise!.baseUrl!,
            crossIdentity: userSessionEntity.user.CrossIdentity_Usuario!,
            enterpriseEntity: userSessionEntity.supabaseEnterprise!,
            searchType: SearchType.dynamic,
            getProductsDefaultParams: GetProductsJsonParams(
              EnterpriseCodes: [enterpriseCode],
              routine: BsRoutine.adjustSalePrice,
              searchValue: productEntity.PLU!,
              LastBuyEntranceQuantity: null,
              buyRequestParams: null,
              competingPricesParams: null,
            ),
          ),
        ).called(1);
      },
    );
  });
}
