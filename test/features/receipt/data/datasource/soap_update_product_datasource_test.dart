import 'package:celta_intelligence/features/receipt/data/datasource/datasource.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapUpdateProductDatasource sut;

  late SoapRequestSpy soapRequest;

  late String baseUrl;
  late Map<String, dynamic> parametersPayload;

  void initSut() {
    sut = SoapUpdateProductDatasource(soapRequest);
  }

  void initInjections() {
    soapRequest = SoapRequestSpy();
  }

  void mockSuccess() {}

  void initEntities() {
    baseUrl = faker.internet.httpUrl();
    parametersPayload = {
      faker.lorem.word(): faker.guid.guid(),
      faker.lorem.word(): faker.randomGenerator.integer(100),
      faker.lorem.word(): faker.lorem.sentence(),
    };
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test('should call soap adapter with correct values', () async {
    await sut.update(baseUrl: baseUrl, parametersPayload: parametersPayload);

    verify(
      () => soapRequest.post(
        url: baseUrl,
        typeOfResponse: "EntryQuantityResponse",
        soapAction: "EntryQuantity",
        serviceASMX: "CeltaGoodsReceivingService.asmx",
        typeOfResult: null,
        parameters: parametersPayload,
      ),
    ).called(1);
  });
}
