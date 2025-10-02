import 'dart:convert';

import 'package:celta_intelligence/core/data/datasource/stock/stock.dart';
import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late SoapStockTypeDatasource sut;

  late SoapRequestSpy soapAdapter;

  late String baseUrl;
  late String crossIdentity;
  late List<StockTypeEntity> stockTypeEntities;

  void initSut() {
    sut = SoapStockTypeDatasource(soapAdapter);
  }

  void initInjections() {
    soapAdapter = SoapRequestSpy();
  }

  void mockSuccess() {}

  void initEntities() {
    baseUrl = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    stockTypeEntities = [
      EntityFactory.makeStockTypeEntity(),
      EntityFactory.makeStockTypeEntity(),
      EntityFactory.makeStockTypeEntity(),
    ];
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  setUpAll(() {
    for (var routine in BsRoutine.values) {
      registerFallbackValue(routine);
    }

    for (var resource in BsResource.values) {
      registerFallbackValue(resource);
    }
  });

  group('Can access resource', () {
    test('should behave correctly', () async {
      soapAdapter.mockPost(
        json.encode(
          stockTypeEntities
              .map((e) => StockTypeModel.fromEntity(e).toJson())
              .toList(),
        ),
      );

      final result = await sut.load(
        baseUrl: baseUrl,
        crossIdentity: crossIdentity,
      );

      expect(
        result,
        stockTypeEntities.map((e) => StockTypeModel.fromEntity(e)).toList(),
      );

      verify(
        () => soapAdapter.post(
          url: baseUrl,
          typeOfResponse: "GetStockTypesResponse",
          soapAction: "GetStockTypes",
          serviceASMX: "CeltaProductService.asmx",
          typeOfResult: "GetStockTypesResult",
          parameters: {
            "crossIdentity": crossIdentity,
            "simpleSearchValue": "undefined",
          },
        ),
      ).called(1);
    });
  });
}
