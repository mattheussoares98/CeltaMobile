import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_intelligence/exceptions/app_exception.dart';
import 'package:celta_intelligence/features/receipt/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/receipt/presentation/pages/controllers/controllers.dart';
import 'package:celta_intelligence/features/receipt/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../mocks/mocks.dart';

// --- Fakes and Mocks for Dependencies ---

class MockSoapLiberateDocumentDatasource extends Mock
    implements ISoapLiberateDocumentDatasource {}

void main() {
  late MockSoapLiberateDocumentDatasource mockDatasource;
  late UserSessionModel fakeSession;

  // Test data variables
  late int fakeDocCode;

  setUpAll(() {
    registerFallbackValue(1);
    registerFallbackValue('any_string');
  });

  setUp(() {
    mockDatasource = MockSoapLiberateDocumentDatasource();
    fakeDocCode = faker.randomGenerator.integer(100);

    // Initialize session data
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
  });

  ProviderContainer makeProviderContainer({UserSessionModel? session}) {
    return ProviderContainer(
      overrides: [
        soapLiberateDocumentDatasourceProvider.overrideWithValue(
          mockDatasource,
        ),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
      ],
    );
  }

  group('LiberateDocumentController', () {
    test(
      'liberate should emit [loading, data] and call datasource on success',
      () async {
        // ARRANGE
        when(
          () => mockDatasource.liberate(
            baseUrl: any(named: 'baseUrl'),
            crossIdentity: any(named: 'crossIdentity'),
            CodigoInterno_ProcRecebDoc: fakeDocCode,
          ),
        ).thenAnswer((_) async {
          await Future.delayed(Duration.zero);
        });

        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        final states = <AsyncValue<void>>[];
        container.listen(
          liberateDocumentControllerProvider(fakeDocCode),
          (_, next) => states.add(next),
        );

        // ACT
        await container
            .read(liberateDocumentControllerProvider(fakeDocCode).notifier)
            .liberate();

        // ASSERT
        // 1. Check state transitions
        expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);

        // 2. Verify datasource call
        verify(
          () => mockDatasource.liberate(
            baseUrl: fakeSession.enterprise!.baseUrl!,
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            CodigoInterno_ProcRecebDoc: fakeDocCode,
          ),
        ).called(1);
      },
    );

    test(
      'liberate should emit [loading, error] when session is invalid',
      () async {
        // ARRANGE
        final container = makeProviderContainer(
          session: null,
        ); // Invalid session
        addTearDown(container.dispose);

        final states = <AsyncValue<void>>[];
        container.listen(
          liberateDocumentControllerProvider(fakeDocCode),
          (_, next) => states.add(next),
        );

        // ACT
        await container
            .read(liberateDocumentControllerProvider(fakeDocCode).notifier)
            .liberate();

        // ASSERT
        expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
        expect(states.last.error, isA<AppException>());

        // Verify datasource was never called
        verifyNever(
          () => mockDatasource.liberate(
            baseUrl: any(named: 'baseUrl'),
            crossIdentity: any(named: 'crossIdentity'),
            CodigoInterno_ProcRecebDoc: any(
              named: 'CodigoInterno_ProcRecebDoc',
            ),
          ),
        );
      },
    );

    test('liberate should emit [loading, error] if datasource fails', () async {
      // ARRANGE
      final exception = Exception('API access failed');
      when(
        () => mockDatasource.liberate(
          baseUrl: any(named: 'baseUrl'),
          crossIdentity: any(named: 'crossIdentity'),
          CodigoInterno_ProcRecebDoc: any(named: 'CodigoInterno_ProcRecebDoc'),
        ),
      ).thenThrow(exception);

      final container = makeProviderContainer(session: fakeSession);
      addTearDown(container.dispose);

      final states = <AsyncValue<void>>[];
      container.listen(
        liberateDocumentControllerProvider(fakeDocCode),
        (_, next) => states.add(next),
      );

      // ACT
      await container
          .read(liberateDocumentControllerProvider(fakeDocCode).notifier)
          .liberate();

      // ASSERT
      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
      expect(states.last.error, isA<Exception>());
    });
  });
}
