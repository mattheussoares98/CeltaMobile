import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_intelligence/features/enterprises/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/adjust_sale_price/domain/entities/entities.dart';
import 'package:celta_intelligence/features/adjust_sale_price/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/adjust_sale_price/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late SoapGetPriceSchedulesRepositorySpy mockRepository;

  late UserSessionEntity userSessionEntity;
  late EnterpriseEntity enterpriseEntity;
  late List<PriceScheduleEntity> priceSchedulesEntities;
  late ProductEntity productEntity;

  setUp(() {
    mockRepository = SoapGetPriceSchedulesRepositorySpy();
    userSessionEntity = EntityFactory.makeUserSessionEntity();
    enterpriseEntity = EntityFactory.makeEnterpriseEntity();
    priceSchedulesEntities = [EntityFactory.makePriceScheduleEntity()];

    mockRepository.mockGetPriceSchedules(priceSchedulesEntities);
    productEntity = EntityFactory.makeProductEntity();
  });

  ProviderContainer makeProviderContainer() {
    return ProviderContainer(
      overrides: [
        soapGetPriceSchedulesRepositoryProvider.overrideWithValue(
          mockRepository,
        ),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(
            UserSessionModel.fromEntity(userSessionEntity),
          ),
        ),
        selectedEnterpriseStateControllerProvider.overrideWith(
          () => FakeSelectedEnterpriseStateController(enterpriseEntity),
        ),
      ],
    );
  }

  group('PriceSchedulesStateController', () {
    test('should start with null value', () async {
      final container = makeProviderContainer();
      addTearDown(container.dispose);
      final states = <AsyncValue<List<PriceScheduleEntity>?>>[];

      container.listen(
        priceSchedulesStateControllerProvider(
          enterpriseEntity.Code!,
          productEntity.PLU,
        ),
        (_, next) => states.add(next),
      );

      final value = await container
          .read(
            priceSchedulesStateControllerProvider(
              enterpriseEntity.Code!,
              productEntity.PLU,
            ).notifier,
          )
          .build(enterpriseEntity.Code!, productEntity.PLU);

      expect(value, isNull);
    });

    test('should emit [loading, data] on success', () async {
      final container = makeProviderContainer();
      addTearDown(container.dispose);
      final states = <AsyncValue<List<PriceScheduleEntity>?>>[];

      container.listen(
        priceSchedulesStateControllerProvider(
          enterpriseEntity.Code!,
          productEntity.PLU,
        ),
        (_, next) => states.add(next),
      );

      await container
          .read(
            priceSchedulesStateControllerProvider(
              enterpriseEntity.Code!,
              productEntity.PLU,
            ).notifier,
          )
          .getPriceSchedules(
            enterpriseCode: enterpriseEntity.Code!,
            productCode: productEntity.ProductCode,
            productPackingCode: productEntity.ProductPackingCode,
          );

      expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
      expect(states.last.value, priceSchedulesEntities);
      verify(
        () => mockRepository.getPriceSchedules(
          baseUrl: userSessionEntity.supabaseEnterprise!.baseUrl!,
          crossIdentity: userSessionEntity.user.CrossIdentity_Usuario!,
          enterpriseCode: enterpriseEntity.Code!,
          productCode: productEntity.ProductCode,
          productPackingCode: productEntity.ProductPackingCode,
        ),
      ).called(1);
    });

    test('should emit [loading, error] on failure', () async {
      mockRepository.mockGetPriceScheduleError();

      final container = makeProviderContainer();
      addTearDown(container.dispose);
      final states = <AsyncValue<List<PriceScheduleEntity>?>>[];
      container.listen(
        priceSchedulesStateControllerProvider(
          enterpriseEntity.Code!,
          productEntity.PLU,
        ),
        (_, next) => states.add(next),
      );

      await container
          .read(
            priceSchedulesStateControllerProvider(
              enterpriseEntity.Code!,
              productEntity.PLU,
            ).notifier,
          )
          .getPriceSchedules(
            enterpriseCode: enterpriseEntity.Code!,
            productCode: productEntity.ProductCode,
            productPackingCode: productEntity.ProductPackingCode,
          );

      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
    });
  });
}
