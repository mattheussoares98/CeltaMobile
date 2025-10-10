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

  setUpAll(() {
    for (var routine in BsRoutine.values) {
      registerFallbackValue(routine);
    }
    for (var searchType in SearchType.values) {
      registerFallbackValue(searchType);
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
    sut.mockGetProductsJson(productsEntities);
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  setUpAll(() {
    for (var routine in BsRoutine.values) {
      registerFallbackValue(routine);
    }
  });

  ProviderContainer makeProviderContainer({
    bool? mockSession = true,
    bool? mockAuthState = true,
    bool? mockAppSettingsState = true,
  }) {
    final container = ProviderContainer(
      overrides: [
        soapProductsRepositoryProvider.overrideWithValue(sut),
        if (mockSession == true)
          validatedUserSessionProvider.overrideWith(
            () => FakeValidatedUserSession(
              UserSessionModel.fromEntity(userSessionEntity),
            ),
          ),
        if (mockAuthState == true)
          userSessionProvider.overrideWith(() => fakeUserSession),
        enterprisesStateControllerProvider.overrideWith(
          () => FakeEnterprisesStateController([enterpriseEntity]),
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
        ).future,
      );

      final states = <AsyncValue<void>>[];
      container.listen(
        searchProductsStateControllerProvider(
          enterpriseEntity.Code!,
          bsRoutine,
        ),
        (_, next) => states.add(next),
      );

      await container
          .read(
            searchProductsStateControllerProvider(
              enterpriseEntity.Code!,
              bsRoutine,
            ).notifier,
          )
          .loadProducts(
            lastBuyEntranceQuantity: lastBuyEntranceQuantity,
            searchValue: searchValue,
            enterpriseCode: enterpriseEntity.Code!,
            selectedEnterprise: enterpriseEntity,
          );

      expect(states, [
        isA<AsyncLoading>(),
        isA<AsyncData<List<ProductEntity>>>(),
      ]);
      verify(
        () => sut.getProductsJson(
          lastBuyEntranceQuantity: lastBuyEntranceQuantity,
          baseUrl: userSessionEntity.supabaseEnterprise!.baseUrl!,
          searchValue: searchValue,
          routine: bsRoutine,
          searchType: appSettingsEntity.searchPreference.searchType,
          crossIdentity: userSessionEntity.user.CrossIdentity_Usuario!,
          enterpriseCodes: [enterpriseEntity.Code!],
          enterpriseEntity: enterpriseEntity,
        ),
      ).called(1);
    });
    test('should behave correctly when session is null', () async {
      final container = makeProviderContainer(mockSession: false);

      await container.read(
        searchProductsStateControllerProvider(
          enterpriseEntity.Code!,
          bsRoutine,
        ).future,
      );

      final states = <AsyncValue<void>>[];
      container.listen(
        searchProductsStateControllerProvider(
          enterpriseEntity.Code!,
          bsRoutine,
        ),
        (_, next) => states.add(next),
      );

      await container
          .read(
            searchProductsStateControllerProvider(
              enterpriseEntity.Code!,
              bsRoutine,
            ).notifier,
          )
          .loadProducts(
            lastBuyEntranceQuantity: lastBuyEntranceQuantity,
            searchValue: searchValue,
            enterpriseCode: enterpriseEntity.Code!,
            selectedEnterprise: enterpriseEntity,
          );

      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
      verifyNever(
        () => sut.getProductsJson(
          lastBuyEntranceQuantity: lastBuyEntranceQuantity,
          baseUrl: userSessionEntity.supabaseEnterprise!.baseUrl!,
          searchValue: searchValue,
          routine: bsRoutine,
          searchType: appSettingsEntity.searchPreference.searchType,
          crossIdentity: userSessionEntity.user.CrossIdentity_Usuario!,
          enterpriseCodes: [enterpriseEntity.Code!],
          enterpriseEntity: enterpriseEntity,
        ),
      );
    });
    test('should behave correctly when enterprise id dont exists', () async {
      final container = makeProviderContainer(mockSession: true);

      await container.read(
        searchProductsStateControllerProvider(
          enterpriseEntity.Code!,
          bsRoutine,
        ).future,
      );

      final states = <AsyncValue<void>>[];
      container.listen(
        searchProductsStateControllerProvider(
          enterpriseEntity.Code!,
          bsRoutine,
        ),
        (_, next) => states.add(next),
      );

      await container
          .read(
            searchProductsStateControllerProvider(
              enterpriseEntity.Code!,
              bsRoutine,
            ).notifier,
          )
          .loadProducts(
            lastBuyEntranceQuantity: lastBuyEntranceQuantity,
            searchValue: searchValue,
            enterpriseCode: enterpriseEntity.Code! + 1000, //wrong code
            selectedEnterprise: null,
          );

      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
      verifyNever(
        () => sut.getProductsJson(
          lastBuyEntranceQuantity: lastBuyEntranceQuantity,
          baseUrl: userSessionEntity.supabaseEnterprise!.baseUrl!,
          searchValue: searchValue,
          routine: bsRoutine,
          searchType: appSettingsEntity.searchPreference.searchType,
          crossIdentity: userSessionEntity.user.CrossIdentity_Usuario!,
          enterpriseCodes: [enterpriseEntity.Code!],
          enterpriseEntity: enterpriseEntity,
        ),
      );
    });

    test('should behave correctly when appSettings is null', () async {
      final container = makeProviderContainer(mockAppSettingsState: false);

      await container.read(
        searchProductsStateControllerProvider(
          enterpriseEntity.Code!,
          bsRoutine,
        ).future,
      );

      final states = <AsyncValue<void>>[];
      container.listen(
        searchProductsStateControllerProvider(
          enterpriseEntity.Code!,
          bsRoutine,
        ),
        (_, next) => states.add(next),
      );

      await container
          .read(
            searchProductsStateControllerProvider(
              enterpriseEntity.Code!,
              bsRoutine,
            ).notifier,
          )
          .loadProducts(
            lastBuyEntranceQuantity: lastBuyEntranceQuantity,
            searchValue: searchValue,
            enterpriseCode: enterpriseEntity.Code!,
            selectedEnterprise: enterpriseEntity,
          );

      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
      verifyNever(
        () => sut.getProductsJson(
          lastBuyEntranceQuantity: lastBuyEntranceQuantity,
          baseUrl: userSessionEntity.supabaseEnterprise!.baseUrl!,
          searchValue: searchValue,
          routine: bsRoutine,
          searchType: appSettingsEntity.searchPreference.searchType,
          crossIdentity: userSessionEntity.user.CrossIdentity_Usuario!,
          enterpriseCodes: [enterpriseEntity.Code!],
          enterpriseEntity: enterpriseEntity,
        ),
      );
    });
  });

  group('updateProduct', () {
    test('should update a product in the list if it exists', () async {
      // Set up the repository mock to return the initial list
      sut.mockGetProductsJson(productsEntities);

      final container = makeProviderContainer();
      addTearDown(container.dispose);

      // Load the initial state
      await container.read(
        searchProductsStateControllerProvider(
          enterpriseEntity.Code!,
          bsRoutine,
        ).future,
      );

      //loading products
      await container
          .read(
            searchProductsStateControllerProvider(
              enterpriseEntity.Code!,
              bsRoutine,
            ).notifier,
          )
          .loadProducts(
            lastBuyEntranceQuantity: lastBuyEntranceQuantity,
            searchValue: searchValue,
            enterpriseCode: enterpriseEntity.Code!,
            selectedEnterprise: enterpriseEntity,
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
            ).notifier,
          )
          .updateProduct(updatedProduct);

      // ASSERT
      // Read the final state of the provider
      final finalState = container.read(
        searchProductsStateControllerProvider(
          enterpriseEntity.Code!,
          bsRoutine,
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

        sut.mockGetProductsJson(productsEntities);

        final container = makeProviderContainer();
        addTearDown(container.dispose);
        await container.read(
          searchProductsStateControllerProvider(
            enterpriseEntity.Code!,
            bsRoutine,
          ).future,
        );

        //loading products
        await container
            .read(
              searchProductsStateControllerProvider(
                enterpriseEntity.Code!,
                bsRoutine,
              ).notifier,
            )
            .loadProducts(
              lastBuyEntranceQuantity: lastBuyEntranceQuantity,
              searchValue: searchValue,
              enterpriseCode: enterpriseEntity.Code!,
              selectedEnterprise: enterpriseEntity,
            );

        // ACT
        container
            .read(
              searchProductsStateControllerProvider(
                enterpriseEntity.Code!,
                bsRoutine,
              ).notifier,
            )
            .updateProduct(nonExistentProduct);

        // ASSERT
        // Check that the state is still the original list and has not changed.
        final finalState = container.read(
          searchProductsStateControllerProvider(
            enterpriseEntity.Code!,
            bsRoutine,
          ),
        );
        expect(finalState.value, productsEntities);
        expect(finalState.value, hasLength(3));
        expect(finalState.value, productsEntities);
      },
    );
  });
}
