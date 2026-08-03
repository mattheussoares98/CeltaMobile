import 'dart:async';

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

void main() {
  late MockEcSynchronizerRepository mockRepository;
  late UserSessionModel fakeSession;

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
      ],
    );
  }

  group('SynchronizerCountStateController', () {
    test('should return count summary list on success', () async {
      // ARRANGE
      final summaryList = <SynchronizerErrorSummaryEntity>[];
      when(
        () => mockRepository.searchCount(any()),
      ).thenAnswer((_) async => summaryList);

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
        synchronizerCountStateControllerProvider.future,
      );

      // ASSERT
      expect(result, summaryList);
      verify(
        () => mockRepository.searchCount(
          EcRequestParams(
            workingUrl: fakeSession.enterprise!.workingUrl!,
            user: fakeSession.user.name!,
            accessKey: fakeSession.user.AccessKey!,
          ),
        ),
      ).called(1);
    });

    test('refreshSilently should keep data while refreshing', () async {
      // ARRANGE
      const initialData = <SynchronizerErrorSummaryEntity>[];
      final refreshedData = [
        EntityFactory.makeSynchronizerErrorSummaryEntity(),
      ];
      final refreshCompleter =
          Completer<List<SynchronizerErrorSummaryEntity>>();
      var searchCountCallCount = 0;
      final expectedParams = EcRequestParams(
        workingUrl: fakeSession.enterprise!.workingUrl!,
        user: fakeSession.user.name!,
        accessKey: fakeSession.user.AccessKey!,
      );
      when(() => mockRepository.searchCount(expectedParams)).thenAnswer((_) {
        searchCountCallCount++;
        return searchCountCallCount == 1
            ? Future.value(initialData)
            : refreshCompleter.future;
      });

      final container = makeProviderContainer(session: fakeSession);
      addTearDown(container.dispose);
      await container.read(
        canAccessResourceStateControllerProvider(
          BsRoutine.generic,
          BsResource.synchronizer,
        ).future,
      );
      await container.read(synchronizerCountStateControllerProvider.future);

      // ACT
      final refresh = container
          .read(synchronizerCountStateControllerProvider.notifier)
          .refreshSilently();

      // ASSERT
      expect(
        container.read(synchronizerCountStateControllerProvider),
        const AsyncData(initialData),
      );
      refreshCompleter.complete(refreshedData);
      await refresh;
      expect(
        container.read(synchronizerCountStateControllerProvider),
        AsyncData(refreshedData),
      );
      verify(() => mockRepository.searchCount(expectedParams)).called(2);
    });

    test('refreshSilently should keep data when refreshing fails', () async {
      // ARRANGE
      const initialData = <SynchronizerErrorSummaryEntity>[];
      var searchCountCallCount = 0;
      final expectedParams = EcRequestParams(
        workingUrl: fakeSession.enterprise!.workingUrl!,
        user: fakeSession.user.name!,
        accessKey: fakeSession.user.AccessKey!,
      );
      when(() => mockRepository.searchCount(expectedParams)).thenAnswer((_) {
        searchCountCallCount++;
        if (searchCountCallCount == 1) return Future.value(initialData);
        throw Exception('Refresh failed');
      });

      final container = makeProviderContainer(session: fakeSession);
      addTearDown(container.dispose);
      await container.read(
        canAccessResourceStateControllerProvider(
          BsRoutine.generic,
          BsResource.synchronizer,
        ).future,
      );
      await container.read(synchronizerCountStateControllerProvider.future);

      // ACT
      await container
          .read(synchronizerCountStateControllerProvider.notifier)
          .refreshSilently();

      // ASSERT
      expect(
        container.read(synchronizerCountStateControllerProvider),
        const AsyncData(initialData),
      );
      verify(() => mockRepository.searchCount(expectedParams)).called(2);
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
        container.read(synchronizerCountStateControllerProvider.future),
        throwsA(
          isA<AppException>().having(
            (e) => e.message,
            'message',
            equals('Sessão inválida.'),
          ),
        ),
      );

      verifyNever(() => mockRepository.searchCount(any()));
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
          container.read(synchronizerCountStateControllerProvider.future),
          throwsA(
            isA<AppException>().having(
              (e) => e.message,
              'message',
              equals('Usuário sem permissão para acessar este módulo'),
            ),
          ),
        );

        verifyNever(() => mockRepository.searchCount(any()));
      },
    );
  });
}
