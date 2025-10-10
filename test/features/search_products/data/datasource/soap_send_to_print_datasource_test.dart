import 'package:celta_intelligence/features/search_products/data/datasource/datasource.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapSendToPrint sut;

  late SoapRequestSpy soapAdapter;

  late String baseUrl;
  late String crossIdentity;
  late int enterpriseCode;
  late String productPackingCode;
  late bool newValue;

  void initSut() {
    sut = SoapSendToPrint(soapAdapter);
  }

  void initInjections() {
    soapAdapter = SoapRequestSpy();
  }

  void mockSuccess() {}

  void initEntities() {
    baseUrl = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    enterpriseCode = faker.randomGenerator.integer(100);
    productPackingCode = faker.guid.guid();
    newValue = faker.randomGenerator.boolean();
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test('should call with correct params', () async {
    await sut.send(
      baseUrl: baseUrl,
      crossIdentity: crossIdentity,
      enterpriseCode: enterpriseCode,
      productPackingCode: productPackingCode,
      newValue: newValue,
    );

    verify(
      () => soapAdapter.post(
        url: baseUrl,
        typeOfResult: null,
        typeOfResponse: "SendToPrintResponse",
        soapAction: "SendToPrint",
        serviceASMX: "CeltaPriceConferenceService.asmx",
        parameters: {
          "crossIdentity": crossIdentity,
          "enterpriseCode": enterpriseCode,
          "productPackingCode": productPackingCode,
          "send": newValue,
        },
      ),
    ).called(1);
  });
}
