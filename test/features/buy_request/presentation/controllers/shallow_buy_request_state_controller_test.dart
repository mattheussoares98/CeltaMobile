// test/features/buy_request/presentation/controllers/shallow_buy_request_state_controller_test.dart
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/buy_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/buy_request/domain/repository/repository.dart';
import 'package:celta_inventario/features/buy_request/presentation/controllers/shallow_buy_request_state_controller.dart';
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
  late List<EcBuyRequestDtoEntity> fakeEntities;
  late int enterpriseCode;
  late DateTime selectedDate;
  late EcRequestParams expectedParams;

  setUpAll(() {
    registerFallbackValue(
      LoadShallowBuyRequestParams(
        requestParams: const EcRequestParams(
          workingUrl: '',
          user: '',
          accessKey: '',
        ),
        selectedDate: DateTime(2026),
        enterpriseCode: 0,
      ),
    );
  });

  setUp(() {
    mockRepository = MockEcBuyRequestRepository();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakeEntities = [
      EntityFactory.makeEcBuyRequestDtoEntity(),
      EntityFactory.makeEcBuyRequestDtoEntity(),
    ];
    enterpriseCode = faker.randomGenerator.integer(100);
    selectedDate = DateTime(2026, 7, 20);

    expectedParams = EcRequestParams(
      workingUrl: fakeSession.enterprise!.workingUrl!,
      user: fakeSession.user.name!,
      accessKey: fakeSession.user.AccessKey!,
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

  group('ShallowBuyRequestStateController', () {
    test('should build with empty list initially', () async {
      final container = makeProviderContainer();
      addTearDown(container.dispose);

      final result = container.read(
        shallowBuyRequestStateControllerProvider(enterpriseCode),
      );

      expect(result.value, isEmpty);
    });

    test('should load shallow buy requests successfully', () async {
      final container = makeProviderContainer();
      addTearDown(container.dispose);

      final expectedLoadParams = LoadShallowBuyRequestParams(
        requestParams: expectedParams,
        selectedDate: selectedDate,
        enterpriseCode: enterpriseCode,
      );

      when(
        () => mockRepository.loadShallow(any()),
      ).thenAnswer((_) async => fakeEntities);

      // Listen to the provider to keep it alive and capture states
      final states = <AsyncValue<List<EcBuyRequestDtoEntity>>>[];
      container.listen(
        shallowBuyRequestStateControllerProvider(enterpriseCode),
        (_, next) => states.add(next),
        fireImmediately: true,
      );

      // Initial state is empty data
      expect(states.first.value, isEmpty);

      // Trigger the load action
      await container
          .read(
            shallowBuyRequestStateControllerProvider(enterpriseCode).notifier,
          )
          .load(selectedDate);

      // Verify states transitions: loading, then data(fakeEntities)
      expect(states, [
        isA<AsyncData<List<EcBuyRequestDtoEntity>>>(),
        isA<AsyncLoading<List<EcBuyRequestDtoEntity>>>(),
        isA<AsyncData<List<EcBuyRequestDtoEntity>>>(),
      ]);

      expect(states[2].value, equals(fakeEntities));
      expect(
        container
            .read(shallowBuyRequestStateControllerProvider(enterpriseCode))
            .value,
        fakeEntities,
      );
      verify(() => mockRepository.loadShallow(expectedLoadParams)).called(1);
    });

    test('should set state to error when load fails', () async {
      final container = makeProviderContainer();
      addTearDown(container.dispose);

      final exception = Exception('Failed to load buy requests');

      when(() => mockRepository.loadShallow(any())).thenThrow(exception);

      final states = <AsyncValue<List<EcBuyRequestDtoEntity>>>[];
      container.listen(
        shallowBuyRequestStateControllerProvider(enterpriseCode),
        (_, next) => states.add(next),
        fireImmediately: true,
      );

      await container
          .read(
            shallowBuyRequestStateControllerProvider(enterpriseCode).notifier,
          )
          .load(selectedDate);

      expect(states, [
        isA<AsyncData<List<EcBuyRequestDtoEntity>>>(),
        isA<AsyncLoading<List<EcBuyRequestDtoEntity>>>(),
        isA<AsyncError<List<EcBuyRequestDtoEntity>>>(),
      ]);
    });
  });
}
