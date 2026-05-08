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
  late int saleRequestCode;
  late int customerCode;
  late FakeAppUsageStateController fakeAppUsage;
  late BSFSaleRequestModel fakeBSFSaleRequestModel;

  setUpAll(() {
    registerFallbackValue(DateTime.now());
    registerFallbackValue(EntityFactory.makeEcRequestParams());
  });

  setUp(() {
    mockRepository = MockecSaleRequestsRepository();
    saleRequestCode = faker.randomGenerator.integer(9999);
    customerCode = faker.randomGenerator.integer(9999);

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
  });

  ProviderContainer makeProviderContainer({UserSessionModel? session}) {
    return ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        ecSaleRequestsRepositoryProvider.overrideWithValue(mockRepository),
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
        saleRequestDetailsStateControllerProvider(
          customerCode: customerCode,
          saleRequestCode: saleRequestCode,
          enterpriseCode: fakeSession.enterprise!.id!,
        ),
        (_, next) => states.add(next),
      );

      // ACT
      await container.read(
        saleRequestDetailsStateControllerProvider(
          customerCode: customerCode,
          saleRequestCode: saleRequestCode,
          enterpriseCode: fakeSession.enterprise!.id!,
        ).future,
      );

      final state = container.read(
        saleRequestDetailsStateControllerProvider(
          customerCode: customerCode,
          saleRequestCode: saleRequestCode,
          enterpriseCode: fakeSession.enterprise!.id!,
        ),
      );
      expect(
        state,
        AsyncData<BSFSaleRequestEntity>(fakeBSFSaleRequestModel.toEntity()),
      );

      verify(
        () => mockRepository.getComplete(
          saleRequestCode: saleRequestCode,
          enterpriseCode: fakeSession.enterprise!.id!,
          customerCode: customerCode,
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
          saleRequestCode: any(named: 'saleRequestCode'),
          enterpriseCode: any(named: 'enterpriseCode'),
          customerCode: any(named: 'customerCode'),
          params: any(named: 'params'),
        ),
      ).thenThrow(exception);

      final container = makeProviderContainer(session: fakeSession);
      addTearDown(container.dispose);

      // ACT & ASSERT
      await expectLater(
        container.read(
          saleRequestDetailsStateControllerProvider(
            customerCode: customerCode,
            saleRequestCode: saleRequestCode,
            enterpriseCode: fakeSession.enterprise!.id!,
          ).future,
        ),
        throwsA(equals(exception)),
      );
    });
  });
}
