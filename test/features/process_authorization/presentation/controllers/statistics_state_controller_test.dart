// test/features/process_authorization/presentation/controllers/statistics_state_controller_test.dart
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/resource/resource.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
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

class FakeCanAccessResourceStateController
    extends CanAccessResourceStateController {
  final bool hasAccess;
  FakeCanAccessResourceStateController(this.hasAccess);

  @override
  Future<bool> build(BsRoutine routine, BsResource resource) async {
    return hasAccess;
  }
}

void main() {
  late MockEcProcessAuthorizationRepository mockRepository;
  late UserSessionModel fakeSession;

  setUp(() {
    mockRepository = MockEcProcessAuthorizationRepository();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    registerFallbackValue(
      const EcRequestParams(workingUrl: '', user: '', accessKey: ''),
    );
  });

  ProviderContainer makeProviderContainer({
    UserSessionModel? session,
    bool hasAccess = true,
  }) {
    return ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        ecProcessAuthorizationRepositoryProvider.overrideWithValue(
          mockRepository,
        ),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
        canAccessResourceStateControllerProvider(
          BsRoutine.generic,
          BsResource.processAuthorizationRules,
        ).overrideWith(() => FakeCanAccessResourceStateController(hasAccess)),
      ],
    );
  }

  group('StatisticsStateController', () {
    test('should return statistics on success', () async {
      // ARRANGE
      final stats = EntityFactory.makeBsfProcessAuthorizationStatisticEntity();
      when(
        () => mockRepository.getStatistics(any()),
      ).thenAnswer((_) async => stats);

      final container = makeProviderContainer(session: fakeSession);
      addTearDown(container.dispose);

      // Pre-initialize the permission provider so it is already resolved when the statistics provider builds
      await container.read(
        canAccessResourceStateControllerProvider(
          BsRoutine.generic,
          BsResource.processAuthorizationRules,
        ).future,
      );

      // ACT
      final result = await container.read(
        statisticsStateControllerProvider.future,
      );

      // ASSERT
      expect(result, stats);
      verify(
        () => mockRepository.getStatistics(
          EcRequestParams(
            workingUrl: fakeSession.enterprise!.workingUrl!,
            user: fakeSession.user.name!,
            accessKey: fakeSession.user.AccessKey!,
          ),
        ),
      ).called(1);
    });

    test('should throw AppException when session is invalid', () async {
      // ARRANGE
      final container = makeProviderContainer();
      addTearDown(container.dispose);

      // Pre-initialize the permission provider
      await container.read(
        canAccessResourceStateControllerProvider(
          BsRoutine.generic,
          BsResource.processAuthorizationRules,
        ).future,
      );

      // ACT & ASSERT
      await expectLater(
        container.read(statisticsStateControllerProvider.future),
        throwsA(
          isA<AppException>().having(
            (e) => e.message,
            'message',
            equals('Sessão inválida.'),
          ),
        ),
      );

      verifyNever(() => mockRepository.getStatistics(any()));
    });

    test(
      'should throw AppException with permission error when user has no resource access',
      () async {
        // ARRANGE
        final container = makeProviderContainer(
          session: fakeSession,
          hasAccess: false,
        );
        addTearDown(container.dispose);

        // Pre-initialize the permission provider
        await container.read(
          canAccessResourceStateControllerProvider(
            BsRoutine.generic,
            BsResource.processAuthorizationRules,
          ).future,
        );

        // ACT & ASSERT
        await expectLater(
          container.read(statisticsStateControllerProvider.future),
          throwsA(
            isA<AppException>().having(
              (e) => e.message,
              'message',
              equals('Usuário sem permissão para acessar este módulo'),
            ),
          ),
        );

        verifyNever(() => mockRepository.getStatistics(any()));
      },
    );

    test('should propagate errors when repository fails', () async {
      // ARRANGE
      final exception = Exception('Repository error');
      when(() => mockRepository.getStatistics(any())).thenThrow(exception);

      final container = makeProviderContainer(session: fakeSession);
      addTearDown(container.dispose);

      // Pre-initialize the permission provider
      await container.read(
        canAccessResourceStateControllerProvider(
          BsRoutine.generic,
          BsResource.processAuthorizationRules,
        ).future,
      );

      // ACT & ASSERT
      await expectLater(
        container.read(statisticsStateControllerProvider.future),
        throwsA(equals(exception)),
      );
    });
  });
}
