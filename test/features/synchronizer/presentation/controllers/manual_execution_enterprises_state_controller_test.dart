// test/features/synchronizer/presentation/controllers/manual_execution_enterprises_state_controller_test.dart
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/enterprises/enterprises.dart';
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

class MockEcSynchronizerManualExecutionRepository extends Mock
    implements IEcSynchronizerManualExecutionRepository {}

void main() {
  late MockEcSynchronizerManualExecutionRepository mockRepository;
  late UserSessionModel fakeSession;

  setUp(() {
    mockRepository = MockEcSynchronizerManualExecutionRepository();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    registerFallbackValue(
      const EcRequestParams(workingUrl: '', user: '', accessKey: ''),
    );
    registerFallbackValue(
      const SearchManualExecutionEnterprisesParamsEntity(
        enterpriseCodes: [123],
      ),
    );
  });

  ProviderContainer makeProviderContainer({
    UserSessionModel? session,
    List<EnterpriseEntity>? enterprises,
  }) {
    return ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        ecSynchronizerManualExecutionRepositoryProvider.overrideWithValue(
          mockRepository,
        ),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
        enterprisesStateControllerProvider().overrideWith(
          () => FakeEnterprisesStateController(
            enterprises ??
                (session?.enterprise != null
                    ? [session!.enterprise!.toEntity()]
                    : []),
          ),
        ),
      ],
    );
  }

  group('ManualExecutionEnterprisesStateController', () {
    test(
      'should return list of manual execution enterprises on success',
      () async {
        // ARRANGE
        final fakeEnterprise = EntityFactory.makeEnterpriseEntity();
        final searchParamsEntity =
            SearchManualExecutionEnterprisesParamsEntity(
          enterpriseCodes: [fakeEnterprise.Code!],
        );
        const fakeEnterprises = <ManualExecutionEnterpriseEntity>[
          ManualExecutionEnterpriseEntity(code: 123, name: 'Test Enterprise'),
        ];

        when(
          () => mockRepository.searchManualExecutionEnterprises(
            any(),
            searchParamsEntity,
          ),
        ).thenAnswer((_) async => fakeEnterprises);

        final container = makeProviderContainer(
          session: fakeSession,
          enterprises: [fakeEnterprise],
        );
        addTearDown(container.dispose);

        // ACT
        final result = await container.read(
          manualExecutionEnterprisesStateControllerProvider.future,
        );

        // ASSERT
        expect(result, fakeEnterprises);
        verify(
          () => mockRepository.searchManualExecutionEnterprises(
            EcRequestParams(
              workingUrl: fakeSession.enterprise!.workingUrl!,
              user: fakeSession.user.name!,
              accessKey: fakeSession.user.AccessKey!,
            ),
            searchParamsEntity,
          ),
        ).called(1);
      },
    );

    test('should throw AppException when session is invalid', () async {
      // ARRANGE
      final container = makeProviderContainer();
      addTearDown(container.dispose);

      // ACT & ASSERT
      await expectLater(
        container.read(
          manualExecutionEnterprisesStateControllerProvider.future,
        ),
        throwsA(
          isA<AppException>().having(
            (e) => e.message,
            'message',
            equals('Sessão inválida.'),
          ),
        ),
      );

      verifyNever(
        () => mockRepository.searchManualExecutionEnterprises(any(), any()),
      );
    });
  });
}
