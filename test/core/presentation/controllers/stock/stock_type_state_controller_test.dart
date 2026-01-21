import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/repositories/stock/stock.dart';
import 'package:celta_inventario/core/presentation/controllers/stock/stock.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/core/providers/stock/stock.dart';
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
          () => mockRepository.load(
            workingUrl: any(named: 'workingUrl'),
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
            workingUrl: fakeSession.enterprise!.workingUrl!,
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
          ),
        ).called(1);
      },
    );
  });
}
