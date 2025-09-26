import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/repositories/stock/stock.dart';
import 'package:celta_intelligence/core/presentation/controllers/stock/confirm_adjust_stock_controller.dart';
import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_intelligence/core/providers/stock/stock.dart';
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
            baseUrl: any(named: 'baseUrl'),
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
            baseUrl: fakeSession.enterprise!.baseUrl!,
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
          baseUrl: fakeSession.enterprise!.baseUrl!,
          crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
          items: items,
        ),
      );
    });
  });
}
