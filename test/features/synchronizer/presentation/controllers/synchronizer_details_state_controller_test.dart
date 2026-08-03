import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/resource/resource.dart';
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

class MockEcSynchronizerRepository extends Mock
    implements IEcSynchronizerRepository {}

class FakeCanAccessResourceStateController
    extends CanAccessResourceStateController {
  final bool hasAccess;
  FakeCanAccessResourceStateController(this.hasAccess);

  @override
  Future<bool> build(BsRoutine routine, BsResource resource) async {
    return hasAccess;
  }
}

class FakeSynchronizerCountStateController
    extends SynchronizerCountStateController {
  int buildCount = 0;

  @override
  Future<List<SynchronizerErrorSummaryEntity>> build() async {
    buildCount++;
    return [];
  }
}

void main() {
  late MockEcSynchronizerRepository mockRepository;
  late UserSessionModel fakeSession;
  const testKey = 'PRODUCT_WITH_ERROR';

  setUp(() {
    mockRepository = MockEcSynchronizerRepository();
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
    FakeSynchronizerCountStateController? countController,
  }) {
    return ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        ecSynchronizerRepositoryProvider.overrideWithValue(mockRepository),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
        canAccessResourceStateControllerProvider(
          BsRoutine.generic,
          BsResource.synchronizer,
        ).overrideWith(() => FakeCanAccessResourceStateController(hasAccess)),
        if (countController != null)
          synchronizerCountStateControllerProvider.overrideWith(
            () => countController,
          ),
      ],
    );
  }

  group('SynchronizerDetailsStateController', () {
    test('should return details entity on success', () async {
      // ARRANGE
      const fakeDetails = SynchronizerErrorDetailsEntity(
        category: 'Produtos com erro',
        errorKey: testKey,
        detailType: SynchronizerErrorDetailType.productWithError,
        items: [],
      );

      when(
        () => mockRepository.searchByKey(any(), testKey),
      ).thenAnswer((_) async => fakeDetails);

      final container = makeProviderContainer(session: fakeSession);
      addTearDown(container.dispose);

      await container.read(
        canAccessResourceStateControllerProvider(
          BsRoutine.generic,
          BsResource.synchronizer,
        ).future,
      );

      // ACT
      final result = await container.read(
        synchronizerDetailsStateControllerProvider(testKey).future,
      );

      // ASSERT
      expect(result, fakeDetails);
      verify(
        () => mockRepository.searchByKey(
          EcRequestParams(
            workingUrl: fakeSession.enterprise!.workingUrl!,
            user: fakeSession.user.name!,
            accessKey: fakeSession.user.AccessKey!,
          ),
          testKey,
        ),
      ).called(1);
    });

    test('should invalidate synchronizer count provider', () async {
      // ARRANGE
      const fakeDetails = SynchronizerErrorDetailsEntity(
        category: 'Produtos com erro',
        errorKey: testKey,
        detailType: SynchronizerErrorDetailType.productWithError,
        items: [],
      );
      final countController = FakeSynchronizerCountStateController();
      when(
        () => mockRepository.searchByKey(any(), testKey),
      ).thenAnswer((_) async => fakeDetails);
      final container = makeProviderContainer(
        session: fakeSession,
        countController: countController,
      );
      addTearDown(container.dispose);

      await container.read(
        canAccessResourceStateControllerProvider(
          BsRoutine.generic,
          BsResource.synchronizer,
        ).future,
      );
      await container.read(synchronizerCountStateControllerProvider.future);
      expect(countController.buildCount, 1);

      // ACT
      await container.read(
        synchronizerDetailsStateControllerProvider(testKey).future,
      );

      // ASSERT
      await container.read(synchronizerCountStateControllerProvider.future);
      expect(countController.buildCount, 2);
    });

    test('should throw AppException when session is invalid', () async {
      // ARRANGE
      final container = makeProviderContainer();
      addTearDown(container.dispose);

      await container.read(
        canAccessResourceStateControllerProvider(
          BsRoutine.generic,
          BsResource.synchronizer,
        ).future,
      );

      // ACT & ASSERT
      await expectLater(
        container.read(
          synchronizerDetailsStateControllerProvider(testKey).future,
        ),
        throwsA(
          isA<AppException>().having(
            (e) => e.message,
            'message',
            equals('Sessão inválida.'),
          ),
        ),
      );

      verifyNever(() => mockRepository.searchByKey(any(), any()));
    });

    test(
      'should throw AppException with permission error when user has no resource access',
      () async {
        // ARRANGE
        final container = makeProviderContainer(
          session: fakeSession,
          hasAccess: false,
        );
        addTearDown(container.dispose);

        await container.read(
          canAccessResourceStateControllerProvider(
            BsRoutine.generic,
            BsResource.synchronizer,
          ).future,
        );

        // ACT & ASSERT
        await expectLater(
          container.read(
            synchronizerDetailsStateControllerProvider(testKey).future,
          ),
          throwsA(
            isA<AppException>().having(
              (e) => e.message,
              'message',
              equals('Usuário sem permissão para acessar este módulo'),
            ),
          ),
        );

        verifyNever(() => mockRepository.searchByKey(any(), any()));
      },
    );
  });
}
