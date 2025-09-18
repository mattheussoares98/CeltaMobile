import 'package:celta_intelligence/features/adjust_sale_price/domain/entities/entities.dart';
import 'package:celta_intelligence/features/adjust_sale_price/domain/repositories/repositories.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late SoapAdjustSalePriceRepositoryImpl sut;

  late SoapAdjustSalePriceDatasourceSpy soapAdjustSalePriceDatasource;

  late String baseUrl;
  late String crossIdentity;
  late int enterpriseCode;
  late int productCode;
  late int productPackingCode;
  late SaleType saleType;
  late List<ReplicationTypes> replications;
  late OfferParams? offerParams;
  late RetailParams? retailParams;

  void initSut() {
    sut = SoapAdjustSalePriceRepositoryImpl(
      soapAdjustSalePriceDatasource: soapAdjustSalePriceDatasource,
    );
  }

  void initInjections() {
    soapAdjustSalePriceDatasource = SoapAdjustSalePriceDatasourceSpy();
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
      );

      verify(
        () => soapAdjustSalePriceDatasource.confirm(
          baseUrl: baseUrl,
          crossIdentity: crossIdentity,
          enterpriseCode: enterpriseCode,
          productCode: productCode,
          productPackingCode: productPackingCode,
          saleType: saleType,
          replications: replications,
          offerParams: offerParams,
          retailParams: retailParams,
        ),
      ).called(1);

      verifyNoMoreInteractions(soapAdjustSalePriceDatasource);
    });
  });
}
