import 'package:celta_inventario/features/search_products/data/datasource/datasource.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapSendToPrintDatasource sut;

  late SoapRequestSpy soapAdapter;

  late String workingUrl;
  late String crossIdentity;
  late int enterpriseCode;
  late int productPackingCode;
  late bool newValue;

  void initSut() {
    sut = SoapSendToPrintDatasource(soapAdapter);
  }

  void initInjections() {
    soapAdapter = SoapRequestSpy();
  }

  void mockSuccess() {}

  void initEntities() {
    workingUrl = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    enterpriseCode = faker.randomGenerator.integer(100);
    productPackingCode = faker.randomGenerator.integer(100);
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
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      enterpriseCode: enterpriseCode,
      productPackingCode: productPackingCode,
      newValue: newValue,
    );

    verify(
      () => soapAdapter.post(
        url: workingUrl,
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
