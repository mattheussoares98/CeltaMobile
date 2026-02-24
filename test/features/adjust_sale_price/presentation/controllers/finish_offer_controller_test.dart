import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/adjust_sale_price/domain/entities/entities.dart';
import 'package:celta_inventario/features/adjust_sale_price/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/adjust_sale_price/providers.dart';
import 'package:celta_inventario/features/enterprises/presentation/controllers/controllers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() async {
  late SoapAdjustSalePriceRepositorySpy mockRepository;

  late SaleType saleType;
  late OfferParams offerParams;
  late UserSessionEntity userSessionEntity;
  late DateTime now;
  late ProductEntity productEntity;
  late EnterpriseEntity enterpriseEntity;
  late int productPackingCode;

  setUp(() {
    for (final saleType in SaleType.values) {
      registerFallbackValue(saleType);
    }
    for (final priceType in PriceType.values) {
      registerFallbackValue(priceType);
    }

    mockRepository = SoapAdjustSalePriceRepositorySpy();

    saleType =
        SaleType.values[faker.randomGenerator.integer(SaleType.values.length)];
    now = DateTime.now();
    offerParams = OfferParams(
      price: 0,
      effectuationDateOffer: now,
      endDateOffer: null,
    );
    userSessionEntity = EntityFactory.makeUserSessionEntity();
    productEntity = EntityFactory.makeProductEntity();
    enterpriseEntity = EntityFactory.makeEnterpriseEntity();
    productPackingCode = faker.randomGenerator.integer(100);
  });

  ProviderContainer makeProviderContainer() {
    return ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        soapAdjustSalePriceRepositoryProvider.overrideWithValue(mockRepository),
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

  group('ConfirmAdjustController confirm', () {
    test('should emit [loading, data] on success', () async {
      final container = makeProviderContainer();
      addTearDown(container.dispose);
      final states = <AsyncValue<void>>[];
      container.listen(
        finishOfferControllerProvider(
          productPackingCode,
          productEntity.EnterpriseCode!,
        ),
        (_, next) => states.add(next),
      );

      await container
          .read(
            finishOfferControllerProvider(
              productPackingCode,
              productEntity.EnterpriseCode!,
            ).notifier,
          )
          .finish(product: productEntity, saleType: saleType, now: now);

      expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
      verify(
        () => mockRepository.confirm(
          workingUrl: userSessionEntity.supabaseEnterprise!.workingUrl!,
          crossIdentity: userSessionEntity.user.CrossIdentity_Usuario!,
          enterpriseCode: productEntity.EnterpriseCode!,
          productCode: productEntity.ProductCode!,
          productPackingCode: productPackingCode,
          offerParams: offerParams,
          replications: [],
          retailParams: null,
          saleType: saleType,
          now: now,
        ),
      ).called(1);
    });

    test('should emit [loading, error] on failure', () async {
      mockRepository.mockConfirmError();

      final container = makeProviderContainer();
      addTearDown(container.dispose);
      final states = <AsyncValue<void>>[];
      container.listen(
        finishOfferControllerProvider(
          productPackingCode,
          productEntity.EnterpriseCode!,
        ),
        (_, next) => states.add(next),
      );

      await container
          .read(
            finishOfferControllerProvider(
              productPackingCode,
              productEntity.EnterpriseCode!,
            ).notifier,
          )
          .finish(product: productEntity, saleType: saleType, now: now);

      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
    });

    test(
      'should call with correct enterprise code when enterprise code is null',
      () async {
        final container = makeProviderContainer();
        addTearDown(container.dispose);
        final states = <AsyncValue<void>>[];
        container.listen(
          finishOfferControllerProvider(productPackingCode, null),
          (_, next) => states.add(next),
        );

        await container
            .read(
              finishOfferControllerProvider(productPackingCode, null).notifier,
            )
            .finish(product: productEntity, saleType: saleType, now: now);

        expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
        verify(
          () => mockRepository.confirm(
            workingUrl: userSessionEntity.supabaseEnterprise!.workingUrl!,
            crossIdentity: userSessionEntity.user.CrossIdentity_Usuario!,
            enterpriseCode: enterpriseEntity.Code!,
            productCode: productEntity.ProductCode!,
            productPackingCode: productPackingCode,
            offerParams: offerParams,
            replications: [],
            retailParams: null,
            saleType: saleType,
            now: now,
          ),
        ).called(1);
      },
    );
  });
}
