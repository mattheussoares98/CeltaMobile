import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/repositories/stock/stock.dart';
import 'package:celta_intelligence/core/presentation/controllers/stock/confirm_adjust_stock_controller.dart';
import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_intelligence/core/providers/stock/stock.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockSoapAdjustStockRepository extends Mock
    implements ISoapAdjustStockRepository {}

void main() {
  late MockSoapAdjustStockRepository mockRepository;
  late UserSessionModel fakeSession;
  late List<AdjustStockItemEntity> items;

  setUp(() {
    mockRepository = MockSoapAdjustStockRepository();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    items = [
      EntityFactory.makeAdjustStockItemEntity(),
      EntityFactory.makeAdjustStockItemEntity(),
      EntityFactory.makeAdjustStockItemEntity(),
    ];
  });

  ProviderContainer makeProviderContainer({UserSessionModel? session}) {
    return ProviderContainer(
      overrides: [
        soapAdjustStockRepositoryProvider.overrideWithValue(mockRepository),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
      ],
    );
  }

  group('StockTypeStateController', () {
    test(
      'should emit [loading, data] and call repository on success',
      () async {
        // ARRANGE
        when(
          () => mockRepository.confirm(
            workingUrl: any(named: 'workingUrl'),
            crossIdentity: any(named: 'crossIdentity'),
            items: any(named: 'items'),
          ),
        ).thenAnswer((_) async {});

        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        final states = <AsyncValue<void>>[];
        container.listen(
          confirmAdjustStockControllerProvider,
          (_, next) => states.add(next),
        );

        // ACT: Wait for the build method to complete
        await container
            .read(confirmAdjustStockControllerProvider.notifier)
            .confirm(items);

        // ASSERT
        expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
        verify(
          () => mockRepository.confirm(
            workingUrl: fakeSession.enterprise!.workingUrl!,
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            items: items,
          ),
        ).called(1);
      },
    );

    test('should emit [loading, error] when session is null', () async {
      // ARRANGE: Pass null for the session to simulate a failure condition.
      final container = makeProviderContainer(session: null);
      addTearDown(container.dispose);

      final states = <AsyncValue<void>>[];
      container.listen(
        confirmAdjustStockControllerProvider,
        (_, next) => states.add(next),
      );

      // ACT & ASSERT: Expect the future to complete with an AppException
      await container
          .read(confirmAdjustStockControllerProvider.notifier)
          .confirm(items);

      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
      // Verify the repository was never called because the session was invalid
      verifyNever(
        () => mockRepository.confirm(
          workingUrl: fakeSession.enterprise!.workingUrl!,
          crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
          items: items,
        ),
      );
    });
    test(
      'should return correct LastConfirmedAdjustEntity on confirm and has only one item in the list',
      () async {
        // ARRANGE: Pass null for the session to simulate a failure condition.
        when(
          () => mockRepository.confirm(
            workingUrl: any(named: 'workingUrl'),
            crossIdentity: any(named: 'crossIdentity'),
            items: any(named: 'items'),
          ),
        ).thenAnswer((_) async {});
        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        final states = <AsyncValue<void>>[];
        container.listen(
          confirmAdjustStockControllerProvider,
          (_, next) => states.add(next),
        );

        final operationType = OperationType
            .values[faker.randomGenerator.integer(OperationType.values.length)];

        // ACT & ASSERT: Expect the future to complete with an AppException
        await container.read(confirmAdjustStockControllerProvider.notifier).confirm(
          [items[0]],
          operationType: operationType,
        ); //return only when has one item in the list because is adjustStock feature. If has more than one, is transfer between stocks feature and this feature creates a lot

        expect(
          container.read(confirmAdjustStockControllerProvider).value,
          LastConfirmedAdjustEntity(
            productPackingCode: items[0].ProductPackingCode,
            quantity: items[0].Quantity,
            operationType: operationType,
          ),
        );
        expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
        // Verify the repository was never called because the session was invalid
        verify(
          () => mockRepository.confirm(
            workingUrl: fakeSession.enterprise!.workingUrl!,
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            items: [items[0]],
          ),
        ).called(1);
      },
    );
    test(
      'should NOT return LastConfirmedAdjustEntity on confirm and has more than one item in the list',
      () async {
        // ARRANGE: Pass null for the session to simulate a failure condition.
        when(
          () => mockRepository.confirm(
            workingUrl: any(named: 'workingUrl'),
            crossIdentity: any(named: 'crossIdentity'),
            items: any(named: 'items'),
          ),
        ).thenAnswer((_) async {});
        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        final states = <AsyncValue<void>>[];
        container.listen(
          confirmAdjustStockControllerProvider,
          (_, next) => states.add(next),
        );

        // ACT & ASSERT: Expect the future to complete with an AppException
        await container
            .read(confirmAdjustStockControllerProvider.notifier)
            .confirm(
              items,
            ); //return only when has one item in the list because is adjustStock feature. If has more than one, is transfer between stocks feature and this feature creates a lot

        expect(
          container.read(confirmAdjustStockControllerProvider).value,
          null,
        );
        expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
        // Verify the repository was never called because the session was invalid
        verify(
          () => mockRepository.confirm(
            workingUrl: fakeSession.enterprise!.workingUrl!,
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            items: items,
          ),
        ).called(1);
      },
    );
  });
}
