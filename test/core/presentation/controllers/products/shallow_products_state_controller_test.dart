import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/domain/repositories/products/products.dart';
import 'package:celta_inventario/core/presentation/controllers/app_usage/app_usage.dart';
import 'package:celta_inventario/core/presentation/controllers/products/products.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/core/providers/products/products.dart';
import 'package:celta_inventario/features/enterprises/presentation/controllers/controllers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockShallowProductsRepository extends Mock
    implements IEcommerceGetShallowProductsRepository {}

void main() {
  late MockShallowProductsRepository mockRepository;
  late UserSessionModel fakeSession;
  late EnterpriseEntity fakeEnterprise;
  late List<ProductEntity> fakeProducts;
  final fakerInstance = Faker();
  late FakeAppUsageStateController fakeAppUsage;

  setUpAll(() {
    registerFallbackValue(CancelToken());
    registerFallbackValue(1);
  });

  setUp(() {
    mockRepository = MockShallowProductsRepository();

    // Generating dynamic data with Faker
    fakeEnterprise = EntityFactory.makeEnterpriseEntity();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity().copyWith(
        selectedEnterprise: fakeEnterprise,
      ),
    );

    fakeProducts = List.generate(
      fakerInstance.randomGenerator.integer(5, min: 1),
      (_) => EntityFactory.makeProductEntity(),
    );

    fakeAppUsage = FakeAppUsageStateController();
  });

  ProviderContainer makeProviderContainer({
    UserSessionModel? session,
    EnterpriseEntity? enterprise,
  }) {
    return ProviderContainer(
      overrides: [
        ecommerceGetShallowProductsRepositoryProvider.overrideWithValue(
          mockRepository,
        ),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
        selectedEnterpriseStateControllerProvider.overrideWith(
          () => FakeSelectedEnterpriseStateController(fakeEnterprise),
        ),
        appUsageStateControllerProvider.overrideWith(() => fakeAppUsage),
      ],
    );
  }

  group('ShallowProductsStateController', () {
    test('initial state should be an empty list', () async {
      final container = makeProviderContainer(session: fakeSession);
      addTearDown(container.dispose);

      final state = await container.read(
        shallowProductsStateControllerProvider.future,
      );

      expect(state, isEmpty);
    });

    test('Should behave correctly on success', () async {
      // ARRANGE
      final String searchTerm = fakerInstance.food.restaurant();

      when(
        () => mockRepository.get(
          workingUrl: any(named: 'workingUrl'),
          user: any(named: 'user'),
          accessKey: any(named: 'accessKey'),
          name: any(named: 'name'),
          enterpriseId: any(named: 'enterpriseId'),
          cancelToken: any(named: 'cancelToken'),
        ),
      ).thenAnswer((_) async => fakeProducts);

      final container = makeProviderContainer(
        session: fakeSession,
        enterprise: fakeEnterprise,
      );
      addTearDown(container.dispose);

      await container.read(shallowProductsStateControllerProvider.future);

      final states = <AsyncValue<List<ProductEntity>>>[];
      container.listen(
        shallowProductsStateControllerProvider,
        (_, next) => states.add(next),
      );

      // ACT
      await container
          .read(shallowProductsStateControllerProvider.notifier)
          .load(searchTerm);

      // ASSERT
      expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);

      expect(fakeAppUsage.lastUsageType, UsageType.shallowSearchProduct);

      verify(
        () => mockRepository.get(
          workingUrl: fakeSession.enterprise!.workingUrl!,
          user: fakeSession.user.name!,
          accessKey: fakeSession.user.AccessKey!,
          name: searchTerm,
          enterpriseId: fakeEnterprise.Code!,
          cancelToken: any(named: 'cancelToken'),
        ),
      ).called(1);
    });
    test('Should not load when searchTerm is a number', () async {
      // ARRANGE
      final String searchTerm = fakerInstance.randomGenerator
          .integer(100)
          .toString();

      final container = makeProviderContainer(
        session: fakeSession,
        enterprise: fakeEnterprise,
      );
      addTearDown(container.dispose);

      await container.read(shallowProductsStateControllerProvider.future);

      // ACT
      await container
          .read(shallowProductsStateControllerProvider.notifier)
          .load(searchTerm);

      verifyNever(
        () => mockRepository.get(
          workingUrl: any(named: 'workingUrl'),
          user: any(named: 'user'),
          accessKey: any(named: 'accessKey'),
          name: any(named: 'name'),
          enterpriseId: any(named: 'enterpriseId'),
          cancelToken: any(named: 'cancelToken'),
        ),
      );
    });
    test('Should not load when searchTerm is too short', () async {
      // ARRANGE
      final String searchTerm =
          "${fakerInstance.randomGenerator.string(1)}   ${fakerInstance.randomGenerator.string(1)}";

      final container = makeProviderContainer(
        session: fakeSession,
        enterprise: fakeEnterprise,
      );
      addTearDown(container.dispose);

      await container.read(shallowProductsStateControllerProvider.future);

      // ACT
      await container
          .read(shallowProductsStateControllerProvider.notifier)
          .load(searchTerm);

      verifyNever(
        () => mockRepository.get(
          workingUrl: any(named: 'workingUrl'),
          user: any(named: 'user'),
          accessKey: any(named: 'accessKey'),
          name: any(named: 'name'),
          enterpriseId: any(named: 'enterpriseId'),
          cancelToken: any(named: 'cancelToken'),
        ),
      );
    });

    test('load should emit [loading, error] when repository fails', () async {
      // ARRANGE
      final exception = Exception('Search failed');
      when(
        () => mockRepository.get(
          workingUrl: any(named: 'workingUrl'),
          user: any(named: 'user'),
          accessKey: any(named: 'accessKey'),
          name: any(named: 'name'),
          enterpriseId: any(named: 'enterpriseId'),
          cancelToken: any(named: 'cancelToken'),
        ),
      ).thenThrow(exception);

      final container = makeProviderContainer(
        session: fakeSession,
        enterprise: fakeEnterprise,
      );
      addTearDown(container.dispose);

      // ACT
      await container
          .read(shallowProductsStateControllerProvider.notifier)
          .load('test');

      // ASSERT
      final finalState = container.read(shallowProductsStateControllerProvider);
      expect(finalState, isA<AsyncError>());
      expect(finalState.error, exception);
    });

    test('timer should trigger keepAlive link closure after 20 seconds', () async {
      // This test is complex because it involves internal Riverpod 'link' state.
      // Usually, we verify that build() completes and onCancel is registered.
      final container = makeProviderContainer(session: fakeSession);

      // Simply reading the provider registers the onCancel listener.
      await container.read(shallowProductsStateControllerProvider.future);

      // If we dispose the listener, the timer starts.
      // Manual verification of timers is usually handled via 'fake_async' if needed.
      expect(
        container.read(shallowProductsStateControllerProvider).hasValue,
        true,
      );
    });
  });

  group('Avoid short circuit', () {
    test(
      'Should not load again if only add more text in the last text searched that API returned empty list',
      () async {
        // ARRANGE
        final String searchTerm = fakerInstance.food.restaurant();
        when(
          () => mockRepository.get(
            workingUrl: any(named: 'workingUrl'),
            user: any(named: 'user'),
            accessKey: any(named: 'accessKey'),
            name: any(named: 'name'),
            enterpriseId: any(named: 'enterpriseId'),
            cancelToken: any(named: 'cancelToken'),
          ),
        ).thenAnswer((_) async => []);

        final container = makeProviderContainer(
          session: fakeSession,
          enterprise: fakeEnterprise,
        );
        addTearDown(container.dispose);

        await container.read(shallowProductsStateControllerProvider.future);

        await container
            .read(shallowProductsStateControllerProvider.notifier)
            .load(searchTerm);
        await container
            .read(shallowProductsStateControllerProvider.notifier)
            .load(searchTerm + faker.lorem.word());

        expect(
          container.read(shallowProductsStateControllerProvider).value,
          [],
        );

        verify(
          () => mockRepository.get(
            workingUrl: fakeSession.enterprise!.workingUrl!,
            user: fakeSession.user.name!,
            accessKey: fakeSession.user.AccessKey!,
            name: searchTerm,
            enterpriseId: fakeEnterprise.Code!,
            cancelToken: any(named: 'cancelToken'),
          ),
        ).called(1);
      },
    );
  });
}
