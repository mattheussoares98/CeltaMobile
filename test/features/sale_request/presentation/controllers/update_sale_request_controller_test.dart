import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/ec/ec.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/sale_request/domain/repository/repository.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/insert_update/update_sale_request_controller.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/all_mocks.dart';
import '../../../../mocks/entity_factory.dart';

class MockEcSaleRequestsRepository extends Mock
    implements IEcSaleRequestsRepository {}

void main() {
  late MockEcSaleRequestsRepository mockEcSaleRequestsRepository;
  late UserSessionModel fakeSession;
  late int saleRequestCode;
  late int enterpriseCode;

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeBSFSaleRequestEntity());
    registerFallbackValue(EntityFactory.makeEcRequestParams());
  });

  setUp(() {
    mockEcSaleRequestsRepository = MockEcSaleRequestsRepository();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    saleRequestCode = faker.randomGenerator.integer(100);
    enterpriseCode = faker.randomGenerator.integer(100);
  });

  ProviderContainer makeProviderContainer() {
    return ProviderContainer(
      overrides: [
        ecSaleRequestsRepositoryProvider.overrideWithValue(
          mockEcSaleRequestsRepository,
        ),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(fakeSession),
        ),
      ],
    );
  }

  group('UpdateSaleRequestController', () {
    test(
      'should update sale request status and invalidate providers',
      () async {
        // ARRANGE
        final saleRequest = EntityFactory.makeBSFSaleRequestEntity();
        when(
          () => mockEcSaleRequestsRepository.update(
            saleRequest: any(named: 'saleRequest'),
            enterpriseCode: any(named: 'enterpriseCode'),
            params: any(named: 'params'),
          ),
        ).thenAnswer((_) async => true);

        final container = makeProviderContainer();
        addTearDown(container.dispose);

        final states = <AsyncValue<void>>[];
        container.listen(
          updateSaleRequestControllerProvider(saleRequestCode, enterpriseCode),
          (_, next) => states.add(next),
          fireImmediately: true,
        );

        final controller = container.read(
          updateSaleRequestControllerProvider(
            saleRequestCode,
            enterpriseCode,
          ).notifier,
        );

        // ACT
        await controller.updateSaleRequest(saleRequest);

        // ASSERT
        expect(states, [
          const AsyncData<void>(null),
          isA<AsyncLoading>(),
          isA<AsyncData>(),
        ]);

        verify(
          () => mockEcSaleRequestsRepository.update(
            saleRequest: saleRequest,
            enterpriseCode: enterpriseCode,
            params: EcRequestParams(
              workingUrl: fakeSession.enterprise!.workingUrl!,
              user: fakeSession.user.name!,
              accessKey: fakeSession.user.AccessKey!,
            ),
          ),
        ).called(1);
      },
    );

    test('should emit error on failure', () async {
      // ARRANGE
      final saleRequest = EntityFactory.makeBSFSaleRequestEntity();
      when(
        () => mockEcSaleRequestsRepository.update(
          saleRequest: any(named: 'saleRequest'),
          enterpriseCode: any(named: 'enterpriseCode'),
          params: any(named: 'params'),
        ),
      ).thenThrow(Exception('error'));

      final container = makeProviderContainer();
      addTearDown(container.dispose);

      final states = <AsyncValue<void>>[];
      container.listen(
        updateSaleRequestControllerProvider(saleRequestCode, enterpriseCode),
        (_, next) => states.add(next),
        fireImmediately: true,
      );

      final controller = container.read(
        updateSaleRequestControllerProvider(
          saleRequestCode,
          enterpriseCode,
        ).notifier,
      );

      // ACT
      await controller.updateSaleRequest(saleRequest);

      // ASSERT
      expect(states, [
        const AsyncData<void>(null),
        isA<AsyncLoading>(),
        isA<AsyncError>(),
      ]);
    });
  });
}
