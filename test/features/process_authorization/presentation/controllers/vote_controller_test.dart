// test/features/process_authorization/presentation/controllers/statistics_state_controller_test.dart
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/app_usage/app_usage.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/process_authorization/domain/repositories/repositories.dart';
import 'package:celta_inventario/features/process_authorization/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/process_authorization/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockEcProcessAuthorizationRepository extends Mock
    implements IEcProcessAuthorizationRepository {}

void main() {
  late MockEcProcessAuthorizationRepository mockRepository;
  late FakeAppUsageStateController fakeAppUsage;
  late UserSessionModel fakeSession;
  late int processCode;
  late bool authorized;
  late String? observations;

  setUp(() {
    mockRepository = MockEcProcessAuthorizationRepository();
    fakeAppUsage = FakeAppUsageStateController();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    registerFallbackValue(
      const EcRequestParams(workingUrl: '', user: '', accessKey: ''),
    );
    processCode = faker.randomGenerator.integer(100000);
    authorized = faker.randomGenerator.boolean();
    observations = faker.randomGenerator.boolean()
        ? faker.lorem.sentence()
        : null;
  });

  ProviderContainer makeProviderContainer({UserSessionModel? session}) {
    return ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        ecProcessAuthorizationRepositoryProvider.overrideWithValue(
          mockRepository,
        ),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
        appUsageStateControllerProvider.overrideWith(() => fakeAppUsage),
      ],
    );
  }

  group('VoteController', () {
    test(
      'should behave correctly on success, invalidate judgmentsStateControllerProvider and update app usage statistics',
      () async {
        // ARRANGE
        when(
          () => mockRepository.vote(
            any(),
            processCode: any(named: 'processCode'),
            authorized: any(named: 'authorized'),
            observations: any(named: 'observations'),
          ),
        ).thenAnswer((_) async {});
        when(
          () => mockRepository.getJudgments(any()),
        ).thenAnswer((_) async => []);

        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        final states = <AsyncValue<void>>[];
        container.listen(
          voteControllerProvider(processCode),
          (_, next) => states.add(next),
        );

        int judgmentsBuildCount = 0;
        container.listen(judgmentsStateControllerProvider, (previous, next) {
          if (next is AsyncData && !next.isLoading) {
            judgmentsBuildCount++;
          }
        }, fireImmediately: true);

        // Warm up the provider
        await container.read(judgmentsStateControllerProvider.future);
        expect(judgmentsBuildCount, 1);

        // ACT
        await container
            .read(voteControllerProvider(processCode).notifier)
            .vote(authorized, observations);

        // ASSERT
        expect(states, [isA<AsyncLoading<void>>(), isA<AsyncData<void>>()]);
        verify(
          () => mockRepository.vote(
            EcRequestParams(
              workingUrl: fakeSession.enterprise!.workingUrl!,
              user: fakeSession.user.name!,
              accessKey: fakeSession.user.AccessKey!,
            ),
            processCode: processCode,
            authorized: authorized,
            observations: observations,
          ),
        ).called(1);

        // After invalidation and reading, the provider rebuilt and emitted a new AsyncData.
        await container.read(judgmentsStateControllerProvider.future);
        expect(judgmentsBuildCount, 2);
        expect(fakeAppUsage.lastUsageType, UsageType.processAuthorizationVote);
      },
    );

    test('should throw AppException when session is invalid', () async {
      // ARRANGE
      final container = makeProviderContainer(session: null);
      addTearDown(container.dispose);

      final states = <AsyncValue<void>>[];
      container.listen(
        voteControllerProvider(processCode),
        (_, next) => states.add(next),
      );

      // ACT & ASSERT
      await container
          .read(voteControllerProvider(processCode).notifier)
          .vote(authorized, observations);

      // ACT & ASSERT
      expect(states, [isA<AsyncLoading<void>>(), isA<AsyncError<void>>()]);
      expect(
        container.read(voteControllerProvider(processCode)),
        isA<AsyncError<void>>(),
      );

      verifyNever(
        () => mockRepository.vote(
          any(),
          processCode: any(named: 'processCode'),
          authorized: any(named: 'authorized'),
          observations: any(named: 'observations'),
        ),
      );
    });

    test(
      'should propagate errors when repository fails and NOT invalidate judgmentsStateControllerProvider',
      () async {
        // ARRANGE
        final exception = Exception('Repository error');
        when(
          () => mockRepository.vote(
            any(),
            processCode: any(named: 'processCode'),
            authorized: any(named: 'authorized'),
            observations: any(named: 'observations'),
          ),
        ).thenThrow(exception);
        when(
          () => mockRepository.getJudgments(any()),
        ).thenAnswer((_) async => []);

        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        final states = <AsyncValue<void>>[];
        container.listen(
          voteControllerProvider(processCode),
          (_, next) => states.add(next),
        );

        int judgmentsBuildCount = 0;
        container.listen(judgmentsStateControllerProvider, (previous, next) {
          if (next is AsyncData && !next.isLoading) {
            judgmentsBuildCount++;
          }
        }, fireImmediately: true);

        // Warm up the provider
        await container.read(judgmentsStateControllerProvider.future);
        expect(judgmentsBuildCount, 1);

        await container
            .read(voteControllerProvider(processCode).notifier)
            .vote(authorized, observations);

        // ACT & ASSERT
        expect(states, [isA<AsyncLoading<void>>(), isA<AsyncError<void>>()]);
        expect(
          container.read(voteControllerProvider(processCode)),
          isA<AsyncError<void>>(),
        );

        // It shouldn't have rebuilt (still count = 1)
        await container.read(judgmentsStateControllerProvider.future);
        expect(judgmentsBuildCount, 1);
      },
    );
  });
}
