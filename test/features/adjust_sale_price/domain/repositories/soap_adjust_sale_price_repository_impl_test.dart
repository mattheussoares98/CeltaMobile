import 'package:celta_intelligence/features/adjust_sale_price/domain/entities/entities.dart';
import 'package:celta_intelligence/features/adjust_sale_price/domain/repositories/repositories.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late SoapAdjustSalePriceRepositoryImpl sut;

  late SoapAdjustSalePriceDataSourceSpy soapAdjustSalePriceDataSource;

  late String baseUrl;
  late String crossIdentity;
  late int enterpriseCode;
  late int productCode;
  late int productPackingCode;
  late SaleType saleType;
  late List<ReplicationTypes> replications;
  late OfferParams? offerParams;
  late RetailParams? retailParams;
  late DateTime now;

  void initSut() {
    sut = SoapAdjustSalePriceRepositoryImpl(
      soapAdjustSalePriceDataSource: soapAdjustSalePriceDataSource,
    );
  }

  void initInjections() {
    soapAdjustSalePriceDataSource = SoapAdjustSalePriceDataSourceSpy();
  }

  void mockSuccess() {}

  void initEntities() {
    baseUrl = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    enterpriseCode = faker.randomGenerator.integer(100);
    productCode = faker.randomGenerator.integer(100);
    productPackingCode = faker.randomGenerator.integer(100);
    saleType =
        SaleType.values[faker.randomGenerator.integer(SaleType.values.length)];
    replications = [
      ReplicationTypes.values[faker.randomGenerator.integer(
        ReplicationTypes.values.length,
      )],
    ];
    now = DateTime.now();
    offerParams = OfferParams(
      price: faker.randomGenerator.decimal(),
      effectuationDateOffer: faker.date.dateTime(),
      endDateOffer: faker.date.dateTime(),
    );
    retailParams = RetailParams(
      price: faker.randomGenerator.decimal(),
      effectuationDatePrice: faker.date.dateTime(),
    );
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  setUpAll(() {
    for (var saleType in SaleType.values) {
      registerFallbackValue(saleType);
    }
  });

  group('logIn', () {
    test('should behave correctly on success', () async {
      await sut.confirm(
        baseUrl: baseUrl,
        crossIdentity: crossIdentity,
        enterpriseCode: enterpriseCode,
        productCode: productCode,
        productPackingCode: productPackingCode,
        saleType: saleType,
        replications: replications,
        offerParams: offerParams,
        retailParams: retailParams,
        now: now,
      );

      verify(
        () => soapAdjustSalePriceDataSource.confirm(
          baseUrl: baseUrl,
          crossIdentity: crossIdentity,
          enterpriseCode: enterpriseCode,
          productCode: productCode,
          productPackingCode: productPackingCode,
          saleType: saleType,
          replications: replications,
          offerParams: offerParams,
          retailParams: retailParams,
          now: now,
        ),
      ).called(1);

      verifyNoMoreInteractions(soapAdjustSalePriceDataSource);
    });
  });
}
