import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/exceptions/app_exception.dart';
import 'package:celta_inventario/features/reports/domain/entities/entities.dart';
import 'package:celta_inventario/features/reports/domain/repository/repository.dart';
import 'package:celta_inventario/features/reports/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/reports/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

// --- Fakes and Mocks for Dependencies ---

class MockSoapLoadReportsRepository extends Mock
    implements ISoapLoadReportsRepository {}

void main() {
  late MockSoapLoadReportsRepository mockRepository;
  late UserSessionModel fakeSession;
  late List<ReportScheduleEntity> fakeReports;

  setUp(() {
    mockRepository = MockSoapLoadReportsRepository();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakeReports = [
      EntityFactory.makeReportScheduleEntity(
        Code: faker.randomGenerator.integer(100, min: 1),
      ),
      EntityFactory.makeReportScheduleEntity(
        Code: faker.randomGenerator.integer(200, min: 101),
      ),
      EntityFactory.makeReportScheduleEntity(
        Code: faker.randomGenerator.integer(300, min: 201),
      ),
    ];
  });

  ProviderContainer makeProviderContainer({UserSessionModel? session}) {
    // We create a new container for each test to avoid keepAlive conflicts
    return ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        soapLoadReportsRepositoryProvider.overrideWithValue(mockRepository),
        // Override the keepAlive provider
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
      ],
    );
  }

  group('ReportsStateController', () {
    test(
      'should return list of reports and call repository on success',
      () async {
        // ARRANGE
        when(
          () => mockRepository.load(
            crossIdentity: any(named: 'crossIdentity'),
            workingUrl: any(named: 'workingUrl'),
          ),
        ).thenAnswer((_) async {
          await Future.delayed(Duration.zero);
          return fakeReports;
        });

        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        // ACT: Reading the future triggers the build and waits for completion.
        final result = await container.read(
          reportsStateControllerProvider.future,
        );

        // ASSERT
        expect(result, fakeReports);
        verify(
          () => mockRepository.load(
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            workingUrl: fakeSession.enterprise!.workingUrl!,
          ),
        ).called(1);
      },
    );

    test(
      'should throw AppException when validatedUserSession is invalid',
      () async {
        // ARRANGE
        final container = makeProviderContainer(
          
        ); // Invalid session
        addTearDown(container.dispose);

        // ACT & ASSERT
        await expectLater(
          container.read(reportsStateControllerProvider.future),
          throwsA(isA<AppException>()),
        );

        // Verify the repository was never called
        verifyNever(
          () => mockRepository.load(
            crossIdentity: any(named: 'crossIdentity'),
            workingUrl: any(named: 'workingUrl'),
          ),
        );
      },
    );

    test('should throw if repository fails', () async {
      // ARRANGE
      final exception = Exception('Network Error');
      when(
        () => mockRepository.load(
          crossIdentity: any(named: 'crossIdentity'),
          workingUrl: any(named: 'workingUrl'),
        ),
      ).thenThrow(exception);

      final container = makeProviderContainer(session: fakeSession);
      addTearDown(container.dispose);

      // ACT & ASSERT
      await expectLater(
        container.read(reportsStateControllerProvider.future),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('updateExecutionDate', () {
    test(
      'should update LastExecutionDate for the specific report code',
      () async {
        // ARRANGE
        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        when(
          () => mockRepository.load(
            crossIdentity: any(named: 'crossIdentity'),
            workingUrl: any(named: 'workingUrl'),
          ),
        ).thenAnswer((_) async => fakeReports);

        // Load initial state
        await container.read(reportsStateControllerProvider.future);

        final targetReportCode = fakeReports[0].Code;
        final timeBeforeUpdate = DateTime.now();

        // ACT
        container
            .read(reportsStateControllerProvider.notifier)
            .updateExecutionDate(targetReportCode);

        // ASSERT
        final state = container.read(reportsStateControllerProvider);
        final updatedList = state.value!;
        final updatedReport = updatedList.firstWhere(
          (e) => e.Code == targetReportCode,
        );
        final untouchedReport = updatedList.firstWhere(
          (e) => e.Code == fakeReports[1].Code,
        );

        // Check if the date was updated to "now"
        expect(updatedReport.LastExecutionDate, isNotNull);
        expect(
          updatedReport.LastExecutionDate!.isAfter(timeBeforeUpdate) ||
              updatedReport.LastExecutionDate!.isAtSameMomentAs(
                timeBeforeUpdate,
              ),
          isTrue,
        );

        // Ensure other items in the list were not modified
        expect(
          untouchedReport.LastExecutionDate,
          fakeReports[1].LastExecutionDate,
        );
      },
    );

    test('should do nothing if state is null/loading', () {
      // ARRANGE
      final container = makeProviderContainer(session: fakeSession);
      addTearDown(container.dispose);

      // Repository load is not called yet, so state is null/loading
      final notifier = container.read(reportsStateControllerProvider.notifier);

      // ACT
      notifier.updateExecutionDate(faker.randomGenerator.integer(100));

      // ASSERT
      expect(container.read(reportsStateControllerProvider).value, isNull);
    });
  });
}
