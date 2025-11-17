import 'dart:convert';

import 'package:celta_intelligence/features/competing_prices/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/competing_prices/data/models/models.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapLoadResearchsDatasource sut;

  late SoapRequestSpy soapRequest;

  late String baseUrl;
  late String crossIdentity;
  late int enterpriseCode;
  late List<ResearchModel> researchsModels;
  late String searchValue;

  void initSut() {
    sut = SoapLoadResearchsDatasource(soapRequest);
  }

  void initInjections() {
    soapRequest = SoapRequestSpy();
  }

  void mockSuccess() {
    soapRequest.mockPost(
      json.encode(researchsModels.map((e) => e.toJson()).toList()),
    );
  }

  void initEntities() {
    baseUrl = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    enterpriseCode = faker.randomGenerator.integer(1000);
    researchsModels = [
      EntityFactory.makeResearchEntity(),
      EntityFactory.makeResearchEntity(),
      EntityFactory.makeResearchEntity(),
    ].map((e) => ResearchModel.fromEntity(e)).toList();
    searchValue = faker.randomGenerator.boolean()
        ? faker.randomGenerator.integer(100).toString()
        : faker.lorem.word();
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test('Should behave correctly on success', () async {
    final response = await sut.load(
      crossIdentity: crossIdentity,
      baseUrl: baseUrl,
      enterpriseCode: enterpriseCode,
      searchValue: searchValue,
    );

    expect(response, researchsModels);

    verify(
      () => soapRequest.post(
        url: baseUrl,
        typeOfResponse: "GetResearchOfPriceJsonResponse",
        soapAction: "GetResearchOfPriceJson",
        serviceASMX: "CeltaResearchOfPriceService.asmx",
        typeOfResult: "GetResearchOfPriceJsonResult",
        parameters: {
          "json": json.encode({
            "CrossIdentity": crossIdentity,
            "EnterpriseCode": enterpriseCode,
            // "InitialCreationDate": "0001-01-01T00:00:00",
            // "FinalCreationDate": DateTime.now().toIso8601String(),
            "SearchValue": searchValue,
            "SearchTypeInt": searchValue is int ? 1 : 2,
          }),
        },
      ),
    ).called(1);
  });
  test('Should call with empty value if pass a null value to search', () async {
    final response = await sut.load(
      crossIdentity: crossIdentity,
      baseUrl: baseUrl,
      enterpriseCode: enterpriseCode,
    );

    expect(response, researchsModels);

    verify(
      () => soapRequest.post(
        url: baseUrl,
        typeOfResponse: "GetResearchOfPriceJsonResponse",
        soapAction: "GetResearchOfPriceJson",
        serviceASMX: "CeltaResearchOfPriceService.asmx",
        typeOfResult: "GetResearchOfPriceJsonResult",
        parameters: {
          "json": json.encode({
            "CrossIdentity": crossIdentity,
            "EnterpriseCode": enterpriseCode,
            // "InitialCreationDate": "0001-01-01T00:00:00",
            // "FinalCreationDate": DateTime.now().toIso8601String(),
            "SearchValue": "",
            "SearchTypeInt": searchValue is int ? 1 : 2,
          }),
        },
      ),
    ).called(1);
  });
}
