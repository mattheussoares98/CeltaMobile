// test/features/synchronizer/presentation/controllers/manual_execution_schedules_state_controller_test.dart
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/exceptions/app_exception.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/domain/repositories/repositories.dart';
import 'package:celta_inventario/features/synchronizer/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/synchronizer/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockEcSynchronizerManualExecutionRepository extends Mock
    implements IEcSynchronizerManualExecutionRepository {}

void main() {
  late MockEcSynchronizerManualExecutionRepository mockRepository;
  late UserSessionModel fakeSession;
  const testEnterpriseCode = 123;

  setUp(() {
    mockRepository = MockEcSynchronizerManualExecutionRepository();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    registerFallbackValue(
      const EcRequestParams(workingUrl: '', user: '', accessKey: ''),
    );
    registerFallbackValue(
      const SearchManualExecutionSchedulesParametersEntity(
        enterpriseCode: testEnterpriseCode,
      ),
    );
  });

  ProviderContainer makeProviderContainer({UserSessionModel? session}) {
    return ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        ecSynchronizerManualExecutionRepositoryProvider.overrideWithValue(
          mockRepository,
        ),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
      ],
    );
  }

  group('ManualExecutionSchedulesStateController', () {
    test(
      'should return list of manual execution schedules on success',
      () async {
        // ARRANGE
        final searchParamsEntity =
            EntityFactory.makeSearchManualExecutionSchedulesParametersEntity()
                .copyWith(enterpriseCode: testEnterpriseCode);
        final fakeSchedules = <ManualExecutionScheduleEntity>[
          EntityFactory.makeManualExecutionScheduleEntity(),
        ];


        when(
          () => mockRepository.searchManualExecutionSchedules(
            any(),
            searchParamsEntity,
          ),
        ).thenAnswer((_) async => fakeSchedules);

        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        // ACT
        final result = await container.read(
          manualExecutionSchedulesStateControllerProvider(
            testEnterpriseCode,
          ).future,
        );

        // ASSERT
        expect(result, fakeSchedules);
        verify(
          () => mockRepository.searchManualExecutionSchedules(
            EcRequestParams(
              workingUrl: fakeSession.enterprise!.workingUrl!,
              user: fakeSession.user.name!,
              accessKey: fakeSession.user.AccessKey!,
            ),
            searchParamsEntity,
          ),
        ).called(1);
      },
    );

    test('should throw AppException when session is invalid', () async {
      // ARRANGE
      final container = makeProviderContainer();
      addTearDown(container.dispose);

      // ACT & ASSERT
      await expectLater(
        container.read(
          manualExecutionSchedulesStateControllerProvider(
            testEnterpriseCode,
          ).future,
        ),
        throwsA(
          isA<AppException>().having(
            (e) => e.message,
            'message',
            equals('Sessão inválida.'),
          ),
        ),
      );

      verifyNever(
        () => mockRepository.searchManualExecutionSchedules(any(), any()),
      );
    });
  });
}
