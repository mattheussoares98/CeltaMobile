import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/repositories/stock/stock.dart';
import 'package:celta_intelligence/core/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/core/presentation/controllers/stock/stock.dart';
import 'package:celta_intelligence/core/providers/stock/stock.dart';
import 'package:celta_intelligence/exceptions/exceptions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockSoapStockTypeRepository extends Mock
    implements ISoapStockTypeRepository {}

void main() {
  late MockSoapStockTypeRepository mockRepository;
  late UserSessionModel fakeSession;
  late List<StockTypeEntity> fakeStockTypes;

  const enterpriseCode = 1;

  setUp(() {
    mockRepository = MockSoapStockTypeRepository();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakeStockTypes = [EntityFactory.makeStockTypeEntity()];
  });

  ProviderContainer makeProviderContainer({UserSessionModel? session}) {
    return ProviderContainer(
      overrides: [
        soapStockTypeRepositoryProvider.overrideWithValue(mockRepository),
        userSessionProvider.overrideWith(() => FakeUserSession(session)),
      ],
    );
  }

  group('StockTypeStateController', () {
    test(
      'should emit [loading, data] and call repository on success',
      () async {
        // ARRANGE
        when(
          () => mockRepository.load(
            baseUrl: any(named: 'baseUrl'),
            crossIdentity: any(named: 'crossIdentity'),
          ),
        ).thenAnswer((_) async => fakeStockTypes);

        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        final states = <AsyncValue<List<StockTypeEntity>>>[];
        container.listen(
          stockTypeStateControllerProvider(enterpriseCode),
          (_, next) => states.add(next),
          fireImmediately: true,
        );

        // ACT: Wait for the build method to complete
        await container.read(
          stockTypeStateControllerProvider(enterpriseCode).future,
        );

        // ASSERT
        expect(states, [
          isA<AsyncLoading>(),
          isA<AsyncData<List<StockTypeEntity>>>(),
        ]);
        verify(
          () => mockRepository.load(
            baseUrl: fakeSession.enterprise.baseUrl!,
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
          ),
        ).called(1);
      },
    );

    test('should emit [loading, error] when session is null', () async {
      // ARRANGE: Pass null for the session to simulate a failure condition.
      final container = makeProviderContainer(session: null);
      addTearDown(container.dispose);

      final states = <AsyncValue<List<StockTypeEntity>>>[];
      container.listen(
        stockTypeStateControllerProvider(enterpriseCode),
        (_, next) => states.add(next),
        fireImmediately: true,
      );

      // ACT & ASSERT: Expect the future to complete with an AppException
      await expectLater(
        container.read(stockTypeStateControllerProvider(enterpriseCode).future),
        throwsA(isA<AppException>()),
      );

      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
      // Verify the repository was never called because the session was invalid
      verifyNever(
        () => mockRepository.load(
          baseUrl: any(named: 'baseUrl'),
          crossIdentity: any(named: 'crossIdentity'),
        ),
      );
    });
  });
}
