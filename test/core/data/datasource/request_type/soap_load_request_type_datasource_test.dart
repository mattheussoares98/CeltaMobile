import 'dart:convert';

import 'package:celta_inventario/core/data/datasource/request_type/request_type.dart';
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapLoadRequestTypeDatasource sut;

  late SoapRequestSpy soapAdapter;

  late String workingUrl;
  late String crossIdentity;
  late List<RequestTypeModel> requestTypeModels;
  late bool inclusiveBuy;
  late bool inclusiveTransfer;
  late bool inclusiveSale;
  late int enterpriseCode;

  void initSut() {
    sut = SoapLoadRequestTypeDatasource(soapAdapter);
  }

  void initInjections() {
    soapAdapter = SoapRequestSpy();
  }

  void mockSuccess() {
    soapAdapter.mockPost(
      json.encode(requestTypeModels.map((e) => e.toJson()).toList()),
    );
  }

  void initEntities() {
    requestTypeModels = [
      EntityFactory.makeRequestTypeEntity(),
      EntityFactory.makeRequestTypeEntity(),
      EntityFactory.makeRequestTypeEntity(),
    ].map((e) => RequestTypeModel.fromEntity(e)).toList();
    workingUrl = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    inclusiveBuy = faker.randomGenerator.boolean();
    inclusiveTransfer = faker.randomGenerator.boolean();
    inclusiveSale = faker.randomGenerator.boolean();
    enterpriseCode = faker.randomGenerator.integer(100);
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test('should call soap adapter with correct values', () async {
    final requests = await sut.load(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      inclusiveBuy: inclusiveBuy,
      inclusiveTransfer: inclusiveTransfer,
      inclusiveSale: inclusiveSale,
      enterpriseCode: enterpriseCode,
    );

    expect(requests, requestTypeModels);

    verify(
      () => soapAdapter.post(
        url: workingUrl,
        serviceASMX: "CeltaRequestTypeService.asmx",
        typeOfResponse: "GetRequestTypesJsonResponse",
        soapAction: "GetRequestTypesJson",
        typeOfResult: "GetRequestTypesJsonResult",
        parameters: {
          "crossIdentity": crossIdentity,
          "inclusiveBuy": inclusiveBuy,
          "inclusiveTransfer": inclusiveTransfer,
          "inclusiveSale": inclusiveSale,
          "enterpriseCode": enterpriseCode,
        },
      ),
    ).called(1);
  });
}
