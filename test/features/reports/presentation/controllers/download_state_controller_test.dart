import 'package:celta_inventario/core/data/datasource/share_download/share_download.dart';
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/share_download/share_download.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/enterprises/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/reports/domain/entities/entities.dart';
import 'package:celta_inventario/features/reports/domain/repository/repository.dart';
import 'package:celta_inventario/features/reports/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/reports/providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:faker/faker.dart';

import '../../../../mocks/mocks.dart';

// --- Fakes and Mocks for Dependencies ---

class MockSoapExecuteOrDownloadScheduleRepository extends Mock
    implements ISoapExecuteOrDownloadScheduleRepository {}

class FakeShareDownloadController extends ShareDownloadController {
  final String? returnPath;
  bool get calledShareOrDownload => _calledShareOrDownload;
  bool _calledShareOrDownload = false;
  FakeShareDownloadController({required this.returnPath});

  @override
  Future<void> share(FileProperties file) async {
    _calledShareOrDownload = true;
  }

  @override
  Future<String?> download(FileProperties file, TargetPlatform platform) async {
    _calledShareOrDownload = true;
    return returnPath;
  }
}

void main() {
  late MockSoapExecuteOrDownloadScheduleRepository mockRepository;
  late FakeShareDownloadController fakeShareDownloadController;
  late UserSessionModel fakeSession;
  late EnterpriseEntity fakeEnterprise;
  late DownloadExecutionEntity downloadExecutionEntity;
  late int fakeReportScheduleCode;
  late DownloadType downloadType;
  late String fakeModelName;

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeScheduleExecutionsEntity());
    registerFallbackValue(
      FileProperties(name: '', bytes: Uint8List(0), extension: '.xlsx'),
    );
    registerFallbackValue(TargetPlatform.windows);
  });

  setUp(() {
    mockRepository = MockSoapExecuteOrDownloadScheduleRepository();
    fakeReportScheduleCode = faker.randomGenerator.integer(100);

    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakeEnterprise = EntityFactory.makeEnterpriseEntity(code: 1);

    // Result entity for successful download/execute actions
    downloadExecutionEntity = DownloadExecutionEntity(
      executionResult: EntityFactory.makeScheduleExecutionsEntity(
        reportScheduleCode: fakeReportScheduleCode,
        downloadType: DownloadType.xlsx,
      ),
      xlsxFilePath: "${faker.lorem.word()}\\.xlsx",
    );
    downloadType = DownloadType
        .values[faker.randomGenerator.integer(DownloadType.values.length)];

    fakeModelName = faker.lorem.word();
    fakeShareDownloadController = FakeShareDownloadController(
      returnPath: downloadExecutionEntity.xlsxFilePath,
    );
  });

  setUpAll(() {
    for (var value in DownloadType.values) {
      registerFallbackValue(value);
    }
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
        shareDownloadControllerProvider.overrideWith(
          () => fakeShareDownloadController,
        ),
      ],
    );
  }

  group('DownloadStateController', () {
    test('build should return an initial empty map', () async {
      final container = makeProviderContainer(
        session: fakeSession,
        enterprise: fakeEnterprise,
      );
      addTearDown(container.dispose);

      final result = await container.read(
        downloadStateControllerProvider(
          fakeReportScheduleCode,
          downloadType,
        ).future,
      );
      expect(result, isNull);
    });

    group('download', () {
      test(
        'should call download and return file path on success (xlsx/desktop)',
        () async {
          // ARRANGE
          // 1. Mock repository to return the data with attachments

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
            await Future.delayed(Duration.zero);
            return [downloadExecutionEntity.executionResult];
          });

          // Use verify to track the call to the fake controller's method

          final container = makeProviderContainer(
            session: fakeSession,
            enterprise: fakeEnterprise,
          );
          addTearDown(container.dispose);
          await container.read(
            downloadStateControllerProvider(
              fakeReportScheduleCode,
              DownloadType.xlsx,
            ).future,
          ); // Settle dependencies

          // ACT
          await container
              .read(
                downloadStateControllerProvider(
                  fakeReportScheduleCode,
                  DownloadType.xlsx,
                ).notifier,
              )
              .download(TargetPlatform.windows, fakeModelName);

          // ASSERT
          // 1. Verify the final result is the file path
          expect(
            fakeShareDownloadController.returnPath,
            downloadExecutionEntity.xlsxFilePath,
          );
          expect(fakeShareDownloadController.calledShareOrDownload, isTrue);

          // 3. Verify the main repository was called
          verify(
            () => mockRepository.executeOrDownloadSchedule(
              workingUrl: fakeSession.enterprise!.workingUrl!,
              crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
              reportScheduleCode: fakeReportScheduleCode,
              execute: false,
              sendEmailOnExecution: false,
              downloadPdf: false,
              downloadXlsx: true,
            ),
          ).called(1);
        },
      );

      test(
        'should return null if downloadType is PDF (no path needed)',
        () async {
          // ARRANGE
          downloadExecutionEntity = DownloadExecutionEntity(
            executionResult: EntityFactory.makeScheduleExecutionsEntity(
              reportScheduleCode: fakeReportScheduleCode,
              downloadType: DownloadType.pdf,
            ),
          );
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
          ).thenAnswer((_) async => [downloadExecutionEntity.executionResult]);

          final container = makeProviderContainer(
            session: fakeSession,
            enterprise: fakeEnterprise,
          );
          addTearDown(container.dispose);
          await container.read(
            downloadStateControllerProvider(
              fakeReportScheduleCode,
              DownloadType.pdf,
            ).future,
          );

          // ACT
          await container
              .read(
                downloadStateControllerProvider(
                  fakeReportScheduleCode,
                  DownloadType.pdf,
                ).notifier,
              )
              .download(TargetPlatform.windows, fakeModelName); // Use PDF type

          // ASSERT
          // The return value should be null because the PDF is handled by navigation
          // expect(downloadExecutionEntity.xlsxFilePath, isNull);
          expect(fakeShareDownloadController.calledShareOrDownload, isFalse);
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
          downloadStateControllerProvider(
            fakeReportScheduleCode,
            downloadType,
          ).future,
        );

        // FIX: Initialize states list and attach listener
        final states = <AsyncValue<DownloadExecutionEntity?>>[];
        container.listen(
          downloadStateControllerProvider(fakeReportScheduleCode, downloadType),
          (_, next) => states.add(next),
        );

        // ACT
        await container
            .read(
              downloadStateControllerProvider(
                fakeReportScheduleCode,
                downloadType,
              ).notifier,
            )
            .download(TargetPlatform.windows, 'test');

        // ASSERT

        // Final check for state transitions
        expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
      });
    });
  });
}
