import 'dart:convert';

import 'package:celta_intelligence/features/competing_prices/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/competing_prices/data/models/models.dart';
import 'package:celta_intelligence/features/competing_prices/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapConcurrentsDatasource sut;

  late SoapRequestSpy soapRequest;

  late String baseUrl;
  late String crossIdentity;
  late List<ConcurrentModel> concurrentModels;
  late String searchValue;
  late SearchConcurrentType searchConcurrentType;

  void initSut() {
    sut = SoapConcurrentsDatasource(soapRequest);
  }

  void initInjections() {
    soapRequest = SoapRequestSpy();
  }

  void mockSuccess() {
    soapRequest.mockPost(
      json.encode(concurrentModels.map((e) => e.toJson()).toList()),
    );
  }

  void initEntities() {
    baseUrl = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    concurrentModels = [
      EntityFactory.makeConcurrentEntity(),
      EntityFactory.makeConcurrentEntity(),
      EntityFactory.makeConcurrentEntity(),
    ].map((e) => ConcurrentModel.fromEntity(e)).toList();
    searchValue = faker.lorem.word();
    searchConcurrentType =
        SearchConcurrentType.values[faker.randomGenerator.integer(
          SearchConcurrentType.values.length,
        )];
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  setUpAll(() {
    for (var searchType in SearchConcurrentType.values) {
      registerFallbackValue(searchType);
    }
  });

  test('Should behave correctly on success', () async {
    final response = await sut.load(
      crossIdentity: crossIdentity,
      baseUrl: baseUrl,
      searchValue: searchValue,
      searchType: searchConcurrentType,
    );

    expect(response, concurrentModels);

    verify(
      () => soapRequest.post(
        url: baseUrl,
        soapAction: "GetConcurrentJson",
        typeOfResponse: "GetConcurrentJsonResponse",
        serviceASMX: "CeltaResearchOfPriceService.asmx",
        typeOfResult: "GetConcurrentJsonResult",
        parameters: {
          "json": json.encode({
            "CrossIdentity": crossIdentity,
            "SearchValue": searchValue,
            "SearchTypeInt": searchConcurrentType.code,
          }),
        },
      ),
    ).called(1);
  });
}
