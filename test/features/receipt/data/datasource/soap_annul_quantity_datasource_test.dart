import 'package:celta_intelligence/features/receipt/data/datasource/datasource.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapAnnulQuantityDatasource sut;

  late SoapRequestSpy soapRequest;

  late String baseUrl;
  late String crossIdentity;
  late int grDocCode;
  late int productgCode;
  late int productPackingCode;

  void initSut() {
    sut = SoapAnnulQuantityDatasource(soapRequest);
  }

  void initInjections() {
    soapRequest = SoapRequestSpy();
  }

  void mockSuccess() {}

  void initEntities() {
    baseUrl = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    grDocCode = faker.randomGenerator.integer(100);
    productgCode = faker.randomGenerator.integer(100);
    productPackingCode = faker.randomGenerator.integer(100);
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test('should call soap adapter with correct values', () async {
    await sut.annul(
      baseUrl: baseUrl,
      crossIdentity: crossIdentity,
      grDocCode: grDocCode,
      productgCode: productgCode,
      productPackingCode: productPackingCode,
    );

    verify(
      () => soapRequest.post(
        url: baseUrl,
        typeOfResponse: "AnnulQuantityResponse",
        soapAction: "AnnulQuantity",
        serviceASMX: "CeltaGoodsReceivingService.asmx",
        typeOfResult: null,
        parameters: {
          "crossIdentity": crossIdentity,
          "grDocCode": grDocCode,
          "productgCode": productgCode,
          "productPackingCode": productPackingCode,
        },
      ),
    ).called(1);
  });
}
