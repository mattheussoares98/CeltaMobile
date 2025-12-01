import 'dart:async';

import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_intelligence/features/receipt/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/receipt/domain/entity/entity.dart';
import 'package:celta_intelligence/features/receipt/presentation/pages/controllers/controllers.dart';
import 'package:celta_intelligence/features/receipt/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';

import '../../../../../mocks/mocks.dart';

class MockSoapUpdateObservationsDatasource extends Mock
    implements ISoapUpdateObservationsDatasource {}

// Spy for the ReceiptsStateController (the side-effect dependency)
class SpyReceiptsStateController extends ReceiptsStateController {
  String? capturedObservations;
  int? capturedDocCode;

  @override
  FutureOr<List<ReceiptEntity>> build(int enterpriseCode) async => [];

  @override
  // This is the method we spy on
  Future<void> updateObservationsLocally(
    String observations,
    int CodigoInterno_ProcRecebDoc,
  ) async {
    capturedObservations = observations;
    capturedDocCode = CodigoInterno_ProcRecebDoc;
  }
}

void main() {
  late MockSoapUpdateObservationsDatasource mockUpdateDatasource;
  late SpyReceiptsStateController spyReceiptsController;

  late UserSessionModel fakeSession;

  late int fakeEnterpriseCode;
  late int fakeDocCode;
  late String fakeObservations;

  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
    addTearDown(container.dispose);

    mockUpdateDatasource = MockSoapUpdateObservationsDatasource();
    spyReceiptsController = SpyReceiptsStateController();

    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakeEnterpriseCode = faker.randomGenerator.integer(100);
    fakeDocCode = faker.randomGenerator.integer(100);
    fakeObservations = faker.lorem.sentence();
  });

  ProviderContainer makeProviderContainer({
    UserSessionModel? session,
    int? enterpriseCodeForSpy,
  }) {
    // Determine the enterprise code for the ReceiptsStateController family override
    final actualEnterpriseCode = enterpriseCodeForSpy ?? fakeEnterpriseCode;

    return ProviderContainer(
      overrides: [
        soapUpdateObservationsDatasourceProvider.overrideWithValue(
          mockUpdateDatasource,
        ),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
        // Override the ReceiptsStateController with the spy instance
        receiptsStateControllerProvider(
          actualEnterpriseCode,
        ).overrideWith(() => spyReceiptsController),
      ],
    );
  }

  group('SelectedIndexUpdateCommnentStateController', () {
    test('build should have an initial state of null', () {
      // ARRANGE / ACT
      // Since build is synchronous, we read the current value (or default).
      final state = container.read(
        selectedIndexUpdateCommnentStateControllerProvider,
      );

      // ASSERT
      expect(state, isNull);
    });

    test('update should set the state to the new index', () async {
      // ARRANGE
      final newIndex = faker.randomGenerator.integer(100);
      final notifier = container.read(
        selectedIndexUpdateCommnentStateControllerProvider.notifier,
      );

      final states = <int?>[];
      // Listen to capture the state change
      container.listen(
        selectedIndexUpdateCommnentStateControllerProvider,
        (_, next) => states.add(next.value),
      );

      // ACT
      notifier.updateSelectedIndex(newIndex);

      // ASSERT
      // 1. Verify the state transition list
      expect(states, [newIndex]);

      // 2. Verify the final state value
      expect(
        container.read(selectedIndexUpdateCommnentStateControllerProvider),
        newIndex,
      );
    });

    test(
      'update should toggle state back to null if called with the same index',
      () async {
        // ARRANGE
        const indexToToggle = 10;
        final notifier = container.read(
          selectedIndexUpdateCommnentStateControllerProvider.notifier,
        );

        // Set the initial selection (pre-condition)
        notifier.updateSelectedIndex(indexToToggle);

        final states = <int?>[];
        container.listen(
          selectedIndexUpdateCommnentStateControllerProvider,
          (_, next) => states.add(next.value),
        );

        // ACT: Call the update method with the *same* value
        notifier.updateSelectedIndex(indexToToggle);

        // ASSERT
        // The state transitions from 10 back to null
        expect(states, [isNull]);
        expect(
          container.read(selectedIndexUpdateCommnentStateControllerProvider),
          isNull,
        );
      },
    );

    test(
      'update should change state to a new index if a different one is already selected',
      () async {
        // ARRANGE
        const initialIndex = 1;
        const newIndex = 2;
        final notifier = container.read(
          selectedIndexUpdateCommnentStateControllerProvider.notifier,
        );

        // Set initial selection
        notifier.updateSelectedIndex(initialIndex);

        final states = <int?>[];
        container.listen(
          selectedIndexUpdateCommnentStateControllerProvider,
          (_, next) => states.add(next.value),
        );

        // ACT: Call update with a *different* index
        notifier.updateSelectedIndex(newIndex);

        // ASSERT
        // State transitions from 1 to 2
        expect(states, [newIndex]);
        expect(
          container.read(selectedIndexUpdateCommnentStateControllerProvider),
          newIndex,
        );
      },
    );
    group('updateObservations', () {
      test(
        'should call datasource and trigger local update on success',
        () async {
          // ARRANGE
          when(
            () => mockUpdateDatasource.update(
              baseUrl: any(named: 'baseUrl'),
              crossIdentity: any(named: 'crossIdentity'),
              CodigoInterno_ProcRecebDoc: any(
                named: 'CodigoInterno_ProcRecebDoc',
              ),
              observations: any(named: 'observations'),
            ),
          ).thenAnswer((_) async {
            await Future.delayed(Duration.zero);
          });

          final container = makeProviderContainer(session: fakeSession);
          addTearDown(container.dispose);

          await container.read(
            selectedIndexUpdateCommnentStateControllerProvider.future,
          );

          final states = <AsyncValue<void>>[];
          container.listen(
            selectedIndexUpdateCommnentStateControllerProvider,
            (_, next) => states.add(next),
          );

          // ACT
          await container
              .read(selectedIndexUpdateCommnentStateControllerProvider.notifier)
              .updateObservations(
                enterpriseCode: fakeEnterpriseCode,
                observations: fakeObservations,
                CodigoInterno_ProcRecebDoc: fakeDocCode,
              );

          // ASSERT
          // 1. Check state transitions (Loading -> Data)
          expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);

          // 2. Verify remote datasource was called
          verify(
            () => mockUpdateDatasource.update(
              baseUrl: fakeSession.enterprise!.baseUrl!,
              crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
              CodigoInterno_ProcRecebDoc: fakeDocCode,
              observations: fakeObservations,
            ),
          ).called(1);

          // 3. Verify side-effect: local update was called
          expect(spyReceiptsController.capturedObservations, fakeObservations);
          expect(spyReceiptsController.capturedDocCode, fakeDocCode);
        },
      );

      test('should emit [loading, error] when session is invalid', () async {
        // ARRANGE
        final container = makeProviderContainer(session: null);
        addTearDown(container.dispose);

        await container.read(
          selectedIndexUpdateCommnentStateControllerProvider.future,
        );

        final states = <AsyncValue<void>>[];
        container.listen(
          selectedIndexUpdateCommnentStateControllerProvider,
          (_, next) => states.add(next),
        );

        // ACT
        await container
            .read(selectedIndexUpdateCommnentStateControllerProvider.notifier)
            .updateObservations(
              enterpriseCode: fakeEnterpriseCode,
              observations: fakeObservations,
              CodigoInterno_ProcRecebDoc: fakeDocCode,
            );

        // ASSERT
        expect(states.last, isA<AsyncError>());

        // Verify remote datasource was never called
        verifyNever(
          () => mockUpdateDatasource.update(
            baseUrl: any(named: 'baseUrl'),
            crossIdentity: any(named: 'crossIdentity'),
            CodigoInterno_ProcRecebDoc: any(
              named: 'CodigoInterno_ProcRecebDoc',
            ),
            observations: any(named: 'observations'),
          ),
        );
      });
    });
  });
}
