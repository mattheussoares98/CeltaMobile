import 'dart:convert';

import 'package:celta_intelligence/features/competing_prices/data/datasource/datasource.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapInsertUpdatePricesDatasource sut;

  late SoapRequestSpy soapRequest;

  late String workingUrl;
  late String crossIdentity;
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

  void initSut() {
    sut = SoapInsertUpdatePricesDatasource(soapRequest);
  }

  void initInjections() {
    soapRequest = SoapRequestSpy();
  }

  void mockSuccess() {}

  void initEntities() {
    workingUrl = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    researchCode = faker.randomGenerator.integer(100);
    researchCode = faker.randomGenerator.integer(100);
    concurrentCode = faker.randomGenerator.integer(100);
    productPackingCode = faker.randomGenerator.integer(100);
    priceLookUp = faker.guid.guid();
    priceRetail = faker.randomGenerator.decimal();
    offerRetail = faker.randomGenerator.decimal();
    priceWhole = faker.randomGenerator.decimal();
    offerWhole = faker.randomGenerator.decimal();
    priceECommerce = faker.randomGenerator.decimal();
    offerECommerce = faker.randomGenerator.decimal();
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test('Should behave correctly on success', () async {
    await sut.insert(
      workingUrl: workingUrl,
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
      () => soapRequest.post(
        url: workingUrl,
        typeOfResponse: "InsertConcurrentProductResponse",
        soapAction: "InsertConcurrentProduct",
        serviceASMX: "CeltaResearchOfPriceService.asmx",
        typeOfResult: null,
        parameters: {
          "json": [
            json.encode({
              "CrossIdentity": crossIdentity,
              "ResearchOfPriceCode": researchCode,
              "ConcurrentCode": concurrentCode,
              "ProductPackingCode": productPackingCode,
              "PriceLookUp": priceLookUp,
              "PriceRetail": priceRetail,
              "OfferRetail": offerRetail,
              "PriceWhole": priceWhole,
              "OfferWhole": offerWhole,
              "PriceECommerce": priceECommerce,
              "OfferECommerce": offerECommerce,
            }),
          ],
        },
      ),
    ).called(1);
  });
}
