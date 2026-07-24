import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/buy_movement/domain/entities/entities.dart';
import 'package:celta_inventario/features/buy_movement/domain/repositories/repositories.dart';
import 'package:celta_inventario/features/buy_movement/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/buy_movement/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockEcBuyMovementRepository extends Mock
    implements IEcBuyMovementRepository {}

void main() {
  late MockEcBuyMovementRepository repository;
  late UserSessionModel session;
  late EcRequestParams requestParams;
  late List<EcBuyMovementDtoEntity> buyMovements;
  late int enterpriseCode;
  late DateTime selectedDate;

  setUp(() {
    repository = MockEcBuyMovementRepository();
    session = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    requestParams = EcRequestParams(
      workingUrl: session.enterprise!.workingUrl!,
      user: session.user.name!,
      accessKey: session.user.AccessKey!,
    );
    buyMovements = List.generate(
      faker.randomGenerator.integer(3, min: 1),
      (_) => EntityFactory.makeEcBuyMovementDtoEntity(),
    );
    enterpriseCode = faker.randomGenerator.integer(100, min: 1);
    selectedDate = faker.date.dateTime();
  });

  ProviderContainer makeProviderContainer() {
    return ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        ecBuyMovementRepositoryProvider.overrideWithValue(repository),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
      ],
    );
  }

  group('ShallowBuyMovementStateController', () {
    test('build should return null before the first load', () async {
      final container = makeProviderContainer();
      addTearDown(container.dispose);

      final result = await container.read(
        shallowBuyMovementStateControllerProvider(enterpriseCode).future,
      );

      expect(result, isNull);
      verifyNever(
        () => repository.loadShallow(
          LoadShallowBuyMovementParams(
            requestParams: requestParams,
            selectedDate: selectedDate,
            finalDate: selectedDate.add(const Duration(days: 90)),
            enterpriseCode: enterpriseCode,
          ),
        ),
      );
    });

    test('load should request and expose shallow buy movements', () async {
      final params = LoadShallowBuyMovementParams(
        requestParams: requestParams,
        selectedDate: selectedDate,
        finalDate: selectedDate.add(const Duration(days: 90)),
        enterpriseCode: enterpriseCode,
      );
      when(
        () => repository.loadShallow(params),
      ).thenAnswer((_) async => buyMovements);
      final container = makeProviderContainer();
      addTearDown(container.dispose);
      await container.read(
        shallowBuyMovementStateControllerProvider(enterpriseCode).future,
      );

      await container
          .read(
            shallowBuyMovementStateControllerProvider(enterpriseCode).notifier,
          )
          .load(selectedDate);

      expect(
        container.read(
          shallowBuyMovementStateControllerProvider(enterpriseCode),
        ),
        AsyncData<List<EcBuyMovementDtoEntity>?>(buyMovements),
      );
      verify(() => repository.loadShallow(params)).called(1);
    });

    test('load should expose repository errors', () async {
      final exception = Exception(faker.lorem.sentence());
      final params = LoadShallowBuyMovementParams(
        requestParams: requestParams,
        selectedDate: selectedDate,
        finalDate: selectedDate.add(const Duration(days: 90)),
        enterpriseCode: enterpriseCode,
      );
      when(() => repository.loadShallow(params)).thenThrow(exception);
      final container = makeProviderContainer();
      addTearDown(container.dispose);
      await container.read(
        shallowBuyMovementStateControllerProvider(enterpriseCode).future,
      );

      await container
          .read(
            shallowBuyMovementStateControllerProvider(enterpriseCode).notifier,
          )
          .load(selectedDate);

      final state = container.read(
        shallowBuyMovementStateControllerProvider(enterpriseCode),
      );
      expect(state, isA<AsyncError<List<EcBuyMovementDtoEntity>?>>());
      expect(state.error, same(exception));
      verify(() => repository.loadShallow(params)).called(1);
    });
  });
}
