import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/domain/repositories/app_usage/app_usage.dart';
import 'package:celta_inventario/core/presentation/controllers/app_usage/app_usage.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/core/providers/app_usage/app_usage.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

// --- Mocks ---

class MockAppUsageRepository extends Mock implements IAppUsageRepository {}

void main() {
  late MockAppUsageRepository mockRepository;
  final fakerInstance = Faker();

  late UserSessionModel userSession;
  late UsageType usageType;

  setUp(() {
    userSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    usageType = UsageType
        .values[fakerInstance.randomGenerator.integer(UsageType.values.length)];
    mockRepository = MockAppUsageRepository();
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeAppUsageEntity());
    for (var type in UsageType.values) {
      registerFallbackValue(type);
    }
  });

  ProviderContainer makeProviderContainer({UserSessionModel? userMock}) {
    return ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        appUsageRepositoryProvider.overrideWithValue(mockRepository),
        userSessionProvider.overrideWith(
          () => FakeUserSession(userMock ?? userSession),
        ),
      ],
    );
  }

  group('AppUsageStateController', () {
    test('initial state should be AsyncData(null)', () async {
      // PERFORMANCE: build() returns null immediately, so state should
      // be available without extra microtasks.
      final container = makeProviderContainer();
      addTearDown(container.dispose);

      final state = await container.read(
        appUsageStateControllerProvider.future,
      );
      expect(state, null);
    });

    group('loadRemoteUsageReport', () {
      test('should emit [loading, data] and return list on success', () async {
        final start = fakerInstance.date.dateTime();
        final fakeList = List.generate(
          3,
          (_) => EntityFactory.makeGroupedUsageEntity(),
        );

        when(
          () => mockRepository.loadGroupedUsageReport(
            enterpriseId: any(named: 'enterpriseId'),
            start: any(named: 'start'),
            end: any(named: 'end'),
          ),
        ).thenAnswer((_) async => fakeList);

        final container = makeProviderContainer();
        addTearDown(container.dispose);

        await container.read(appUsageStateControllerProvider.future);
        final notifier = container.read(
          appUsageStateControllerProvider.notifier,
        );

        // PERFORMANCE: Using a listener to verify the loading state transition.
        final states = <AsyncValue<List<GroupedUsageEntity>?>>[];
        container.listen(
          appUsageStateControllerProvider,
          (previous, next) => states.add(next),
        );

        await notifier.loadRemoteUsageReport(start);

        expect(states, [
          isA<AsyncLoading>(),
          AsyncData<List<GroupedUsageEntity>?>(fakeList),
        ]);

        verify(
          () => mockRepository.loadGroupedUsageReport(
            enterpriseId: null,
            start: start,
            end: start,
          ),
        ).called(1);
      });

      test('should emit [loading, error] when repository fails', () async {
        final exception = Exception('Remote failure');

        when(
          () => mockRepository.loadGroupedUsageReport(
            enterpriseId: any(named: 'enterpriseId'),
            start: any(named: 'start'),
            end: any(named: 'end'),
          ),
        ).thenThrow(exception);

        final container = makeProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(
          appUsageStateControllerProvider.notifier,
        );

        await notifier.loadRemoteUsageReport(DateTime.now());

        final state = container.read(appUsageStateControllerProvider);

        expect(state, isA<AsyncError>());
        expect(state.error, exception);
      });
    });

    group('addUsage', () {
      test('should call repository.addUsage', () async {
        when(() => mockRepository.addUsage(any())).thenAnswer((_) async {});

        final container = makeProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(
          appUsageStateControllerProvider.notifier,
        );

        await notifier.addUsage(usageType);

        verify(
          () => mockRepository.addUsage(
            AppUsageEntity(
              userName: userSession.user.name!,
              enterpriseId: userSession.enterprise?.id,
              usageType: usageType,
              requestCount: 1,
            ),
          ),
        ).called(1);

        // State remains as it was (null or existing data)
        expect(container.read(appUsageStateControllerProvider).hasValue, true);
      });

      test(
        'should NOT call repository.addUsage if user name or enterpriseId is null',
        () async {
          when(() => mockRepository.addUsage(any())).thenAnswer((_) async {});
          bool annulName = fakerInstance.randomGenerator.boolean();
          final mockUserSession = UserSessionEntity(
            user: EntityFactory.makeUserEntity(annullName: annulName),
            supabaseEnterprise: EntityFactory.makeEnterpriseEntity(
              annulEnterpriseId: !annulName,
            ),
          );

          final container = makeProviderContainer(
            userMock: UserSessionModel.fromEntity(mockUserSession),
          );
          addTearDown(container.dispose);

          final notifier = container.read(
            appUsageStateControllerProvider.notifier,
          );

          await notifier.addUsage(usageType);

          verifyNever(() => mockRepository.addUsage(any()));

          // State remains as it was (null or existing data)
        },
      );

      test('should catch and log error if repository.addUsage fails', () async {
        // Fire-and-forget logic should not crash the state
        when(
          () => mockRepository.addUsage(any()),
        ).thenThrow(Exception('local save fail'));

        final container = makeProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(
          appUsageStateControllerProvider.notifier,
        );

        // Verify that the call doesn't throw out of the method
        await expectLater(notifier.addUsage(usageType), completes);

        verify(
          () => mockRepository.addUsage(
            AppUsageEntity(
              userName: userSession.user.name!,
              enterpriseId: userSession.enterprise?.id,
              usageType: usageType,
              requestCount: 1,
            ),
          ),
        ).called(1);
      });
    });
  });
}
