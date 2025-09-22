import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/providers/providers.dart';
import 'package:celta_intelligence/features/adjust_sale_price/domain/entities/entities.dart';
import 'package:celta_intelligence/features/adjust_sale_price/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/adjust_sale_price/providers.dart';
import 'package:celta_intelligence/features/auth/presentation/controllers/controllers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() async {
  late SoapAdjustSalePriceRepositorySpy mockRepository;

  late String baseUrl;
  late int enterpriseCode;
  late int productCode;
  late int productPackingCode;
  late SaleType saleType;
  late OfferParams offerParams;
  late UserEntity userEntity;
  late UserSessionModel userSession;
  late DateTime now;

  setUp(() {
    for (final saleType in SaleType.values) {
      registerFallbackValue(saleType);
    }
    for (final priceType in PriceType.values) {
      registerFallbackValue(priceType);
    }

    mockRepository = SoapAdjustSalePriceRepositorySpy();

    baseUrl = faker.internet.httpUrl();
    enterpriseCode = faker.randomGenerator.integer(100);
    productCode = faker.randomGenerator.integer(1000);
    productPackingCode = faker.randomGenerator.integer(100);
    saleType =
        SaleType.values[faker.randomGenerator.integer(SaleType.values.length)];
    now = DateTime.now();
    offerParams = OfferParams(
      price: 0,
      effectuationDateOffer: now,
      endDateOffer: null,
    );
    userEntity = EntityFactory.makeUserEntity();
    userSession = UserSessionModel(baseUrl: baseUrl);
  });

  ProviderContainer makeProviderContainer() {
    return ProviderContainer(
      overrides: [
        soapAdjustSalePriceRepositoryProvider.overrideWithValue(mockRepository),
        userSessionProvider.overrideWith(() => FakeUserSession(userSession)),
        authStateControllerProvider.overrideWith(
          () => FakeAuthStateController(userEntity),
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
        finishOfferControllerProvider,
        (_, next) => states.add(next),
      );

      await container
          .read(finishOfferControllerProvider.notifier)
          .finish(
            enterpriseCode: enterpriseCode,
            productCode: productCode,
            productPackingCode: productPackingCode,
            offerParams: offerParams,
            saleType: saleType,
            now: now,
          );

      expect(states, [isA<AsyncData>(), isA<AsyncData>()]);
      verify(
        () => mockRepository.confirm(
          baseUrl: userSession.baseUrl!,
          crossIdentity: userEntity.CrossIdentity_Usuario!,
          enterpriseCode: enterpriseCode,
          productCode: productCode,
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
        finishOfferControllerProvider,
        (_, next) => states.add(next),
      );

      await container
          .read(finishOfferControllerProvider.notifier)
          .finish(
            enterpriseCode: enterpriseCode,
            productCode: productCode,
            productPackingCode: productPackingCode,
            offerParams: offerParams,
            saleType: saleType,
            now: now,
          );

      expect(states, [isA<AsyncData>(), isA<AsyncError>()]);
    });
  });
}
