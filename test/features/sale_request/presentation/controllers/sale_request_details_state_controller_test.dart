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

import '../../../../mocks/mocks.dart';

class MockEcGetSaleRequestsRepository extends Mock
    implements IEcGetSaleRequestsRepository {}

void main() {
  late MockEcGetSaleRequestsRepository mockRepository;
  late UserSessionModel fakeSession;
  late EcPaginationResults<SaleRequestEntity> fakeRequests;
  late EcRequestParams params;
  late int id;
  late FakeAppUsageStateController fakeAppUsage;

  setUpAll(() {
    registerFallbackValue(DateTime.now());
    registerFallbackValue(EntityFactory.makeEcRequestParams());
  });

  setUp(() {
    mockRepository = MockEcGetSaleRequestsRepository();
    id = faker.randomGenerator.integer(9999);

    // Generating a dynamic session via factory
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );

    fakeRequests = EcPaginationResults(
      totalRecords: faker.randomGenerator.integer(1000),
      recordsByPage: faker.randomGenerator.integer(100),
      actualPage: faker.randomGenerator.integer(5),
      recordsOnThisPage: faker.randomGenerator.integer(5),
      totalPages: faker.randomGenerator.integer(5),
      collection: [
        for (var x = 0; x < 3; x++)
          EcSaleRequestModel.fromEntity(
            EntityFactory.makeSaleRequestEntity(),
          ).toEntity(),
      ],
    );

    params = EcRequestParams(
      workingUrl: fakeSession.enterprise!.workingUrl!,
      user: fakeSession.user.name!,
      accessKey: fakeSession.user.AccessKey!,
    );
    fakeAppUsage = FakeAppUsageStateController();
  });

  ProviderContainer makeProviderContainer({UserSessionModel? session}) {
    return ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        ecGetSaleRequestsRepositoryProvider.overrideWithValue(mockRepository),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
        appUsageStateControllerProvider.overrideWith(() => fakeAppUsage),
      ],
    );
  }

  group('SaleRequestsStateController', () {
    test('Build should load and behave correctly', () async {
      // ARRANGE

      when(
        () => mockRepository.get(
          params: any(named: 'params'),
          enterpriseIds: any(named: 'enterpriseIds'),
          endDateHourOfCreation: any(named: 'endDateHourOfCreation'),
          startDateHourOfCreation: any(named: 'startDateHourOfCreation'),
          personalizedCodes: any(named: 'personalizedCodes'),
          mountCustomer: any(named: 'mountCustomer'),
          mountProducts: any(named: 'mountProducts'),
          mountRequestType: any(named: 'mountRequestType'),
          mountSeller: any(named: 'mountSeller'),
          id: any(named: 'id'),
        ),
      ).thenAnswer((_) async => fakeRequests);

      final container = makeProviderContainer(session: fakeSession);
      addTearDown(container.dispose);

      final states = <AsyncValue<EcPaginationResults<SaleRequestEntity>?>>[];
      container.listen(
        saleRequestDetailsStateControllerProvider(id),
        (_, next) => states.add(next),
      );

      // ACT
      await container.read(
        saleRequestDetailsStateControllerProvider(id).future,
      );

      final state = container.read(
        saleRequestDetailsStateControllerProvider(id),
      );
      expect(
        state,
        AsyncData<EcPaginationResults<SaleRequestEntity>?>(fakeRequests),
      );

      verify(
        () => mockRepository.get(
          params: params,
          id: id,
          mountCustomer: true,
          mountProducts: true,
          mountRequestType: true,
          mountSeller: true,
        ),
      ).called(1);

      expect(fakeAppUsage.lastUsageType, UsageType.completeSearchSaleRequest);
    });

    test('should throw through .future when repository fails', () async {
      // ARRANGE
      final exception = Exception('Direct throw test');
      when(
        () => mockRepository.get(
          params: any(named: 'params'),
          id: any(named: 'id'),
          mountCustomer: any(named: 'mountCustomer'),
          mountProducts: any(named: 'mountProducts'),
          mountRequestType: any(named: 'mountRequestType'),
          mountSeller: any(named: 'mountSeller'),
        ),
      ).thenThrow(exception);

      final container = makeProviderContainer(session: fakeSession);
      addTearDown(container.dispose);

      // ACT & ASSERT
      await expectLater(
        container.read(saleRequestDetailsStateControllerProvider(id).future),
        throwsA(equals(exception)),
      );
    });
  });
}
