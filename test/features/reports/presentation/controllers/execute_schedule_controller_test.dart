import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_intelligence/exceptions/app_exception.dart';
import 'package:celta_intelligence/features/enterprises/presentation/controllers/controllers.dart';
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

  late int fakeReportScheduleCode;
  late bool sendEmailOnExecution;

  setUp(() {
    mockRepository = MockSoapExecuteOrDownloadScheduleRepository();
    fakeReportScheduleCode = faker.randomGenerator.integer(100);

    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakeEnterprise = EntityFactory.makeEnterpriseEntity();
    sendEmailOnExecution = faker.randomGenerator.boolean();
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

  group('ExecuteScheduleController', () {
    test(
      'execute should emit [loading, data] and call repository with execute=true',
      () async {
        // ARRANGE
        when(
          () => mockRepository.executeOrDownloadSchedule(
            baseUrl: any(named: 'baseUrl'),
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
          executeScheduleControllerProvider,
          (_, next) => states.add(next),
        );

        // ACT
        await container
            .read(executeScheduleControllerProvider.notifier)
            .execute(
              reportScheduleCode: fakeReportScheduleCode,
              sendEmailOnExecution: sendEmailOnExecution,
            );

        // ASSERT
        // 1. Verify state changes (Loading -> Data)
        expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);

        // 2. Verify repository was called with execute=true
        verify(
          () => mockRepository.executeOrDownloadSchedule(
            baseUrl: fakeSession.enterprise!.baseUrl!,
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            reportScheduleCode: fakeReportScheduleCode,
            execute: true, // Critical check
            sendEmailOnExecution: sendEmailOnExecution,
            downloadPdf: false,
            downloadXlsx: false,
          ),
        ).called(1);
      },
    );

    test(
      'execute should emit [loading, error] when session is invalid',
      () async {
        // ARRANGE
        final container = makeProviderContainer(
          session: null,
          enterprise: fakeEnterprise,
        );
        addTearDown(container.dispose);

        final states = <AsyncValue<void>>[];
        container.listen(
          executeScheduleControllerProvider,
          (_, next) => states.add(next),
        );

        // ACT
        await container
            .read(executeScheduleControllerProvider.notifier)
            .execute(
              reportScheduleCode: fakeReportScheduleCode,
              sendEmailOnExecution: sendEmailOnExecution,
            );

        // ASSERT
        // 1. Verify state transitions to Error
        expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
        expect(states.last.error, isA<AppException>());

        // 2. Verify repository was never called
        verifyNever(
          () => mockRepository.executeOrDownloadSchedule(
            baseUrl: any(named: 'baseUrl'),
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
          baseUrl: any(named: 'baseUrl'),
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
          .read(executeScheduleControllerProvider.notifier)
          .execute(
            reportScheduleCode: fakeReportScheduleCode,
            sendEmailOnExecution: sendEmailOnExecution,
          );

      final finalState = container.read(executeScheduleControllerProvider);
      expect(finalState.hasError, isTrue);
    });
  });
}
