import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_intelligence/exceptions/app_exception.dart';
import 'package:celta_intelligence/features/reports/domain/entities/entities.dart';
import 'package:celta_intelligence/features/reports/domain/repository/repository.dart';
import 'package:celta_intelligence/features/reports/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/reports/providers.dart';
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
    fakeReports = [EntityFactory.makeReportScheduleEntity()];
  });

  ProviderContainer makeProviderContainer({UserSessionModel? session}) {
    // We create a new container for each test to avoid keepAlive conflicts
    return ProviderContainer(
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
            baseUrl: any(named: 'baseUrl'),
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
            baseUrl: fakeSession.enterprise!.baseUrl!,
          ),
        ).called(1);
      },
    );

    test(
      'should throw AppException when validatedUserSession is invalid',
      () async {
        // ARRANGE
        final container = makeProviderContainer(
          session: null,
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
            baseUrl: any(named: 'baseUrl'),
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
          baseUrl: any(named: 'baseUrl'),
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
}
