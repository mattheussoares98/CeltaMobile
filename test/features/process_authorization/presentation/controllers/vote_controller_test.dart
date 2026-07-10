// test/features/process_authorization/presentation/controllers/statistics_state_controller_test.dart
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
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
  late UserSessionModel fakeSession;
  late int processCode;
  late bool authorized;
  late String? observations;

  setUp(() {
    mockRepository = MockEcProcessAuthorizationRepository();
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
      ],
    );
  }

  group('VoteController', () {
    test('should behave correctly on success', () async {
      // ARRANGE
      when(
        () => mockRepository.vote(
          any(),
          processCode: any(named: 'processCode'),
          authorized: any(named: 'authorized'),
          observations: any(named: 'observations'),
        ),
      ).thenAnswer((_) async {});

      final container = makeProviderContainer(session: fakeSession);
      addTearDown(container.dispose);

      // ACT
      await container
          .read(voteControllerProvider(processCode).notifier)
          .vote(authorized, observations);

      // ASSERT
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
    });

    test('should throw AppException when session is invalid', () async {
      // ARRANGE
      final container = makeProviderContainer(session: null);
      addTearDown(container.dispose);

      // ACT & ASSERT
      await container
          .read(voteControllerProvider(processCode).notifier)
          .vote(authorized, observations);

      // ACT & ASSERT
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

    test('should propagate errors when repository fails', () async {
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

      final container = makeProviderContainer(session: fakeSession);
      addTearDown(container.dispose);

      await container
          .read(voteControllerProvider(processCode).notifier)
          .vote(authorized, observations);

      // ACT & ASSERT
      expect(
        container.read(voteControllerProvider(processCode)),
        isA<AsyncError<void>>(),
      );
    });
  });
}
