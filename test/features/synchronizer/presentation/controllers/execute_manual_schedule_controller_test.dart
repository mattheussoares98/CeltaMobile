// test/features/synchronizer/presentation/controllers/execute_manual_schedule_controller_test.dart
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
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
      const SearchManualExecutionSchedulesParametersEntity(
        enterpriseCode: enterpriseCode,
      ),
    );
  });

  setUpAll(() {
    registerFallbackValue(
      EntityFactory.makeExecuteManualScheduleParametersEntity(),
    );
  });

  ProviderContainer makeContainer() => ProviderContainer(
    retry: (retryCount, error) => null,
    overrides: [
      ecSynchronizerManualExecutionRepositoryProvider.overrideWithValue(
        repository,
      ),
      ecRequestParamsProvider().overrideWith((ref) => params),
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
    final searchParamsEntity =
        EntityFactory.makeSearchManualExecutionSchedulesParametersEntity()
            .copyWith(enterpriseCode: enterpriseCode);
    final initialSchedules = [
      const ManualExecutionScheduleEntity(
        code: scheduleCode,
        name: 'Schedule 1',
      ),
    ];

    test(
      'should execute schedule successfully and update dateOfLastExecution',
      () async {
        when(
          () => repository.executeManualSchedule(params, executeParamsEntity),
        ).thenAnswer((_) async {});
        when(
          () => repository.searchManualExecutionSchedules(
            any(),
            searchParamsEntity,
          ),
        ).thenAnswer((_) async => initialSchedules);

        final container = makeContainer();
        addTearDown(container.dispose);

        await container.read(
          manualExecutionSchedulesStateControllerProvider(
            enterpriseCode,
          ).future,
        );

        final before = DateTime.now();
        final result = await execute(container);
        final after = DateTime.now();

        expect(result, isTrue);
        verify(
          () => repository.executeManualSchedule(params, executeParamsEntity),
        ).called(1);

        final updatedSchedules = container
            .read(
              manualExecutionSchedulesStateControllerProvider(enterpriseCode),
            )
            .value;
        expect(updatedSchedules, isNotNull);
        final updatedSchedule = updatedSchedules!.firstWhere(
          (s) => s.code == scheduleCode,
        );
        expect(updatedSchedule.dateOfLastExecution, isNotNull);
        expect(
          updatedSchedule.dateOfLastExecution!.isAfter(
                before.subtract(const Duration(seconds: 1)),
              ) &&
              updatedSchedule.dateOfLastExecution!.isBefore(
                after.add(const Duration(seconds: 1)),
              ),
          isTrue,
        );
      },
    );

    test(
      'should return false and capture error when execution fails',
      () async {
        final exception = Exception('Failed to execute schedule');
        when(
          () => repository.executeManualSchedule(params, executeParamsEntity),
        ).thenThrow(exception);

        final container = makeContainer();
        addTearDown(container.dispose);

        final provider = executeManualScheduleControllerProvider(
          enterpriseCode: enterpriseCode,
          scheduleCode: scheduleCode,
        );
        await container.read(provider.future);
        final notifier = container.read(provider.notifier);

        final result = await notifier.execute();

        expect(result, isFalse);
        expect(notifier.state.error, same(exception));
        verify(
          () => repository.executeManualSchedule(params, executeParamsEntity),
        ).called(1);
        verifyNoMoreInteractions(repository);
      },
    );
  });
}
