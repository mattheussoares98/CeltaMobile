// test/features/process_authorization/presentation/controllers/judgments_state_controller_test.dart
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/exceptions/app_exception.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:celta_inventario/features/process_authorization/domain/repositories/repositories.dart';
import 'package:celta_inventario/features/process_authorization/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/process_authorization/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockEcProcessAuthorizationRepository extends Mock
    implements IEcProcessAuthorizationRepository {}

void main() {
  late MockEcProcessAuthorizationRepository mockRepository;
  late UserSessionModel fakeSession;
  late List<BSFAuthorizationProcessJudgmentEntity> fakeJudgments;

  setUp(() {
    mockRepository = MockEcProcessAuthorizationRepository();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakeJudgments = [
      EntityFactory.makeBSFAuthorizationProcessJudgmentEntity(),
      EntityFactory.makeBSFAuthorizationProcessJudgmentEntity(),
    ];
    registerFallbackValue(
      const EcRequestParams(workingUrl: '', user: '', accessKey: ''),
    );
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

  group('JudgmentsStateController', () {
    test('should return a list of judgments on success', () async {
      // ARRANGE
      when(
        () => mockRepository.getJudgments(any()),
      ).thenAnswer((_) async => fakeJudgments);

      final container = makeProviderContainer(session: fakeSession);
      addTearDown(container.dispose);

      // ACT
      final result = await container.read(
        judgmentsStateControllerProvider.future,
      );

      // ASSERT
      expect(result, fakeJudgments);
      verify(
        () => mockRepository.getJudgments(
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
      final container = makeProviderContainer(session: null);
      addTearDown(container.dispose);

      // ACT & ASSERT
      await expectLater(
        container.read(judgmentsStateControllerProvider.future),
        throwsA(isA<AppException>()),
      );

      verifyNever(() => mockRepository.getJudgments(any()));
    });

    test('should propagate errors when repository fails', () async {
      // ARRANGE
      final exception = Exception('Repository error');
      when(() => mockRepository.getJudgments(any())).thenThrow(exception);

      final container = makeProviderContainer(session: fakeSession);
      addTearDown(container.dispose);

      // ACT & ASSERT
      await expectLater(
        container.read(judgmentsStateControllerProvider.future),
        throwsA(equals(exception)),
      );
    });
  });
}
