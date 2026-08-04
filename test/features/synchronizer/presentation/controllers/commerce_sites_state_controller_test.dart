// test/features/synchronizer/presentation/controllers/commerce_sites_state_controller_test.dart
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/exceptions/app_exception.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/domain/repositories/repositories.dart';
import 'package:celta_inventario/features/synchronizer/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/synchronizer/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockEcCommerceSiteRepository extends Mock
    implements IEcCommerceSiteRepository {}

void main() {
  late MockEcCommerceSiteRepository mockRepository;
  late UserSessionModel fakeSession;
  const testEnterpriseCode = 123;

  setUp(() {
    mockRepository = MockEcCommerceSiteRepository();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    registerFallbackValue(
      const EcRequestParams(workingUrl: '', user: '', accessKey: ''),
    );
  });

  ProviderContainer makeProviderContainer({
    UserSessionModel? session,
    bool hasAccess = true,
  }) {
    return ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        ecCommerceSiteRepositoryProvider.overrideWithValue(mockRepository),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
      ],
    );
  }

  group('CommerceSitesStateController', () {
    test('should return list of commerce sites on success', () async {
      // ARRANGE
      final fakeSites = <EcCommerceSiteEntity>[
        EntityFactory.makeEcCommerceSiteEntity().copyWith(
          enterpriseCode: testEnterpriseCode,
        ),
      ];

      when(
        () => mockRepository.getCommerceSites(any(), testEnterpriseCode),
      ).thenAnswer((_) async => fakeSites);

      final container = makeProviderContainer(session: fakeSession);
      addTearDown(container.dispose);

      // ACT
      final result = await container.read(
        commerceSitesStateControllerProvider(testEnterpriseCode).future,
      );

      // ASSERT
      expect(result, fakeSites);
      verify(
        () => mockRepository.getCommerceSites(
          EcRequestParams(
            workingUrl: fakeSession.enterprise!.workingUrl!,
            user: fakeSession.user.name!,
            accessKey: fakeSession.user.AccessKey!,
          ),
          testEnterpriseCode,
        ),
      ).called(1);
    });

    test('should throw AppException when session is invalid', () async {
      // ARRANGE
      final container = makeProviderContainer();
      addTearDown(container.dispose);

      // ACT & ASSERT
      await expectLater(
        container.read(
          commerceSitesStateControllerProvider(testEnterpriseCode).future,
        ),
        throwsA(
          isA<AppException>().having(
            (e) => e.message,
            'message',
            equals('Sessão inválida.'),
          ),
        ),
      );

      verifyNever(() => mockRepository.getCommerceSites(any(), any()));
    });
  });
}
