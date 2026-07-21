// test/features/buy_request/presentation/controllers/shallow_buy_request_state_controller_test.dart
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/buy_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/buy_request/domain/repository/repository.dart';
import 'package:celta_inventario/features/buy_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/buy_request/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockEcBuyRequestRepository extends Mock
    implements IEcBuyRequestRepository {}

void main() {
  late MockEcBuyRequestRepository mockRepository;
  late UserSessionModel fakeSession;
  late EcBuyRequestDtoEntity fakeEntity;
  late LoadBuyRequestDetailsParams params;

  setUpAll(() {
    registerFallbackValue(
      LoadBuyRequestDetailsParams(
        requestParams: EntityFactory.makeEcRequestParams(),
        buyRequestCode: 0,
      ),
    );
  });

  setUp(() {
    mockRepository = MockEcBuyRequestRepository();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakeEntity = EntityFactory.makeEcBuyRequestDtoEntity();

    params = LoadBuyRequestDetailsParams(
      requestParams: EcRequestParams(
        workingUrl: fakeSession.enterprise!.workingUrl!,
        user: fakeSession.user.name!,
        accessKey: fakeSession.user.AccessKey!,
      ),
      buyRequestCode: faker.randomGenerator.integer(100),
    );
  });

  ProviderContainer makeProviderContainer() {
    return ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        ecBuyRequestRepositoryProvider.overrideWithValue(mockRepository),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(fakeSession),
        ),
      ],
    );
  }

  group('BuyRequestDetailsStateController', () {
    test('BUILD: should load buy request details', () async {
      final container = makeProviderContainer();
      addTearDown(container.dispose);

      when(
        () => mockRepository.loadDetails(any()),
      ).thenAnswer((_) async => fakeEntity);

      // Listen to the provider to keep it alive and capture states
      final states = <AsyncValue<EcBuyRequestDtoEntity?>>[];
      container.listen(
        buyRequestDetailsStateControllerProvider(params.buyRequestCode),
        (_, next) => states.add(next),
      );

      // Trigger the load action
      await container.read(
        buyRequestDetailsStateControllerProvider(params.buyRequestCode).future,
      );

      final updatedState = await container.read(
        buyRequestDetailsStateControllerProvider(params.buyRequestCode).future,
      );

      expect(updatedState, fakeEntity);
      verify(() => mockRepository.loadDetails(params)).called(1);
    });

    test('BUILD: should set state to error when load fails', () async {
      final container = makeProviderContainer();
      addTearDown(container.dispose);

      final exception = Exception('Failed to load buy requests');

      when(() => mockRepository.loadDetails(any())).thenThrow(exception);

      final states = <AsyncValue<EcBuyRequestDtoEntity?>>[];
      container.listen(
        buyRequestDetailsStateControllerProvider(params.buyRequestCode),
        (_, next) => states.add(next),
        fireImmediately: true,
      );

      expectLater(
        container.read(
          buyRequestDetailsStateControllerProvider(
            params.buyRequestCode,
          ).future,
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}
