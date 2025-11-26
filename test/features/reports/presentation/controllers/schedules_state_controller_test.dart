import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_intelligence/features/enterprises/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/reports/domain/entities/entities.dart';
import 'package:celta_intelligence/features/reports/domain/repository/repository.dart';
import 'package:celta_intelligence/features/reports/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/reports/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:faker/faker.dart';

import '../../../../mocks/mocks.dart';

// --- Fakes and Mocks for Dependencies ---

class MockSoapExecuteOrDownloadScheduleRepository extends Mock
    implements ISoapExecuteOrDownloadScheduleRepository {}

void main() {
  late MockSoapExecuteOrDownloadScheduleRepository mockRepository;
  late UserSessionModel fakeSession;
  late EnterpriseEntity fakeEnterprise;
  late ScheduleExecutionsEntity fakeExecutionResult;

  late int fakeReportScheduleCode;

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeScheduleExecutionsEntity());
  });

  setUp(() {
    mockRepository = MockSoapExecuteOrDownloadScheduleRepository();
    fakeReportScheduleCode = faker.randomGenerator.integer(100);

    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakeEnterprise = EntityFactory.makeEnterpriseEntity(code: 1);

    // Result entity for successful download/execute actions
    fakeExecutionResult = EntityFactory.makeScheduleExecutionsEntity(
      reportScheduleCode: fakeReportScheduleCode,
    );
  });

  ProviderContainer makeProviderContainer({
    UserSessionModel? session,
    EnterpriseEntity? enterprise,
  }) {
    return ProviderContainer(
      overrides: [
        soapExecuteOrDownloadScheduleRepositoryProvider.overrideWithValue(
          mockRepository,
        ),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
        selectedEnterpriseStateControllerProvider.overrideWith(
          () => FakeSelectedEnterpriseStateController(enterprise),
        ),
      ],
    );
  }

  group('SchedulesStateController', () {
    test('build should return an initial empty map', () async {
      final container = makeProviderContainer(
        session: fakeSession,
        enterprise: fakeEnterprise,
      );
      addTearDown(container.dispose);

      final result = await container.read(
        schedulesStateControllerProvider(fakeReportScheduleCode).future,
      );
      expect(result, isNull);
    });

    group('execute', () {
      test(
        'should call repository with execute=true and track state transitions',
        () async {
          // ARRANGE
          when(
            () => mockRepository.executeOrDownloadSchedule(
              baseUrl: any(named: 'baseUrl'),
              crossIdentity: any(named: 'crossIdentity'),
              reportScheduleCode: any(named: 'reportScheduleCode'),
              execute: true,
              sendEmailOnExecution: true,
              downloadPdf: any(named: 'downloadPdf'),
              downloadXlsx: any(named: 'downloadXlsx'),
            ),
          ).thenAnswer((_) async {
            await Future.delayed(Duration.zero);
            return [fakeExecutionResult];
          });

          final container = makeProviderContainer(
            session: fakeSession,
            enterprise: fakeEnterprise,
          );
          addTearDown(container.dispose);

          // Wait for initial build
          await container.read(
            schedulesStateControllerProvider(fakeReportScheduleCode).future,
          );

          // FIX: Initialize states list and attach listener
          final states = <AsyncValue<ScheduleExecutionsEntity?>>[];
          container.listen(
            schedulesStateControllerProvider(fakeReportScheduleCode),
            (_, next) => states.add(next),
          );

          // ACT
          await container
              .read(
                schedulesStateControllerProvider(
                  fakeReportScheduleCode,
                ).notifier,
              )
              .execute(sendEmailOnExecution: true);

          // ASSERT
          // 1. Verify state changes (Initial Data -> Loading -> Data)
          expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);

          verify(
            () => mockRepository.executeOrDownloadSchedule(
              baseUrl: fakeSession.enterprise!.baseUrl!,
              crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
              reportScheduleCode: fakeReportScheduleCode,
              execute: true,
              sendEmailOnExecution: true,
              downloadPdf: false,
              downloadXlsx: false,
            ),
          ).called(1);
        },
      );
    });

    group('download', () {
      test(
        'should call repository with execute=false and update map on success',
        () async {
          // ARRANGE
          when(
            () => mockRepository.executeOrDownloadSchedule(
              baseUrl: any(named: 'baseUrl'),
              crossIdentity: any(named: 'crossIdentity'),
              reportScheduleCode: any(named: 'reportScheduleCode'),
              execute: false,
              sendEmailOnExecution: false,
              downloadPdf: true,
              downloadXlsx: false,
            ),
          ).thenAnswer((_) async {
            await Future.delayed(Duration.zero);
            return [fakeExecutionResult];
          });

          final container = makeProviderContainer(
            session: fakeSession,
            enterprise: fakeEnterprise,
          );
          addTearDown(container.dispose);
          await container.read(
            schedulesStateControllerProvider(fakeReportScheduleCode).future,
          );

          // FIX: Initialize states list and attach listener
          final states = <AsyncValue<ScheduleExecutionsEntity?>>[];
          container.listen(
            schedulesStateControllerProvider(fakeReportScheduleCode),
            (_, next) => states.add(next),
          );

          // ACT
          await container
              .read(
                schedulesStateControllerProvider(
                  fakeReportScheduleCode,
                ).notifier,
              )
              .download(downloadPdf: true, downloadXlsx: false);

          // ASSERT
          // 1. Verify state transitions
          expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);

          // 2. Verify repository call matches download flags
          verify(
            () => mockRepository.executeOrDownloadSchedule(
              reportScheduleCode: fakeReportScheduleCode,
              execute: false,
              sendEmailOnExecution: false,
              downloadPdf: true,
              downloadXlsx: false,
              baseUrl: fakeSession.enterprise!.baseUrl!,
              crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            ),
          ).called(1);

          // 3. Verify state update: Map should contain the new entity
          final finalState = container
              .read(schedulesStateControllerProvider(fakeReportScheduleCode))
              .value;
          expect(finalState, fakeExecutionResult);
        },
      );

      test('should emit [loading, error] when session is invalid', () async {
        // ARRANGE
        final container = makeProviderContainer(
          session: null,
          enterprise: fakeEnterprise,
        );
        addTearDown(container.dispose);

        // Wait for initial build
        await container.read(
          schedulesStateControllerProvider(fakeReportScheduleCode).future,
        );

        // FIX: Initialize states list and attach listener
        final states = <AsyncValue<ScheduleExecutionsEntity?>>[];
        container.listen(
          schedulesStateControllerProvider(fakeReportScheduleCode),
          (_, next) => states.add(next),
        );

        // ACT
        await container
            .read(
              schedulesStateControllerProvider(fakeReportScheduleCode).notifier,
            )
            .download(downloadPdf: true, downloadXlsx: false);

        // ASSERT

        // Final check for state transitions
        expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
      });
    });
  });
}
