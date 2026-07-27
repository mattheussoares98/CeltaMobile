import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/app_usage/app_usage.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/exceptions/app_exception.dart';
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
  late DateTime initialDate;
  late FakeAppUsageStateController fakeAppUsage;

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
    initialDate = faker.date.dateTime();
    fakeAppUsage = FakeAppUsageStateController();
  });

  setUpAll(() {
    registerFallbackValue(
      LoadShallowBuyMovementParams(
        requestParams: EntityFactory.makeEcRequestParams(),
        selectedDate: DateTime.now(),
        finalDate: DateTime.now(),
        enterpriseCode: 0,
      ),
    );
  });

  ProviderContainer makeProviderContainer() {
    return ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        ecBuyMovementRepositoryProvider.overrideWithValue(repository),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
        appUsageStateControllerProvider.overrideWith(() => fakeAppUsage),
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
            selectedDate: initialDate,
            finalDate: initialDate.add(const Duration(days: 90)),
            enterpriseCode: enterpriseCode,
          ),
        ),
      );
    });

    test('load should request and expose shallow buy movements', () async {
      final params = LoadShallowBuyMovementParams(
        requestParams: requestParams,
        selectedDate: initialDate,
        finalDate: initialDate.add(const Duration(days: 89)),
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
          .load(initialDate, params.finalDate);

      expect(
        container.read(
          shallowBuyMovementStateControllerProvider(enterpriseCode),
        ),
        AsyncData<List<EcBuyMovementDtoEntity>?>(buyMovements),
      );
      expect(fakeAppUsage.lastUsageType, UsageType.shallowBuyMovement);
      verify(() => repository.loadShallow(params)).called(1);
    });

    test('load should expose repository errors', () async {
      final exception = Exception(faker.lorem.sentence());
      final params = LoadShallowBuyMovementParams(
        requestParams: requestParams,
        selectedDate: initialDate,
        finalDate: initialDate.add(const Duration(days: 90)),
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
          .load(initialDate, params.finalDate);

      final state = container.read(
        shallowBuyMovementStateControllerProvider(enterpriseCode),
      );
      expect(state, isA<AsyncError<List<EcBuyMovementDtoEntity>?>>());
      expect(state.error, same(exception));
      verify(() => repository.loadShallow(params)).called(1);
    });

    test('should throw when the date difference is 91 days', () async {
      final container = makeProviderContainer();
      addTearDown(container.dispose);

      when(() => repository.loadShallow(any())).thenAnswer((_) async => []);

      final states = <AsyncValue<List<EcBuyMovementDtoEntity>?>>[];
      container.listen(
        shallowBuyMovementStateControllerProvider(enterpriseCode),
        (_, next) => states.add(next),
        fireImmediately: true,
      );

      await expectLater(
        container
            .read(
              shallowBuyMovementStateControllerProvider(
                enterpriseCode,
              ).notifier,
            )
            .load(initialDate, initialDate.add(const Duration(days: 91))),
        throwsA(isA<AppException>()),
      );
    });
  });
}
