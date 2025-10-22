import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_intelligence/features/enterprises/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/inventory/domain/entities/entities.dart';
import 'package:celta_intelligence/features/inventory/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/inventory/providers.dart';
import 'package:celta_intelligence/features/settings/presentation/controllers/controllers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late SoapInventoryProductsRepositorySpy mockRepository;

  late FakeUserSession fakeUserSession;

  late UserSessionEntity userSessionEntity;
  late String searchValue;
  late AppSettingsEntity appSettingsEntity;
  late List<InventoryProductEntity> productsEntities;
  late int enterpriseCode;
  late int codigoInternoInventario;
  late SearchType searchType;
  late int codigoInternoInvCont;
  late EnterpriseEntity selectedEnterprise;

  setUpAll(() {
    for (var searchType in SearchType.values) {
      registerFallbackValue(searchType);
    }
    registerFallbackValue(EntityFactory.makeEnterpriseEntity());
  });

  void initEntities() {
    userSessionEntity = EntityFactory.makeUserSessionEntity();
    searchValue = faker.lorem.word();
    appSettingsEntity = EntityFactory.makeAppSettingsEntity();
    productsEntities = [
      EntityFactory.makeInventoryProductEntity(),
      EntityFactory.makeInventoryProductEntity(),
      EntityFactory.makeInventoryProductEntity(),
    ];

    enterpriseCode = faker.randomGenerator.integer(100);
    codigoInternoInventario = faker.randomGenerator.integer(100);
    searchType = SearchType
        .values[faker.randomGenerator.integer(SearchType.values.length)];
    codigoInternoInvCont = faker.randomGenerator.integer(100);
    selectedEnterprise = EntityFactory.makeEnterpriseEntity();
  }

  void initSut() {
    mockRepository = SoapInventoryProductsRepositorySpy();
  }

  void initInjections() {
    fakeUserSession = FakeUserSession(
      UserSessionModel.fromEntity(userSessionEntity),
    );
  }

  void mockSuccess() {
    mockRepository.mockGetProducts(productsEntities);
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
        soapInventoryProductsRepositoryProvider.overrideWithValue(
          mockRepository,
        ),
        if (mockSession == true)
          validatedUserSessionProvider.overrideWith(
            () => FakeValidatedUserSession(
              UserSessionModel.fromEntity(userSessionEntity),
            ),
          ),
        if (mockAuthState == true)
          userSessionProvider.overrideWith(() => fakeUserSession),
        enterprisesStateControllerProvider(
          selectedEnterprise.Code,
        ).overrideWith(
          () => FakeEnterprisesStateController([selectedEnterprise]),
        ),
        if (mockAppSettingsState == true)
          appSettingsStateControllerProvider.overrideWith(
            () => FakeAppSettingsStateController(appSettingsEntity),
          ),
        selectedEnterpriseStateControllerProvider.overrideWith(
          () => FakeSelectedEnterpriseStateController(selectedEnterprise),
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('Load products', () {
    test('should behave correctly on success', () async {
      final container = makeProviderContainer();
      addTearDown(container.dispose);

      await container.read(
        inventoryProductsStateControllerProvider(
          enterpriseCode,
          codigoInternoInventario,
          codigoInternoInvCont,
        ).future,
      );

      final states = <AsyncValue<void>>[];
      container.listen(
        inventoryProductsStateControllerProvider(
          enterpriseCode,
          codigoInternoInventario,
          codigoInternoInvCont,
        ),
        (_, next) => states.add(next),
      );

      await container
          .read(
            inventoryProductsStateControllerProvider(
              enterpriseCode,
              codigoInternoInventario,
              codigoInternoInvCont,
            ).notifier,
          )
          .loadProducts(searchValue);

      expect(states, [
        isA<AsyncLoading>(),
        isA<AsyncData<List<InventoryProductEntity>>>(),
      ]);
      verify(
        () => mockRepository.load(
          baseUrl: fakeUserSession.sessionToReturn!.enterprise!.baseUrl!,
          crossIdentity:
              fakeUserSession.sessionToReturn!.user.CrossIdentity_Usuario!,
          enterpriseCode: enterpriseCode,
          searchValue: searchValue,
          codigoInternoInventario: codigoInternoInventario,
          searchType: appSettingsEntity.searchPreference.searchType,
          codigoInternoInvCont: codigoInternoInvCont,
          selectedEnterprise: selectedEnterprise,
        ),
      ).called(1);
    });
    test('should behave correctly when session is null', () async {
      final container = makeProviderContainer(mockSession: false);
      addTearDown(container.dispose);

      await container.read(
        inventoryProductsStateControllerProvider(
          enterpriseCode,
          codigoInternoInventario,
          codigoInternoInvCont,
        ).future,
      );

      final states = <AsyncValue<void>>[];
      container.listen(
        inventoryProductsStateControllerProvider(
          enterpriseCode,
          codigoInternoInventario,
          codigoInternoInvCont,
        ),
        (_, next) => states.add(next),
      );

      await container
          .read(
            inventoryProductsStateControllerProvider(
              enterpriseCode,
              codigoInternoInventario,
              codigoInternoInvCont,
            ).notifier,
          )
          .loadProducts(searchValue);

      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
      verifyNever(
        () => mockRepository.load(
          baseUrl: userSessionEntity.selectedEnterprise!.baseUrl!,
          crossIdentity: userSessionEntity.user.CrossIdentity_Usuario!,
          enterpriseCode: enterpriseCode,
          searchValue: searchValue,
          codigoInternoInventario: codigoInternoInventario,
          searchType: searchType,
          codigoInternoInvCont: codigoInternoInvCont,
          selectedEnterprise: selectedEnterprise,
        ),
      );
    });

    test('should behave correctly when appSettings is null', () async {
      final container = makeProviderContainer(mockAppSettingsState: false);
      addTearDown(container.dispose);

      await container.read(
        inventoryProductsStateControllerProvider(
          enterpriseCode,
          codigoInternoInventario,
          codigoInternoInvCont,
        ).future,
      );

      final states = <AsyncValue<void>>[];
      container.listen(
        inventoryProductsStateControllerProvider(
          enterpriseCode,
          codigoInternoInventario,
          codigoInternoInvCont,
        ),
        (_, next) => states.add(next),
      );

      await container
          .read(
            inventoryProductsStateControllerProvider(
              enterpriseCode,
              codigoInternoInventario,
              codigoInternoInvCont,
            ).notifier,
          )
          .loadProducts(searchValue);

      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
      verifyNever(
        () => mockRepository.load(
          baseUrl: userSessionEntity.selectedEnterprise!.baseUrl!,
          crossIdentity: userSessionEntity.user.CrossIdentity_Usuario!,
          enterpriseCode: enterpriseCode,
          searchValue: searchValue,
          codigoInternoInventario: codigoInternoInventario,
          searchType: searchType,
          codigoInternoInvCont: codigoInternoInvCont,
          selectedEnterprise: selectedEnterprise,
        ),
      );
    });
  });

  group('updateProduct', () {
    test('should update a product in the list if it exists', () async {
      // Set up the repository mock to return the initial list
      mockRepository.mockGetProducts(productsEntities);

      final container = makeProviderContainer();
      addTearDown(container.dispose);

      // Load the initial state
      await container.read(
        inventoryProductsStateControllerProvider(
          enterpriseCode,
          codigoInternoInventario,
          codigoInternoInvCont,
        ).future,
      );

      //loading products
      await container
          .read(
            inventoryProductsStateControllerProvider(
              enterpriseCode,
              codigoInternoInventario,
              codigoInternoInvCont,
            ).notifier,
          )
          .loadProducts(searchValue);

      // Create the updated version of the first product
      final updatedProduct = EntityFactory.makeInventoryProductEntity(
        plu: productsEntities.first.plu,
      );
      // ACT: Call the updateProduct method
      container
          .read(
            inventoryProductsStateControllerProvider(
              enterpriseCode,
              codigoInternoInventario,
              codigoInternoInvCont,
            ).notifier,
          )
          .updateProduct(updatedProduct);

      // ASSERT
      // Read the final state of the provider
      final finalState = container.read(
        inventoryProductsStateControllerProvider(
          enterpriseCode,
          codigoInternoInventario,
          codigoInternoInvCont,
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
        final nonExistentProduct = EntityFactory.makeInventoryProductEntity();

        mockRepository.mockGetProducts(productsEntities);

        final container = makeProviderContainer();
        addTearDown(container.dispose);
        await container.read(
          inventoryProductsStateControllerProvider(
            enterpriseCode,
            codigoInternoInventario,
            codigoInternoInvCont,
          ).future,
        );

        //loading products
        await container
            .read(
              inventoryProductsStateControllerProvider(
                enterpriseCode,
                codigoInternoInventario,
                codigoInternoInvCont,
              ).notifier,
            )
            .loadProducts(searchValue);

        // ACT
        container
            .read(
              inventoryProductsStateControllerProvider(
                enterpriseCode,
                codigoInternoInventario,
                codigoInternoInvCont,
              ).notifier,
            )
            .updateProduct(nonExistentProduct);

        // ASSERT
        // Check that the state is still the original list and has not changed.
        final finalState = container.read(
          inventoryProductsStateControllerProvider(
            enterpriseCode,
            codigoInternoInventario,
            codigoInternoInvCont,
          ),
        );
        expect(finalState.value, productsEntities);
        expect(finalState.value, hasLength(3));
        expect(finalState.value, productsEntities);
      },
    );
  });
}
