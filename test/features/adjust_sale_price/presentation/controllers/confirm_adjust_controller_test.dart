import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/adjust_sale_price/domain/entities/entities.dart';
import 'package:celta_inventario/features/adjust_sale_price/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/adjust_sale_price/presentation/models/models.dart';
import 'package:celta_inventario/features/adjust_sale_price/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class FakeUIStateController extends UIStateController {
  final AdjustPriceUIModel uiStateToReturn;
  FakeUIStateController(this.uiStateToReturn);

  @override
  Future<AdjustPriceUIModel> build(String plu) async {
    return uiStateToReturn;
  }
}

void main() async {
  late SoapAdjustSalePriceRepositorySpy mockRepository;

  late int enterpriseCode;
  late UserSessionEntity userSessionEntity;
  late DateTime now;
  late ProductEntity productEntity;
  late double price;

  setUp(() {
    for (final saleType in SaleType.values) {
      registerFallbackValue(saleType);
    }
    for (final priceType in PriceType.values) {
      registerFallbackValue(priceType);
    }

    enterpriseCode = faker.randomGenerator.integer(100);
    userSessionEntity = EntityFactory.makeUserSessionEntity();
    now = DateTime.now();
    productEntity = EntityFactory.makeProductEntity();
    price = faker.randomGenerator.decimal();
    mockRepository = SoapAdjustSalePriceRepositorySpy();
  });

  ProviderContainer makeProviderContainer({
    required AdjustPriceUIModel uiState,
  }) {
    return ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        soapAdjustSalePriceRepositoryProvider.overrideWithValue(mockRepository),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(
            UserSessionModel.fromEntity(userSessionEntity),
          ),
        ),
        selectedProductStateControllerProvider(
          enterpriseCode,
          productEntity.PLU!,
        ).overrideWith(() => FakeSelectedProductStateController(productEntity)),
        uIStateControllerProvider(
          productEntity.PLU!,
        ).overrideWith(() => FakeUIStateController(uiState)),
      ],
    );
  }

  group('ConfirmAdjustController confirm', () {
    test('should emit [loading, data] on success', () async {
      final uiState = EntityFactory.makeAdjustPriceUIModel(
        selectedReplications: {
          for (var value in ReplicationTypes.values)
            if (faker.randomGenerator.boolean()) value,
        },
        availableReplications: {
          for (var value in ReplicationTypes.values)
            if (faker.randomGenerator.boolean()) value,
        }.toList(),
      );
      final container = makeProviderContainer(uiState: uiState);
      addTearDown(container.dispose);
      final states = <AsyncValue<void>>[];
      container.listen(
        confirmAdjustControllerProvider,
        (_, next) => states.add(next),
      );

      await container
          .read(confirmAdjustControllerProvider.notifier)
          .confirm(
            enterpriseCode: enterpriseCode,
            plu: productEntity.PLU!,
            price: price,
            now: now,
          );

      expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
      verify(
        () => mockRepository.confirm(
          workingUrl: userSessionEntity.supabaseEnterprise!.workingUrl!,
          crossIdentity: userSessionEntity.user.CrossIdentity_Usuario!,
          enterpriseCode: enterpriseCode,
          productCode: productEntity.ProductCode!,
          productPackingCode: productEntity.ProductPackingCode!,
          offerParams: uiState.selectedPriceType == PriceType.offer
              ? OfferParams(
                  price: price,
                  effectuationDateOffer: uiState.selectedStartDate,
                  endDateOffer: uiState.selectedEndDate,
                )
              : null,
          replications: uiState.selectedReplications.toList(),
          retailParams: uiState.selectedPriceType == PriceType.sale
              ? RetailParams(
                  price: price,
                  effectuationDatePrice: uiState.selectedStartDate,
                )
              : null,
          saleType: uiState.selectedSaleType!,
          now: now,
        ),
      ).called(1);
    });

    test('should emit [loading, error] on failure', () async {
      mockRepository.mockConfirmError();

      final container = makeProviderContainer(
        uiState: EntityFactory.makeAdjustPriceUIModel(),
      );
      addTearDown(container.dispose);
      final states = <AsyncValue<void>>[];
      container.listen(
        confirmAdjustControllerProvider,
        (_, next) => states.add(next),
      );

      await container
          .read(confirmAdjustControllerProvider.notifier)
          .confirm(
            enterpriseCode: enterpriseCode,
            plu: productEntity.PLU!,
            price: price,
            now: now,
          );

      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
    });
  });
}
