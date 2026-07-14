import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/app_usage/app_usage.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/exceptions/app_exception.dart';
import 'package:celta_inventario/features/receipt/data/datasource/datasource.dart';
import 'package:celta_inventario/features/receipt/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/receipt/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

// --- Fakes and Mocks for Dependencies ---

class MockSoapLiberateDocumentDatasource extends Mock
    implements ISoapLiberateDocumentDatasource {}

void main() {
  late MockSoapLiberateDocumentDatasource mockDatasource;
  late UserSessionModel fakeSession;
  late FakeAppUsageStateController fakeAppUsage;

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
    fakeAppUsage = FakeAppUsageStateController();
  });

  ProviderContainer makeProviderContainer({UserSessionModel? session}) {
    return ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        soapLiberateDocumentDatasourceProvider.overrideWithValue(
          mockDatasource,
        ),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
        appUsageStateControllerProvider.overrideWith(() => fakeAppUsage),
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
            workingUrl: any(named: 'workingUrl'),
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
            workingUrl: fakeSession.enterprise!.workingUrl!,
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            CodigoInterno_ProcRecebDoc: fakeDocCode,
          ),
        ).called(1);
        expect(fakeAppUsage.lastUsageType, UsageType.liberateReceiptDocument);
      },
    );

    test(
      'liberate should emit [loading, error] when session is invalid',
      () async {
        // ARRANGE
        final container = makeProviderContainer(
          
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
            workingUrl: any(named: 'workingUrl'),
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
          workingUrl: any(named: 'workingUrl'),
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
