import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/presentation/controllers/products/products.dart';
import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_intelligence/core/providers/products/products.dart';
import 'package:celta_intelligence/features/enterprises/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/settings/presentation/controllers/controllers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late SoapProductsRepositorySpy sut;

  late FakeUserSession fakeUserSession;

  late UserSessionEntity userSessionEntity;
  late String searchValue;
  late EnterpriseEntity enterpriseEntity;
  late int lastBuyEntranceQuantity;
  late AppSettingsEntity appSettingsEntity;
  late BsRoutine bsRoutine;
  late List<ProductEntity> productsEntities;
  late Modules module;
  late BuyRequestParams? buyRequestParams;
  late CompetingPricesParams? competingPricesParams;

  setUpAll(() {
    for (var routine in BsRoutine.values) {
      registerFallbackValue(routine);
    }
    for (var searchType in SearchType.values) {
      registerFallbackValue(searchType);
    }
    for (var value in Modules.values) {
      registerFallbackValue(value);
    }
    registerFallbackValue(EntityFactory.makeEnterpriseEntity());
  });

  void initEntities() {
    userSessionEntity = EntityFactory.makeUserSessionEntity();
    searchValue = faker.lorem.word();
    enterpriseEntity = EntityFactory.makeEnterpriseEntity();
    lastBuyEntranceQuantity = faker.randomGenerator.integer(100);
    appSettingsEntity = EntityFactory.makeAppSettingsEntity();
    bsRoutine = BsRoutine
        .values[faker.randomGenerator.integer(BsRoutine.values.length)];
    productsEntities = [
      EntityFactory.makeProductEntity(),
      EntityFactory.makeProductEntity(),
      EntityFactory.makeProductEntity(),
    ];
    module =
        Modules.values[faker.randomGenerator.integer(Modules.values.length)];
    buyRequestParams = faker.randomGenerator.boolean() == true
        ? BuyRequestParams(
            requestTypeCode: faker.randomGenerator.integer(100),
            supplierCode: faker.randomGenerator.integer(100),
          )
        : null;
    competingPricesParams = faker.randomGenerator.boolean()
        ? CompetingPricesParams(
            ResearchOfPriceCode: faker.randomGenerator.integer(100),
            ConcurrentCode: faker.randomGenerator.integer(100),
            OnlyAssociated: faker.randomGenerator.boolean(),
            searchType:
                SearchProductCompetingPriceType.values[faker.randomGenerator
                    .integer(SearchProductCompetingPriceType.values.length)],
          )
        : null;
  }

  void initSut() {
    sut = SoapProductsRepositorySpy();
  }

  void initInjections() {
    fakeUserSession = FakeUserSession(
      UserSessionModel.fromEntity(userSessionEntity),
    );
  }

  void mockSuccess() {
    sut.mockLoad(productsEntities);
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  setUpAll(() {
    for (var value in BsRoutine.values) {
      registerFallbackValue(value);
    }
    for (var value in SearchProductCompetingPriceType.values) {
      registerFallbackValue(value);
    }

    registerFallbackValue(EntityFactory.makeGetProductsJsonParams());
  });

  ProviderContainer makeProviderContainer({
    bool? mockSession = true,
    bool? mockAuthState = true,
    bool? mockAppSettingsState = true,
    bool? mockSelectedEnterprise = true,
  }) {
    final container = ProviderContainer(
      overrides: [
        soapLoadProductsRepositoryProvider.overrideWithValue(sut),
        if (mockSession == true)
          validatedUserSessionProvider.overrideWith(
            () => FakeValidatedUserSession(
              UserSessionModel.fromEntity(userSessionEntity),
            ),
          ),
        if (mockAuthState == true)
          userSessionProvider.overrideWith(() => fakeUserSession),
        enterprisesStateControllerProvider(
          enterpriseCode: enterpriseEntity.Code,
        ).overrideWith(
          () => FakeEnterprisesStateController([enterpriseEntity]),
        ),
        if (mockSelectedEnterprise == true)
          selectedEnterpriseStateControllerProvider.overrideWith(
            () => FakeSelectedEnterpriseStateController(enterpriseEntity),
          ),
        if (mockAppSettingsState == true)
          appSettingsStateControllerProvider.overrideWith(
            () => FakeAppSettingsStateController(appSettingsEntity),
          ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('Load products', () {
    test('should behave correctly on success', () async {
      final container = makeProviderContainer();

      await container.read(
        searchProductsStateControllerProvider(
          enterpriseEntity.Code!,
          bsRoutine,
          module,
        ).future,
      );

      final states = <AsyncValue<void>>[];
      container.listen(
        searchProductsStateControllerProvider(
          enterpriseEntity.Code!,
          bsRoutine,
          module,
        ),
        (_, next) => states.add(next),
      );

      await container
          .read(
            searchProductsStateControllerProvider(
              enterpriseEntity.Code!,
              bsRoutine,
              module,
            ).notifier,
          )
          .loadProducts(
            lastBuyEntranceQuantity: lastBuyEntranceQuantity,
            searchValue: searchValue,
            enterpriseCodes: [enterpriseEntity.Code!],
            buyRequestParams: buyRequestParams,
          );

      expect(states, [
        isA<AsyncLoading>(),
        isA<AsyncData<List<ProductEntity>>>(),
      ]);
      verify(
        () => sut.load(
          baseUrl: userSessionEntity.supabaseEnterprise!.baseUrl!,
          crossIdentity: userSessionEntity.user.CrossIdentity_Usuario!,
          enterpriseEntity: enterpriseEntity,
          getProductsDefaultParams: GetProductsJsonParams(
            EnterpriseCodes: [enterpriseEntity.Code!],
            searchType: appSettingsEntity.searchPreference.searchType,
            routine: bsRoutine,
            searchValue: searchValue,
            LastBuyEntranceQuantity: lastBuyEntranceQuantity,
            buyRequestParams: buyRequestParams,
            competingPricesParams: competingPricesParams,
          ),
        ),
      ).called(1);
    });
    test('should behave correctly when session is null', () async {
      final container = makeProviderContainer(mockSession: false);

      await container.read(
        searchProductsStateControllerProvider(
          enterpriseEntity.Code!,
          bsRoutine,
          module,
        ).future,
      );

      final states = <AsyncValue<void>>[];
      container.listen(
        searchProductsStateControllerProvider(
          enterpriseEntity.Code!,
          bsRoutine,
          module,
        ),
        (_, next) => states.add(next),
      );

      await container
          .read(
            searchProductsStateControllerProvider(
              enterpriseEntity.Code!,
              bsRoutine,
              module,
            ).notifier,
          )
          .loadProducts(
            lastBuyEntranceQuantity: lastBuyEntranceQuantity,
            searchValue: searchValue,
            enterpriseCodes: [enterpriseEntity.Code!],
            buyRequestParams: buyRequestParams,
          );

      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
      verifyNever(
        () => sut.load(
          baseUrl: any(named: 'baseUrl'),
          crossIdentity: any(named: 'crossIdentity'),
          enterpriseEntity: any(named: 'enterpriseEntity'),
          getProductsDefaultParams: any(named: 'getProductsDefaultParams'),
        ),
      );
    });

    test('should behave correctly when appSettings is null', () async {
      final container = makeProviderContainer(mockAppSettingsState: false);

      await container.read(
        searchProductsStateControllerProvider(
          enterpriseEntity.Code!,
          bsRoutine,
          module,
        ).future,
      );

      final states = <AsyncValue<void>>[];
      container.listen(
        searchProductsStateControllerProvider(
          enterpriseEntity.Code!,
          bsRoutine,
          module,
        ),
        (_, next) => states.add(next),
      );

      await container
          .read(
            searchProductsStateControllerProvider(
              enterpriseEntity.Code!,
              bsRoutine,
              module,
            ).notifier,
          )
          .loadProducts(
            lastBuyEntranceQuantity: lastBuyEntranceQuantity,
            searchValue: searchValue,
            enterpriseCodes: [enterpriseEntity.Code!],
          );

      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
      verifyNever(
        () => sut.load(
          baseUrl: any(named: 'baseUrl'),
          crossIdentity: any(named: 'crossIdentity'),
          enterpriseEntity: any(named: 'enterpriseEntity'),
          getProductsDefaultParams: any(named: 'getProductsDefaultParams'),
        ),
      );
    });
  });

  group('updateProduct', () {
    test('should update a product in the list if it exists', () async {
      // Set up the repository mock to return the initial list
      sut.mockLoad(productsEntities);

      final container = makeProviderContainer();
      addTearDown(container.dispose);

      // Load the initial state
      await container.read(
        searchProductsStateControllerProvider(
          enterpriseEntity.Code!,
          bsRoutine,
          module,
        ).future,
      );

      //loading products
      await container
          .read(
            searchProductsStateControllerProvider(
              enterpriseEntity.Code!,
              bsRoutine,
              module,
            ).notifier,
          )
          .loadProducts(
            lastBuyEntranceQuantity: lastBuyEntranceQuantity,
            searchValue: searchValue,
            enterpriseCodes: [enterpriseEntity.Code!],
          );

      // Create the updated version of the first product
      final updatedProduct = EntityFactory.makeProductEntity().copyWith(
        ProductPackingCode: productsEntities.first.ProductPackingCode,
      );
      // ACT: Call the updateProduct method
      container
          .read(
            searchProductsStateControllerProvider(
              enterpriseEntity.Code!,
              bsRoutine,
              module,
            ).notifier,
          )
          .updateProduct(updatedProduct);

      // ASSERT
      // Read the final state of the provider
      final finalState = container.read(
        searchProductsStateControllerProvider(
          enterpriseEntity.Code!,
          bsRoutine,
          module,
        ),
      );

      // Check that the list still has 2 items
      expect(finalState.value, hasLength(3));
      // Check that the product with the matching code now has the new name
      expect(finalState.value?.first, updatedProduct);
    });

    test(
      'should do nothing if the product to update is not in the list',
      () async {
        // Create an updated product that does NOT exist in the initial list
        final nonExistentProduct = EntityFactory.makeProductEntity();

        sut.mockLoad(productsEntities);

        final container = makeProviderContainer();
        addTearDown(container.dispose);
        await container.read(
          searchProductsStateControllerProvider(
            enterpriseEntity.Code!,
            bsRoutine,
            module,
          ).future,
        );

        //loading products
        await container
            .read(
              searchProductsStateControllerProvider(
                enterpriseEntity.Code!,
                bsRoutine,
                module,
              ).notifier,
            )
            .loadProducts(
              lastBuyEntranceQuantity: lastBuyEntranceQuantity,
              searchValue: searchValue,
              enterpriseCodes: [enterpriseEntity.Code!],
            );

        // ACT
        container
            .read(
              searchProductsStateControllerProvider(
                enterpriseEntity.Code!,
                bsRoutine,
                module,
              ).notifier,
            )
            .updateProduct(nonExistentProduct);

        // ASSERT
        // Check that the state is still the original list and has not changed.
        final finalState = container.read(
          searchProductsStateControllerProvider(
            enterpriseEntity.Code!,
            bsRoutine,
            module,
          ),
        );
        expect(finalState.value, productsEntities);
        expect(finalState.value, hasLength(3));
        expect(finalState.value, productsEntities);
      },
    );
  });
}
