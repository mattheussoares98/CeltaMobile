import 'dart:async';

import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/app_usage/app_usage.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/exceptions/app_exception.dart';
import 'package:celta_inventario/features/enterprises/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/reports/domain/entities/entities.dart';
import 'package:celta_inventario/features/reports/domain/repository/repository.dart';
import 'package:celta_inventario/features/reports/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/reports/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:faker/faker.dart';

import '../../../../mocks/mocks.dart';

// --- Fakes and Mocks for Dependencies ---

class MockSoapExecuteOrDownloadScheduleRepository extends Mock
    implements ISoapExecuteOrDownloadScheduleRepository {}

class SpyReportsStateController extends ReportsStateController {
  int? capturedUpdateCode;

  @override
  FutureOr<List<ReportScheduleEntity>> build() async => [];

  @override
  void updateExecutionDate(int reportScheduleCode) {
    capturedUpdateCode = reportScheduleCode;
  }
}

void main() {
  late MockSoapExecuteOrDownloadScheduleRepository mockRepository;
  late SpyReportsStateController spyReportsController;
  late UserSessionModel fakeSession;
  late EnterpriseEntity fakeEnterprise;
  late FakeAppUsageStateController fakeAppUsage;

  late int fakeReportScheduleCode;
  late bool sendEmailOnExecution;

  setUp(() {
    mockRepository = MockSoapExecuteOrDownloadScheduleRepository();
    spyReportsController = SpyReportsStateController();
    fakeReportScheduleCode = faker.randomGenerator.integer(100);

    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakeEnterprise = EntityFactory.makeEnterpriseEntity();
    sendEmailOnExecution = faker.randomGenerator.boolean();

    fakeAppUsage = FakeAppUsageStateController();
  });

  ProviderContainer makeProviderContainer({
    UserSessionModel? session,
    EnterpriseEntity? enterprise,
  }) {
    return ProviderContainer(
      retry: (retryCount, error) => null,
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
        reportsStateControllerProvider.overrideWith(() => spyReportsController),
        appUsageStateControllerProvider.overrideWith(() => fakeAppUsage),
      ],
    );
  }

  group('ExecuteScheduleController', () {
    test(
      'execute should emit [loading, data] and call repository with execute=true',
      () async {
        // ARRANGE
        when(
          () => mockRepository.executeOrDownloadSchedule(
            workingUrl: any(named: 'workingUrl'),
            crossIdentity: any(named: 'crossIdentity'),
            reportScheduleCode: any(named: 'reportScheduleCode'),
            execute: any(named: 'execute'),
            sendEmailOnExecution: any(named: 'sendEmailOnExecution'),
            downloadPdf: any(named: 'downloadPdf'),
            downloadXlsx: any(named: 'downloadXlsx'),
          ),
        ).thenAnswer((_) async {
          await Future.delayed(Duration.zero); // Simulate async success
          return []; // The execute action does not return data, only void/status
        });

        final container = makeProviderContainer(
          session: fakeSession,
          enterprise: fakeEnterprise,
        );
        addTearDown(container.dispose);

        final states = <AsyncValue<void>>[];
        container.listen(
          executeScheduleControllerProvider(fakeReportScheduleCode),
          (_, next) => states.add(next),
        );

        // ACT
        await container
            .read(
              executeScheduleControllerProvider(
                fakeReportScheduleCode,
              ).notifier,
            )
            .execute(sendEmailOnExecution);

        // ASSERT
        // 1. Verify state changes (Loading -> Data)
        expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);

        // 2. Verify repository was called with execute=true
        verify(
          () => mockRepository.executeOrDownloadSchedule(
            workingUrl: fakeSession.enterprise!.workingUrl!,
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            reportScheduleCode: fakeReportScheduleCode,
            execute: true, // Critical check
            sendEmailOnExecution: sendEmailOnExecution,
            downloadPdf: false,
            downloadXlsx: false,
          ),
        ).called(1);

        expect(spyReportsController.capturedUpdateCode, fakeReportScheduleCode);
        expect(fakeAppUsage.lastUsageType, UsageType.generateReport);
      },
    );

    test(
      'execute should emit [loading, error] when session is invalid',
      () async {
        // ARRANGE
        final container = makeProviderContainer(
          enterprise: fakeEnterprise,
        );
        addTearDown(container.dispose);

        final states = <AsyncValue<void>>[];
        container.listen(
          executeScheduleControllerProvider(fakeReportScheduleCode),
          (_, next) => states.add(next),
        );

        // ACT
        await container
            .read(
              executeScheduleControllerProvider(
                fakeReportScheduleCode,
              ).notifier,
            )
            .execute(sendEmailOnExecution);

        // ASSERT
        // 1. Verify state transitions to Error
        expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
        expect(states.last.error, isA<AppException>());

        // 2. Verify repository was never called
        verifyNever(
          () => mockRepository.executeOrDownloadSchedule(
            workingUrl: any(named: 'workingUrl'),
            crossIdentity: any(named: 'crossIdentity'),
            reportScheduleCode: any(named: 'reportScheduleCode'),
            execute: any(named: 'execute'),
            sendEmailOnExecution: any(named: 'sendEmailOnExecution'),
            downloadPdf: any(named: 'downloadPdf'),
            downloadXlsx: any(named: 'downloadXlsx'),
          ),
        );
      },
    );

    test('execute should throw if repository fails', () async {
      // ARRANGE
      final exception = Exception('SOAP API Failed');
      when(
        () => mockRepository.executeOrDownloadSchedule(
          workingUrl: any(named: 'workingUrl'),
          crossIdentity: any(named: 'crossIdentity'),
          reportScheduleCode: any(named: 'reportScheduleCode'),
          execute: any(named: 'execute'),
          sendEmailOnExecution: any(named: 'sendEmailOnExecution'),
          downloadPdf: any(named: 'downloadPdf'),
          downloadXlsx: any(named: 'downloadXlsx'),
        ),
      ).thenThrow(exception);

      final container = makeProviderContainer(
        session: fakeSession,
        enterprise: fakeEnterprise,
      );
      addTearDown(container.dispose);

      // ACT & ASSERT
      await container
          .read(
            executeScheduleControllerProvider(fakeReportScheduleCode).notifier,
          )
          .execute(sendEmailOnExecution);

      final finalState = container.read(
        executeScheduleControllerProvider(fakeReportScheduleCode),
      );
      expect(finalState.hasError, isTrue);
    });
  });
}
