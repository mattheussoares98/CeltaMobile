import 'package:celta_intelligence/core/data/datasource/datasource.dart';
import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/providers/providers.dart';
import 'package:celta_intelligence/features/adjust_sale_price/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/auth/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/enterprises/presentation/controllers/controllers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late SoapProductsRepositorySpy sut;

  late FakeAuthStateController fakeAuthStateController;

  late UserSessionModel userSession;
  late String searchValue;
  late UserEntity userEntity;
  late EnterpriseEntity enterpriseEntity;

  setUpAll(() {
    for (var routine in Routine.values) {
      registerFallbackValue(routine);
    }
    for (var searchType in SearchType.values) {
      registerFallbackValue(searchType);
    }
    registerFallbackValue(EntityFactory.makeEnterpriseEntity());
  });

  void initEntities() {
    userSession = UserSessionModel(baseUrl: faker.internet.httpUrl());
    searchValue = faker.lorem.word();
    userEntity = UserEntity(
      name: faker.person.name(),
      enterpriseName: faker.company.name(),
      AccessKey: faker.guid.guid(),
      CrossIdentity_Usuario: faker.guid.guid(),
    );
    enterpriseEntity = EntityFactory.makeEnterpriseEntity();
  }

  void initSut() {
    sut = SoapProductsRepositorySpy();
  }

  void initInjections() {
    fakeAuthStateController = FakeAuthStateController(userEntity);
    userSession = UserSessionModel(baseUrl: faker.internet.httpUrl());
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

  ProviderContainer makeProviderContainer({
    bool? mockSession = true,
    bool? mockAuthState = true,
  }) {
    final container = ProviderContainer(
      overrides: [
        soapProductsRepositoryProvider.overrideWithValue(sut),
        if (mockSession == true)
          userSessionProvider.overrideWith(() => FakeUserSession(userSession)),
        if (mockAuthState == true)
          authStateControllerProvider.overrideWith(
            () => fakeAuthStateController,
          ),
        enterprisesStateControllerProvider.overrideWith(
          () => FakeEnterprisesStateController([enterpriseEntity]),
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('Load products', () {
    test('should behave correctly on success', () async {
      final container = makeProviderContainer();

      await container.read(productsStateControllerProvider.future);

      final states = <AsyncValue<void>>[];
      container.listen(
        productsStateControllerProvider,
        (_, next) => states.add(next),
      );

      await container
          .read(productsStateControllerProvider.notifier)
          .loadProducts(
            searchValue: searchValue,
            enterpriseCode: enterpriseEntity.Code!,
          );

      expect(states, [
        isA<AsyncLoading>(),
        isA<AsyncData<List<ProductEntity>>>(),
      ]);
      verify(
        () => sut.getProductsJson(
          baseUrl: userSession.baseUrl!,
          searchValue: searchValue,
          routine: Routine.adjustSalePrice,
          searchType: SearchType.dynamic,
          crossIdentity: userEntity.CrossIdentity_Usuario!,
          enterpriseCodes: [enterpriseEntity.Code!],
          enterpriseEntity: enterpriseEntity,
        ),
      ).called(1);
    });
    test('should behave correctly on error', () async {
      final container = makeProviderContainer(mockSession: false);

      await container.read(productsStateControllerProvider.future);

      final states = <AsyncValue<void>>[];
      container.listen(
        productsStateControllerProvider,
        (_, next) => states.add(next),
      );

      await container
          .read(productsStateControllerProvider.notifier)
          .loadProducts(
            searchValue: searchValue,
            enterpriseCode: enterpriseEntity.Code!,
          );

      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
      verifyNever(
        () => sut.getProductsJson(
          baseUrl: userSession.baseUrl!,
          searchValue: searchValue,
          routine: Routine.adjustSalePrice,
          searchType: SearchType.dynamic,
          crossIdentity: userEntity.CrossIdentity_Usuario!,
          enterpriseCodes: [enterpriseEntity.Code!],
          enterpriseEntity: enterpriseEntity,
        ),
      );
    });
  });
}
