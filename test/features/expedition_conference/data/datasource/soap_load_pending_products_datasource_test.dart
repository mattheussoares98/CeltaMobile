import 'dart:convert';

import 'package:celta_intelligence/features/expedition_conference/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/expedition_conference/data/models/models.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapLoadPendingProductsDatasource sut;

  late SoapRequestSpy soapRequest;

  late List<ExpeditionProductModel> expeditionsModels;
  late String baseUrl;
  late String crossIdentity;
  late int expeditionControlCode;

  void initSut() {
    sut = SoapLoadPendingProductsDatasource(soapRequest);
  }

  void initInjections() {
    soapRequest = SoapRequestSpy();
  }

  void mockSuccess() {
    soapRequest.mockPost(
      json.encode(expeditionsModels.map((e) => e.toJson()).toList()),
    );
  }

  void initEntities() {
    expeditionsModels = [
      EntityFactory.makeExpeditionProductEntity(),
      EntityFactory.makeExpeditionProductEntity(),
      EntityFactory.makeExpeditionProductEntity(),
    ].map((e) => ExpeditionProductModel.fromEntity(e)).toList();
    baseUrl = faker.internet.httpsUrl();
    crossIdentity = faker.guid.guid();
    expeditionControlCode = faker.randomGenerator.integer(1000);
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test('should behave correctly in success', () async {
    final result = await sut.load(
      baseUrl: baseUrl,
      crossIdentity: crossIdentity,
      expeditionControlCode: expeditionControlCode,
    );

    expect(result, expeditionsModels);

    verify(
      () => soapRequest.post(
        url: baseUrl,
        typeOfResponse: "GetExpeditionControlProductsResponse",
        soapAction: "GetExpeditionControlProducts",
        serviceASMX: "CeltaProductService.asmx",
        typeOfResult: "GetExpeditionControlProductsResult",
        parameters: {
          "stringFilters": json.encode({
            "CrossIdentity": crossIdentity,
            "ExpeditionControlCode": expeditionControlCode,
          }),
        },
      ),
    ).called(1);
  });
}
