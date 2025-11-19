import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_intelligence/exceptions/app_exception.dart';
import 'package:celta_intelligence/features/competing_prices/domain/entities/entities.dart';
import 'package:celta_intelligence/features/competing_prices/domain/repository/repository.dart';
import 'package:celta_intelligence/features/competing_prices/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/competing_prices/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

// --- Fakes and Mocks for Dependencies ---

class MockSoapLoadConcurrentsRepository extends Mock
    implements ISoapLoadConcurrentsRepository {}

void main() {
  late MockSoapLoadConcurrentsRepository mockRepository;
  late UserSessionModel fakeSession;
  late List<ConcurrentEntity> fakeConcurrents;

  setUpAll(() {
    // Register fallback for mocktail
    registerFallbackValue('any_string');
  });

  setUp(() {
    mockRepository = MockSoapLoadConcurrentsRepository();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakeConcurrents = [EntityFactory.makeConcurrentEntity()];
  });

  ProviderContainer makeProviderContainer({UserSessionModel? session}) {
    return ProviderContainer(
      overrides: [
        soapLoadConcurrentsRepositoryProvider.overrideWithValue(mockRepository),
        // Override the keepAlive provider
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
      ],
    );
  }

  group('ConcurrentsStateController', () {
    test(
      'should return list of concurrents and call repository with searchValue: null on success',
      () async {
        // ARRANGE
        when(
          () => mockRepository.load(
            crossIdentity: any(named: 'crossIdentity'),
            baseUrl: any(named: 'baseUrl'),
            searchValue: any(named: 'searchValue'),
          ),
        ).thenAnswer((_) async {
          await Future.delayed(Duration.zero);
          return fakeConcurrents;
        });

        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        // ACT
        final result = await container.read(
          concurrentsStateControllerProvider.future,
        );

        // ASSERT
        expect(result, fakeConcurrents);
        verify(
          () => mockRepository.load(
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            baseUrl: fakeSession.enterprise!.baseUrl!,
            searchValue: null, // Verify the default is passed
          ),
        ).called(1);
      },
    );

    test(
      'should throw AppException when validatedUserSession is invalid',
      () async {
        // ARRANGE
        final container = makeProviderContainer(session: null);
        addTearDown(container.dispose);

        // ACT & ASSERT
        await expectLater(
          container.read(concurrentsStateControllerProvider.future),
          throwsA(isA<AppException>()),
        );

        // Verify the repository was never called
        verifyNever(
          () => mockRepository.load(
            crossIdentity: any(named: 'crossIdentity'),
            baseUrl: any(named: 'baseUrl'),
            searchValue: any(named: 'searchValue'),
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
          searchValue: any(named: 'searchValue'),
        ),
      ).thenThrow(exception);

      final container = makeProviderContainer(session: fakeSession);
      addTearDown(container.dispose);

      // ACT & ASSERT
      await expectLater(
        container.read(concurrentsStateControllerProvider.future),
        throwsA(isA<Exception>()),
      );
    });
  });
}
