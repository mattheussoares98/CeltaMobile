// test/features/process_authorization/presentation/controllers/statistics_state_controller_test.dart
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/infraestructure/infrastructure.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/core/providers/services/services.dart';
import 'package:celta_inventario/exceptions/app_exception.dart';
import 'package:celta_inventario/features/process_authorization/domain/repositories/repositories.dart';
import 'package:celta_inventario/features/process_authorization/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/process_authorization/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockEcProcessAuthorizationRepository extends Mock
    implements IEcProcessAuthorizationRepository {}

class MockNotificationsService extends Mock implements INotificationsService {}

void main() {
  late MockEcProcessAuthorizationRepository mockRepository;
  late MockNotificationsService mockNotificationsService;
  late UserSessionModel fakeSession;

  setUp(() {
    alreadyLoaded = false;
    mockRepository = MockEcProcessAuthorizationRepository();
    mockNotificationsService = MockNotificationsService();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    registerFallbackValue(
      const EcRequestParams(workingUrl: '', user: '', accessKey: ''),
    );

    when(
      () => mockNotificationsService.showNotification(
        title: any(named: 'title'),
        body: any(named: 'body'),
        payload: any(named: 'payload'),
        id: any(named: 'id'),
      ),
    ).thenAnswer((_) async {});
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
        notificationsServiceProvider.overrideWithValue(
          mockNotificationsService,
        ),
      ],
    );
  }

  group('StatisticsStateController', () {
    test(
      'should return statistics on success and show notification when openedJudgements > 0',
      () async {
        // ARRANGE
        final statsWithJudgements =
            EntityFactory.makeBsfProcessAuthorizationStatisticEntity().copyWith(
              openedJudgements: 5,
            );
        when(
          () => mockRepository.getStatistics(any()),
        ).thenAnswer((_) async => statsWithJudgements);

        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        // ACT
        final result = await container.read(
          statisticsStateControllerProvider.future,
        );

        // ASSERT
        expect(result, statsWithJudgements);
        verify(
          () => mockRepository.getStatistics(
            EcRequestParams(
              workingUrl: fakeSession.enterprise!.workingUrl!,
              user: fakeSession.user.name!,
              accessKey: fakeSession.user.AccessKey!,
            ),
          ),
        ).called(1);
        verify(
          () => mockNotificationsService.showNotification(
            title: any(named: 'title'),
            body: any(named: 'body'),
          ),
        ).called(1);
      },
    );

    test('should not show notification when openedJudgements is 0', () async {
      // ARRANGE
      final statsWithZeroJudgements =
          EntityFactory.makeBsfProcessAuthorizationStatisticEntity().copyWith(
            openedJudgements: 0,
          );
      when(
        () => mockRepository.getStatistics(any()),
      ).thenAnswer((_) async => statsWithZeroJudgements);

      final container = makeProviderContainer(session: fakeSession);
      addTearDown(container.dispose);

      // ACT
      final result = await container.read(
        statisticsStateControllerProvider.future,
      );

      // ASSERT
      expect(result, statsWithZeroJudgements);
      verify(
        () => mockRepository.getStatistics(
          EcRequestParams(
            workingUrl: fakeSession.enterprise!.workingUrl!,
            user: fakeSession.user.name!,
            accessKey: fakeSession.user.AccessKey!,
          ),
        ),
      ).called(1);
      verifyNever(
        () => mockNotificationsService.showNotification(
          title: any(named: 'title'),
          body: any(named: 'body'),
        ),
      );
    });

    test(
      'should show notification only once even when provider is rebuilt/read multiple times',
      () async {
        // ARRANGE
        final statsWithJudgements =
            EntityFactory.makeBsfProcessAuthorizationStatisticEntity().copyWith(
              openedJudgements: 5,
            );
        when(
          () => mockRepository.getStatistics(any()),
        ).thenAnswer((_) async => statsWithJudgements);

        final container1 = makeProviderContainer(session: fakeSession);
        addTearDown(container1.dispose);

        // ACT - First read (should trigger notification)
        await container1.read(statisticsStateControllerProvider.future);

        // ASSERT - Called once
        verify(
          () => mockNotificationsService.showNotification(
            title: any(named: 'title'),
            body: any(named: 'body'),
          ),
        ).called(1);

        // ACT - Create a new container (simulate rebuild) and read again
        final container2 = makeProviderContainer(session: fakeSession);
        addTearDown(container2.dispose);
        await container2.read(statisticsStateControllerProvider.future);

        // ASSERT - No more interactions with the notification service (alreadyLoaded prevented the second call)
        verifyNoMoreInteractions(mockNotificationsService);
      },
    );

    test('should throw AppException when session is invalid', () async {
      // ARRANGE
      final container = makeProviderContainer(session: null);
      addTearDown(container.dispose);

      // ACT & ASSERT
      await expectLater(
        container.read(statisticsStateControllerProvider.future),
        throwsA(isA<AppException>()),
      );

      verifyNever(() => mockRepository.getStatistics(any()));
    });

    test('should propagate errors when repository fails', () async {
      // ARRANGE
      final exception = Exception('Repository error');
      when(() => mockRepository.getStatistics(any())).thenThrow(exception);

      final container = makeProviderContainer(session: fakeSession);
      addTearDown(container.dispose);

      // ACT & ASSERT
      await expectLater(
        container.read(statisticsStateControllerProvider.future),
        throwsA(equals(exception)),
      );
    });
  });
}
