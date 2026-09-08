import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/app_usage/app_usage.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/sale_request/data/models/models.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/repository/repository.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../mocks/mocks.dart';

class MockecSaleRequestsRepository extends Mock
    implements IEcSaleRequestsRepository {}

void main() {
  late MockecSaleRequestsRepository mockRepository;
  late UserSessionModel fakeSession;
  late EcRequestParams params;
  late FakeAppUsageStateController fakeAppUsage;
  late BSFSaleRequestModel fakeBSFSaleRequestModel;
  late SaleRequestArgs fakeArgs;

  setUpAll(() {
    registerFallbackValue(DateTime.now());
    registerFallbackValue(EntityFactory.makeEcRequestParams());
  });

  setUp(() {
    mockRepository = MockecSaleRequestsRepository();

    // Generating a dynamic session via factory
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );

    fakeBSFSaleRequestModel = BSFSaleRequestModel.fromEntity(
      EntityFactory.makeBSFSaleRequestEntity(),
    );

    params = EcRequestParams(
      workingUrl: fakeSession.enterprise!.workingUrl!,
      user: fakeSession.user.name!,
      accessKey: fakeSession.user.AccessKey!,
    );
    fakeAppUsage = FakeAppUsageStateController();
    fakeArgs = SaleRequestArgs(
      customerCode: faker.randomGenerator.integer(100),
      saleRequestId: faker.randomGenerator.integer(100),
      enterpriseCode: faker.randomGenerator.integer(100),
    );
  });

  ProviderContainer makeProviderContainer({UserSessionModel? session}) {
    return ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        ecSaleRequestsRepositoryProvider.overrideWithValue(mockRepository),
        saleRequestArgsProvider.overrideWithValue(fakeArgs),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
        appUsageStateControllerProvider.overrideWith(() => fakeAppUsage),
      ],
    );
  }

  group('SaleRequestsStateController', () {
    test('Should return empty value if is inserting', () async {
      // ARRANGE

      when(
        () => mockRepository.getComplete(
          saleRequestCode: any(named: 'saleRequestCode'),
          enterpriseCode: any(named: 'enterpriseCode'),
          customerCode: any(named: 'customerCode'),
          params: any(named: 'params'),
        ),
      ).thenAnswer((_) async => fakeBSFSaleRequestModel.toEntity());

      final container = makeProviderContainer(session: fakeSession);
      addTearDown(container.dispose);

      final insertingArgs = SaleRequestArgs(
        enterpriseCode: faker.randomGenerator.integer(100),
        saleRequestId: 0,
      );

      final states = <AsyncValue<BSFSaleRequestEntity>>[];
      container.listen(
        saleRequestDetailsStateControllerProvider(insertingArgs),
        (_, next) => states.add(next),
      );

      // ACT
      await container.read(
        saleRequestDetailsStateControllerProvider(insertingArgs).future,
      );

      final state = container.read(
        saleRequestDetailsStateControllerProvider(insertingArgs),
      );
      expect(
        state,
        AsyncData<BSFSaleRequestEntity>(BSFSaleRequestEntity.empty()),
      );

      verifyNever(
        () => mockRepository.getComplete(
          saleRequestCode: any(named: 'saleRequestCode'),
          enterpriseCode: any(named: 'enterpriseCode'),
          customerCode: any(named: 'customerCode'),
          params: any(named: 'params'),
        ),
      );
    });
    test('Build should load and behave correctly', () async {
      // ARRANGE

      when(
        () => mockRepository.getComplete(
          saleRequestCode: any(named: 'saleRequestCode'),
          enterpriseCode: any(named: 'enterpriseCode'),
          customerCode: any(named: 'customerCode'),
          params: any(named: 'params'),
        ),
      ).thenAnswer((_) async => fakeBSFSaleRequestModel.toEntity());

      final container = makeProviderContainer(session: fakeSession);
      addTearDown(container.dispose);

      final states = <AsyncValue<BSFSaleRequestEntity>>[];
      container.listen(
        saleRequestDetailsStateControllerProvider(fakeArgs),
        (_, next) => states.add(next),
      );

      // ACT
      await container.read(
        saleRequestDetailsStateControllerProvider(fakeArgs).future,
      );

      final state = container.read(
        saleRequestDetailsStateControllerProvider(fakeArgs),
      );
      expect(
        state,
        AsyncData<BSFSaleRequestEntity>(fakeBSFSaleRequestModel.toEntity()),
      );

      verify(
        () => mockRepository.getComplete(
          saleRequestCode: fakeArgs.saleRequestId,
          enterpriseCode: fakeArgs.enterpriseCode,
          customerCode: fakeArgs.customerCode,
          params: params,
        ),
      ).called(1);

      expect(fakeAppUsage.lastUsageType, UsageType.completeSearchSaleRequest);
    });

    test('should throw through .future when repository fails', () async {
      // ARRANGE
      final exception = Exception('Direct throw test');
      when(
        () => mockRepository.getComplete(
          saleRequestCode: fakeArgs.saleRequestId,
          enterpriseCode: fakeArgs.enterpriseCode,
          customerCode: fakeArgs.customerCode,
          params: params,
        ),
      ).thenThrow(exception);

      final container = makeProviderContainer(session: fakeSession);
      addTearDown(container.dispose);

      // ACT & ASSERT
      await expectLater(
        container.read(
          saleRequestDetailsStateControllerProvider(fakeArgs).future,
        ),
        throwsA(equals(exception)),
      );

      verify(
        () => mockRepository.getComplete(
          saleRequestCode: fakeArgs.saleRequestId,
          enterpriseCode: fakeArgs.enterpriseCode,
          customerCode: fakeArgs.customerCode,
          params: params,
        ),
      ).called(1);
    });
  });
}
