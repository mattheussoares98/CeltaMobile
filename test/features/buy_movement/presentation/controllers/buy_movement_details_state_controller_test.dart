import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/app_usage/app_usage.dart';
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
  late EcBuyMovementDtoEntity buyMovement;
  late int buyMovementCode;
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
    buyMovement = EntityFactory.makeEcBuyMovementDtoEntity();
    buyMovementCode = faker.randomGenerator.integer(100, min: 1);
    fakeAppUsage = FakeAppUsageStateController();
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

  group('BuyMovementDetailsStateController', () {
    test('build should load and return the requested buy movement', () async {
      final params = LoadBuyMovementDetailsParams(
        requestParams: requestParams,
        buyMovementCode: buyMovementCode,
      );
      when(
        () => repository.loadDetails(params),
      ).thenAnswer((_) async => buyMovement);
      final container = makeProviderContainer();
      addTearDown(container.dispose);

      final result = await container.read(
        buyMovementDetailsStateControllerProvider(buyMovementCode).future,
      );

      expect(result, buyMovement);
      expect(fakeAppUsage.lastUsageType, UsageType.buyMovementDetails);
      verify(() => repository.loadDetails(params)).called(1);
    });

    test('build should propagate repository errors', () async {
      final exception = Exception(faker.lorem.sentence());
      final params = LoadBuyMovementDetailsParams(
        requestParams: requestParams,
        buyMovementCode: buyMovementCode,
      );
      when(() => repository.loadDetails(params)).thenThrow(exception);
      final container = makeProviderContainer();
      addTearDown(container.dispose);

      await expectLater(
        container.read(
          buyMovementDetailsStateControllerProvider(buyMovementCode).future,
        ),
        throwsA(same(exception)),
      );
      verify(() => repository.loadDetails(params)).called(1);
    });
  });
}
