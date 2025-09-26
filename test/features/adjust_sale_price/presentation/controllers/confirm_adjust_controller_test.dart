import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
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

  late int enterpriseCode;
  late int productCode;
  late int productPackingCode;
  late SaleType saleType;
  late List<ReplicationTypes> replications;
  late OfferParams offerParams;
  late RetailParams retailParams;
  late UserSessionEntity userSessionEntity;
  late DateTime now;

  setUp(() {
    for (final saleType in SaleType.values) {
      registerFallbackValue(saleType);
    }
    for (final priceType in PriceType.values) {
      registerFallbackValue(priceType);
    }

    mockRepository = SoapAdjustSalePriceRepositorySpy();

    enterpriseCode = faker.randomGenerator.integer(100);
    productCode = faker.randomGenerator.integer(1000);
    productPackingCode = faker.randomGenerator.integer(100);
    saleType =
        SaleType.values[faker.randomGenerator.integer(SaleType.values.length)];
    replications = [
      ReplicationTypes.values[faker.randomGenerator.integer(
        ReplicationTypes.values.length,
      )],
    ];
    offerParams = OfferParams(
      price: faker.randomGenerator.decimal(),
      effectuationDateOffer: faker.date.dateTime(),
      endDateOffer: faker.date.dateTime(),
    );
    retailParams = RetailParams(
      price: faker.randomGenerator.decimal(),
      effectuationDatePrice: faker.date.dateTime(),
    );
    userSessionEntity = EntityFactory.makeUserSessionEntity();
    now = DateTime.now();
  });

  ProviderContainer makeProviderContainer() {
    return ProviderContainer(
      overrides: [
        soapAdjustSalePriceRepositoryProvider.overrideWithValue(mockRepository),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(
            UserSessionModel.fromEntity(userSessionEntity),
          ),
        ),
        authStateControllerProvider.overrideWith(
          () => FakeAuthStateController(userSessionEntity.user),
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
        confirmAdjustControllerProvider,
        (_, next) => states.add(next),
      );

      await container
          .read(confirmAdjustControllerProvider.notifier)
          .confirm(
            enterpriseCode: enterpriseCode,
            productCode: productCode,
            productPackingCode: productPackingCode,
            offerParams: offerParams,
            replications: replications,
            retailParams: retailParams,
            saleType: saleType,
            now: now,
          );

      expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
      verify(
        () => mockRepository.confirm(
          baseUrl: userSessionEntity.supabaseEnterprise.baseUrl!,
          crossIdentity: userSessionEntity.user.CrossIdentity_Usuario!,
          enterpriseCode: enterpriseCode,
          productCode: productCode,
          productPackingCode: productPackingCode,
          offerParams: offerParams,
          replications: replications,
          retailParams: retailParams,
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
        confirmAdjustControllerProvider,
        (_, next) => states.add(next),
      );

      await container
          .read(confirmAdjustControllerProvider.notifier)
          .confirm(
            enterpriseCode: enterpriseCode,
            productCode: productCode,
            productPackingCode: productPackingCode,
            offerParams: offerParams,
            replications: replications,
            retailParams: retailParams,
            saleType: saleType,
            now: now,
          );

      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
    });
  });
}
