import 'dart:convert';

import 'package:celta_inventario/core/data/datasource/products/products.dart';
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapLoadProductByRequestTypeDatasource sut;

  late SoapRequestSpy soapAdapter;

  late List<ProductEntity> productsEntities;
  late String workingUrl;
  late Map<String, dynamic> parametersPayload;

  void initSut() {
    sut = SoapLoadProductByRequestTypeDatasource(soapAdapter);
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

  test('should call adapter with correct params', () async {
    final products = await sut.load(
      workingUrl: workingUrl,
      parametersPayload: parametersPayload,
    );

    expect(
      products,
      productsEntities.map((e) => ProductModel.fromEntity(e)).toList(),
    );

    verify(
      () => soapAdapter.post(
        url: workingUrl,
        typeOfResponse: "GetProductJsonByRequestTypeResponse",
        soapAction: "GetProductJsonByRequestType",
        serviceASMX: "CeltaProductService.asmx",
        typeOfResult: "GetProductJsonByRequestTypeResult",
        parameters: parametersPayload,
      ),
    ).called(1);
  });
}
