import 'dart:convert';

import 'package:celta_inventario/features/competing_prices/data/datasource/datasource.dart';
import 'package:celta_inventario/features/competing_prices/data/models/models.dart';
import 'package:celta_inventario/features/competing_prices/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapConcurrentsDatasource sut;

  late SoapRequestSpy soapRequest;

  late String workingUrl;
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
    workingUrl = faker.internet.httpUrl();
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

  group('Load', () {
    test('Should behave correctly on success', () async {
      final response = await sut.load(
        crossIdentity: crossIdentity,
        workingUrl: workingUrl,
        searchValue: searchValue,
        searchType: searchConcurrentType,
      );

      expect(response, concurrentModels);

      verify(
        () => soapRequest.post(
          url: workingUrl,
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
  });

  group('Insert update', () {
    test('Should call soap with correct params', () async {
      await sut.insertUpdate(
        crossIdentity: crossIdentity,
        workingUrl: workingUrl,
        concurrent: concurrentModels.first,
      );

      verify(
        () => soapRequest.post(
          url: workingUrl,
          typeOfResponse: "InsertUpdateConcurrentJsonResponse",
          soapAction: "InsertUpdateConcurrentJson",
          serviceASMX: "CeltaResearchOfPriceService.asmx",
          typeOfResult: "InsertUpdateConcurrentJsonResult",
          parameters: {
            "json": json.encode({
              "ConcurrentCode": concurrentModels.first.ConcurrentCode,
              "CrossIdentity": crossIdentity,
              "Name": concurrentModels.first.Name,
              "Observation": concurrentModels.first.Observation,
              "Address": concurrentModels.first.Address?.toJson(),
            }),
          },
        ),
      ).called(1);
    });
  });
}
