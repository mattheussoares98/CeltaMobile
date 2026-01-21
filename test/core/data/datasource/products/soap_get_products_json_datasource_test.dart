import 'dart:convert';

import 'package:celta_inventario/core/data/datasource/products/products.dart';
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapGetProductsJsonDatasource sut;

  late SoapRequestSpy soapAdapter;

  late List<ProductEntity> productsEntities;
  late String workingUrl;
  late Map<String, dynamic> parametersPayload;

  void initSut() {
    sut = SoapGetProductsJsonDatasource(soapAdapter);
  }

  void initInjections() {
    soapAdapter = SoapRequestSpy();
  }

  void mockSuccess() {
    soapAdapter.mockPost(
      json.encode(
        productsEntities
            .map((e) => ProductModel.fromEntity(e).toJson())
            .toList(),
      ),
    );
  }

  void initEntities() {
    productsEntities = [
      EntityFactory.makeProductEntity(),
      EntityFactory.makeProductEntity(),
      EntityFactory.makeProductEntity(),
    ];

    workingUrl = faker.internet.httpUrl();
    parametersPayload = {
      faker.lorem.word(): faker.lorem.word(),
      faker.lorem.word(): faker.randomGenerator.integer(100),
      faker.lorem.word(): faker.person.name(),
    };
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  setUpAll(() {
    for (var value in SearchProductCompetingPriceType.values) {
      registerFallbackValue(value);
    }
  });

  test(
    'should call adapter with correct params and return correct value when is not competing prices',
    () async {
      final products = await sut.get(
        workingUrl: workingUrl,
        parametersPayload: parametersPayload,
        isCompetingPrices: false,
      );

      expect(
        products,
        productsEntities.map((e) => ProductModel.fromEntity(e)).toList(),
      );

      verify(
        () => soapAdapter.post(
          url: workingUrl,
          typeOfResponse: "GetProductsJsonResponse",
          typeOfResult: "GetProductsJsonResult",
          soapAction: "GetProductsJson",
          serviceASMX: "CeltaProductService.asmx",
          parameters: {"filters": json.encode(parametersPayload)},
        ),
      ).called(1);
    },
  );
  test(
    'should call adapter with correct params and return correct value when is competing prices',
    () async {
      soapAdapter.mockPost(
        json.encode(
          productsEntities
              .map((e) => CompetingPriceProductModel.fromEntity(e).toJson())
              .toList(),
        ),
      );

      final products = await sut.get(
        workingUrl: workingUrl,
        parametersPayload: parametersPayload,
        isCompetingPrices: true,
      );

      expect(
        products.map(
          (e) => CompetingPriceProductModel.fromEntity(e.toEntity()),
        ),
        productsEntities
            .map((e) => CompetingPriceProductModel.fromEntity(e))
            .toList(),
      );

      verify(
        () => soapAdapter.post(
          url: workingUrl,
          typeOfResponse: "GetProductsJsonResponse",
          typeOfResult: "GetProductsJsonResult",
          soapAction: "GetProductsJson",
          serviceASMX: "CeltaProductService.asmx",
          parameters: {"filters": json.encode(parametersPayload)},
        ),
      ).called(1);
    },
  );
}
