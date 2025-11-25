import 'package:celta_intelligence/features/buy_request/data/models/models.dart';
import 'package:celta_intelligence/features/competing_prices/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/competing_prices/domain/repository/repository.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class SoapInsertUpdatePricesDatasourceSpy extends Mock
    implements ISoapInsertUpdatePricesDatasource {
  SoapInsertUpdatePricesDatasourceSpy() {
    when(
      () => this.insert(
        baseUrl: any(named: 'baseUrl'),
        crossIdentity: any(named: 'crossIdentity'),
        researchCode: any(named: 'researchCode'),
        concurrentCode: any(named: 'concurrentCode'),
        productPackingCode: any(named: 'productPackingCode'),
        priceLookUp: any(named: 'priceLookUp'),
        pricesMap: any(named: 'pricesMap'),
      ),
    ).thenAnswer((_) async {});
  }
}

void main() {
  late ISoapInsertUpdatePricesRepository sut;

  late SoapInsertUpdatePricesDatasourceSpy datasource;

  late String baseUrl;
  late String crossIdentity;
  late int researchCode;
  late int concurrentCode;
  late int productPackingCode;
  late String priceLookUp;
  late double? priceRetail;
  late double? offerRetail;
  late double? priceWhole;
  late double? offerWhole;
  late double? priceECommerce;
  late double? offerECommerce;

  void initSut() {
    sut = SoapInsertUpdatePricesRepositoryImpl(datasource);
  }

  void initInjections() {
    datasource = SoapInsertUpdatePricesDatasourceSpy();
  }

  void mockSuccess() {}

  void initEntities() {
    crossIdentity = faker.guid.guid();
    baseUrl = faker.internet.httpUrl();
    researchCode = faker.randomGenerator.integer(100);
    concurrentCode = faker.randomGenerator.integer(100);
    productPackingCode = faker.randomGenerator.integer(100);
    priceLookUp = faker.guid.guid();
    priceRetail = faker.randomGenerator.boolean()
        ? faker.randomGenerator.decimal()
        : null;
    offerRetail = faker.randomGenerator.boolean()
        ? faker.randomGenerator.decimal()
        : null;
    priceWhole = faker.randomGenerator.boolean()
        ? faker.randomGenerator.decimal()
        : null;
    offerWhole = faker.randomGenerator.boolean()
        ? faker.randomGenerator.decimal()
        : null;
    priceECommerce = faker.randomGenerator.boolean()
        ? faker.randomGenerator.decimal()
        : null;
    offerECommerce = faker.randomGenerator.boolean()
        ? faker.randomGenerator.decimal()
        : null;
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  setUpAll(() {
    registerFallbackValue(
      PendingBuyRequestModel.fromEntity(
        EntityFactory.makePendingBuyRequestEntity(),
      ),
    );
  });

  test('should call with correct values when pass all params', () async {
    await sut.insert(
      baseUrl: baseUrl,
      crossIdentity: crossIdentity,
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

    verify(
      () => datasource.insert(
        baseUrl: baseUrl,
        crossIdentity: crossIdentity,
        researchCode: researchCode,
        concurrentCode: concurrentCode,
        productPackingCode: productPackingCode,
        priceLookUp: priceLookUp,
        pricesMap: {
          if (priceRetail != null) "PriceRetail": priceRetail!,
          if (offerRetail != null) "OfferRetail": offerRetail!,
          if (priceWhole != null) "PriceWhole": priceWhole!,
          if (offerWhole != null) "OfferWhole": offerWhole!,
          if (priceECommerce != null) "PriceECommerce": priceECommerce!,
          if (offerECommerce != null) "OfferECommerce": offerECommerce!,
        },
      ),
    ).called(1);

    verifyNoMoreInteractions(datasource);
  });
}
