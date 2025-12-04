import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_intelligence/core/providers/products/products.dart';
import 'package:celta_intelligence/features/enterprises/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/settings/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/transfer_request/presentation/controllers/controllers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late SoapProductsRepositorySpy mockRepository;
  late UserSessionModel fakeSession;
  late EnterpriseEntity fakeEnterprise;
  late AppSettingsEntity fakeAppSettings;
  late List<ProductEntity> fakeProducts;
  late String fakeSearchValue;

  // Family params
  late int enterpriseOriginCode;
  late int enterpriseDestinyCode;
  late int requestTypeCode;

  setUpAll(() {
    registerFallbackValue(SearchType.dynamic);
    registerFallbackValue(EntityFactory.makeEnterpriseEntity());
    registerFallbackValue(EntityFactory.makeGetProductsJsonParams());
  });

  setUp(() {
    mockRepository = SoapProductsRepositorySpy();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakeEnterprise = EntityFactory.makeEnterpriseEntity();
    fakeAppSettings = EntityFactory.makeAppSettingsEntity();
    fakeProducts = [EntityFactory.makeProductEntity()];
    fakeSearchValue = faker.lorem.word();

    enterpriseOriginCode = faker.randomGenerator.integer(100);
    enterpriseDestinyCode = faker.randomGenerator.integer(100);
    requestTypeCode = faker.randomGenerator.integer(100);
  });

  ProviderContainer makeProviderContainer({
    UserSessionModel? session,
    EnterpriseEntity? enterprise,
    AppSettingsEntity? settings,
  }) {
    return ProviderContainer(
      overrides: [
        soapLoadProductsRepositoryProvider.overrideWithValue(mockRepository),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
        selectedEnterpriseStateControllerProvider.overrideWith(
          () => FakeSelectedEnterpriseStateController(enterprise),
        ),
        appSettingsStateControllerProvider.overrideWith(
          () => FakeAppSettingsStateController(settings!),
        ),
      ],
    );
  }

  group('ProductsStateController', () {
    test(
      'loadProducts should emit [loading, data] and call repository on success',
      () async {
        // ARRANGE
        when(
          () => mockRepository.load(
            baseUrl: any(named: 'baseUrl'),
            searchType: any(named: 'searchType'),
            crossIdentity: any(named: 'crossIdentity'),
            enterpriseEntity: any(named: 'enterpriseEntity'),
            getProductsDefaultParams: any(named: 'getProductsDefaultParams'),
          ),
        ).thenAnswer((_) async {
          await Future.delayed(Duration.zero); // Simulate async delay
          return fakeProducts;
        });

        final container = makeProviderContainer(
          session: fakeSession,
          enterprise: fakeEnterprise,
          settings: fakeAppSettings,
        );
        addTearDown(container.dispose);

        // Wait for initial build
        await container.read(
          productsStateControllerProvider(
            enterpriseOriginCode: enterpriseOriginCode,
            enterpriseDestinyCode: enterpriseDestinyCode,
            requestTypeCode: requestTypeCode,
          ).future,
        );

        final states = <AsyncValue<List<ProductEntity>>>[];
        container.listen(
          productsStateControllerProvider(
            enterpriseOriginCode: enterpriseOriginCode,
            enterpriseDestinyCode: enterpriseDestinyCode,
            requestTypeCode: requestTypeCode,
          ),
          (_, next) => states.add(next),
        );

        // ACT
        await container
            .read(
              productsStateControllerProvider(
                enterpriseOriginCode: enterpriseOriginCode,
                enterpriseDestinyCode: enterpriseDestinyCode,
                requestTypeCode: requestTypeCode,
              ).notifier,
            )
            .loadProducts(searchValue: fakeSearchValue);

        // ASSERT
        expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
        expect(states.last.value, fakeProducts);
        verify(
          () => mockRepository.load(
            baseUrl: fakeSession.enterprise!.baseUrl!,
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            enterpriseEntity: fakeEnterprise,
            searchType: fakeAppSettings.searchPreference.searchType,
            getProductsDefaultParams: GetProductsByRequestTypeParams(
              searchValue: fakeSearchValue,
              enterpriseOriginCode: enterpriseOriginCode,
              enterpriseDestinyCode: enterpriseDestinyCode,
              requestTypeCode: requestTypeCode,
            ),
          ),
        ).called(1);
      },
    );

    test(
      'loadProducts should emit [loading, error] when session is invalid',
      () async {
        // ARRANGE: Pass null for the session
        final container = makeProviderContainer(
          session: null,
          enterprise: fakeEnterprise,
          settings: fakeAppSettings,
        );
        addTearDown(container.dispose);
        await container.read(
          productsStateControllerProvider(
            enterpriseOriginCode: enterpriseOriginCode,
            enterpriseDestinyCode: enterpriseDestinyCode,
            requestTypeCode: requestTypeCode,
          ).future,
        );

        final states = <AsyncValue<List<ProductEntity>>>[];
        container.listen(
          productsStateControllerProvider(
            enterpriseOriginCode: enterpriseOriginCode,
            enterpriseDestinyCode: enterpriseDestinyCode,
            requestTypeCode: requestTypeCode,
          ),
          (_, next) => states.add(next),
        );

        // ACT
        await container
            .read(
              productsStateControllerProvider(
                enterpriseOriginCode: enterpriseOriginCode,
                enterpriseDestinyCode: enterpriseDestinyCode,
                requestTypeCode: requestTypeCode,
              ).notifier,
            )
            .loadProducts(searchValue: fakeSearchValue);

        // ASSERT
        expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
        verifyNever(
          () => mockRepository.load(
            baseUrl: any(named: 'baseUrl'),
            searchType: any(named: 'searchType'),
            crossIdentity: any(named: 'crossIdentity'),
            enterpriseEntity: any(named: 'enterpriseEntity'),
            getProductsDefaultParams: any(named: 'getProductsDefaultParams'),
          ),
        );
      },
    );
  });
}
