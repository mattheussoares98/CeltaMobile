// test/features/synchronizer/presentation/controllers/execute_manual_schedule_controller_test.dart
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
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
  late MockEcSynchronizerManualExecutionRepository repository;
  late UserSessionModel session;
  late EcRequestParams params;

  const enterpriseCode = 123;
  const scheduleCode = 456;

  setUp(() {
    repository = MockEcSynchronizerManualExecutionRepository();
    session = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    params = EcRequestParams(
      workingUrl: session.enterprise!.workingUrl!,
      user: session.user.name!,
      accessKey: session.user.AccessKey!,
    );
    registerFallbackValue(
      const EcRequestParams(workingUrl: '', user: '', accessKey: ''),
    );
    registerFallbackValue(
      const ExecuteManualScheduleParametersEntity(
        enterpriseCode: enterpriseCode,
        scheduleCode: scheduleCode,
      ),
    );
  });

  ProviderContainer makeContainer() => ProviderContainer(
    retry: (retryCount, error) => null,
    overrides: [
      ecSynchronizerManualExecutionRepositoryProvider.overrideWithValue(
        repository,
      ),
      validatedUserSessionProvider.overrideWith(
        () => FakeValidatedUserSession(session),
      ),
    ],
  );

  Future<bool> execute(ProviderContainer container) async {
    await container.read(
      executeManualScheduleControllerProvider(
        enterpriseCode: enterpriseCode,
        scheduleCode: scheduleCode,
      ).future,
    );

    return container
        .read(
          executeManualScheduleControllerProvider(
            enterpriseCode: enterpriseCode,
            scheduleCode: scheduleCode,
          ).notifier,
        )
        .execute();
  }

  group('ExecuteManualScheduleController', () {
    final executeParamsEntity =
        EntityFactory.makeExecuteManualScheduleParametersEntity().copyWith(
          enterpriseCode: enterpriseCode,
          scheduleCode: scheduleCode,
        );

    test('should execute schedule successfully and return true', () async {
      when(
        () => repository.executeManualSchedule(params, executeParamsEntity),
      ).thenAnswer((_) async {});

      final container = makeContainer();
      addTearDown(container.dispose);

      final result = await execute(container);

      expect(result, isTrue);
      verify(
        () => repository.executeManualSchedule(params, executeParamsEntity),
      ).called(1);
      verifyNoMoreInteractions(repository);
    });

    test(
      'should return false and capture error when execution fails',
      () async {
        final exception = Exception('Failed to execute schedule');
        when(
          () => repository.executeManualSchedule(params, executeParamsEntity),
        ).thenThrow(exception);

        final container = makeContainer();
        addTearDown(container.dispose);

        final result = await execute(container);

        expect(result, isFalse);
        expect(
          container
              .read(
                executeManualScheduleControllerProvider(
                  enterpriseCode: enterpriseCode,
                  scheduleCode: scheduleCode,
                ),
              )
              .error,
          same(exception),
        );
        verify(
          () => repository.executeManualSchedule(params, executeParamsEntity),
        ).called(1);
        verifyNoMoreInteractions(repository);
      },
    );
  });
}
