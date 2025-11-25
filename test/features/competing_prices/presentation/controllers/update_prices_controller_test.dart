import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_intelligence/exceptions/app_exception.dart';
import 'package:celta_intelligence/features/competing_prices/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/competing_prices/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/competing_prices/providers/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockSoapInsertConcurrentProductPricesDatasource extends Mock
    implements ISoapInsertConcurrentProductPricesDatasource {}

void main() {
  late MockSoapInsertConcurrentProductPricesDatasource mockDatasource;
  late UserSessionModel fakeSession;

  // Test data variables
  late int researchCode;
  late int concurrentCode;
  late int productPackingCode;
  late String priceLookUp;
  late double priceRetail;
  late double offerRetail;
  late double priceWhole;
  late double offerWhole;
  late double priceECommerce;
  late double offerECommerce;

  setUpAll(() {
    // Register nullable doubles for mocktail
    registerFallbackValue(faker.randomGenerator.decimal());
    registerFallbackValue(null);
  });

  setUp(() {
    mockDatasource = MockSoapInsertConcurrentProductPricesDatasource();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );

    // Initialize test data using faker
    researchCode = faker.randomGenerator.integer(100);
    concurrentCode = faker.randomGenerator.integer(100);
    productPackingCode = faker.randomGenerator.integer(100);
    priceLookUp = faker.lorem.word();
    priceRetail = faker.randomGenerator.decimal();
    offerRetail = faker.randomGenerator.decimal();
    priceWhole = faker.randomGenerator.decimal();
    offerWhole = faker.randomGenerator.decimal();
    priceECommerce = faker.randomGenerator.decimal();
    offerECommerce = faker.randomGenerator.decimal();
  });

  ProviderContainer makeProviderContainer({UserSessionModel? session}) {
    return ProviderContainer(
      overrides: [
        soapInsertConcurrentProductPricesDatasourceProvider.overrideWithValue(
          mockDatasource,
        ),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
      ],
    );
  }

  group('UpdatePricesController', () {
    test(
      'insertUpdatePrices should emit [loading, data] and call datasource with all parameters',
      () async {
        // ARRANGE
        when(
          () => mockDatasource.insert(
            baseUrl: any(named: 'baseUrl'),
            crossIdentity: any(named: 'crossIdentity'),
            researchCode: any(named: 'researchCode'),
            concurrentCode: any(named: 'concurrentCode'),
            productPackingCode: any(named: 'productPackingCode'),
            priceLookUp: any(named: 'priceLookUp'),
            priceRetail: any(named: 'priceRetail'),
            offerRetail: any(named: 'offerRetail'),
            priceWhole: any(named: 'priceWhole'),
            offerWhole: any(named: 'offerWhole'),
            priceECommerce: any(named: 'priceECommerce'),
            offerECommerce: any(named: 'offerECommerce'),
          ),
        ).thenAnswer((_) async {});

        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        final states = <AsyncValue<void>>[];
        container.listen(
          updatePricesControllerProvider,
          (_, next) => states.add(next),
        );

        // ACT
        await container
            .read(updatePricesControllerProvider.notifier)
            .insertUpdate(
              researchCode: researchCode,
              concurrentCode: concurrentCode,
              productPackingCode: productPackingCode,
              priceLookUp: priceLookUp,
              priceRetail: priceRetail,
              offerRetail: offerRetail,
              priceWhole: priceWhole,
              offerWhole: offerWhole,
              priceECommerce: priceECommerce,
              offerECommerce: offerECommerce,
            );

        // ASSERT
        expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);

        // Verify datasource call
        verify(
          () => mockDatasource.insert(
            baseUrl: fakeSession.enterprise!.baseUrl!,
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            researchCode: researchCode,
            concurrentCode: concurrentCode,
            productPackingCode: productPackingCode,
            priceLookUp: priceLookUp,
            priceRetail: priceRetail,
            offerRetail: offerRetail,
            priceWhole: priceWhole,
            offerWhole: offerWhole,
            priceECommerce: priceECommerce,
            offerECommerce: offerECommerce,
          ),
        ).called(1);
      },
    );

    test('should emit [loading, error] when session is invalid', () async {
      // ARRANGE
      final container = makeProviderContainer(session: null); // Invalid session
      addTearDown(container.dispose);

      final states = <AsyncValue<void>>[];
      container.listen(
        updatePricesControllerProvider,
        (_, next) => states.add(next),
      );

      // ACT
      await container
          .read(updatePricesControllerProvider.notifier)
          .insertUpdate(
            researchCode: researchCode,
            concurrentCode: concurrentCode,
            productPackingCode: productPackingCode,
            priceLookUp: priceLookUp,
            priceRetail: priceRetail,
            offerRetail: offerRetail,
            priceWhole: null,
            offerWhole: null,
            priceECommerce: null,
            offerECommerce: null,
          );

      // ASSERT
      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
      expect(states.last.error, isA<AppException>());

      // Verify datasource was never called
      verifyNever(
        () => mockDatasource.insert(
          baseUrl: any(named: 'baseUrl'),
          crossIdentity: any(named: 'crossIdentity'),
          researchCode: any(named: 'researchCode'),
          concurrentCode: any(named: 'concurrentCode'),
          productPackingCode: any(named: 'productPackingCode'),
          priceLookUp: any(named: 'priceLookUp'),
          priceRetail: any(named: 'priceRetail'),
          offerRetail: any(named: 'offerRetail'),
          priceWhole: any(named: 'priceWhole'),
          offerWhole: any(named: 'offerWhole'),
          priceECommerce: any(named: 'priceECommerce'),
          offerECommerce: any(named: 'offerECommerce'),
        ),
      );
    });
  });
}
