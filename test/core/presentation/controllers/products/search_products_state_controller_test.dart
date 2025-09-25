import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/core/providers/products/products.dart';
import 'package:celta_intelligence/features/auth/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/enterprises/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/settings/presentation/controllers/controllers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late SoapProductsRepositorySpy sut;

  late FakeAuthStateController fakeAuthStateController;

  late UserSessionEntity userSessionEntity;
  late String searchValue;
  late EnterpriseEntity enterpriseEntity;
  late int lastBuyEntranceQuantity;
  late AppSettingsEntity appSettingsEntity;
  late BsRoutine bsRoutine;

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
  }

  void initSut() {
    sut = SoapProductsRepositorySpy();
  }

  void initInjections() {
    fakeAuthStateController = FakeAuthStateController(userSessionEntity.user);
  }

  void mockSuccess() {
    sut.mockGetProductsJson([
      EntityFactory.makeProductEntity(),
      EntityFactory.makeProductEntity(),
      EntityFactory.makeProductEntity(),
    ]);
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
          userSessionProvider.overrideWith(
            () =>
                FakeUserSession(UserSessionModel.fromEntity(userSessionEntity)),
          ),
        if (mockAuthState == true)
          authStateControllerProvider.overrideWith(
            () => fakeAuthStateController,
          ),
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
          baseUrl: userSessionEntity.supabaseEnterprise.baseUrl!,
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
          baseUrl: userSessionEntity.supabaseEnterprise.baseUrl!,
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
          baseUrl: userSessionEntity.supabaseEnterprise.baseUrl!,
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
          baseUrl: userSessionEntity.supabaseEnterprise.baseUrl!,
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
}
