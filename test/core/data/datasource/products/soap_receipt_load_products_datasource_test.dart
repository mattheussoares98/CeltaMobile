import 'package:celta_intelligence/core/data/datasource/products/products.dart';
import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapReceiptLoadProductsDatasource sut;

  late SoapRequestSpy soapAdapter;

  late List<ProductEntity> productsEntities;
  late String workingUrl;
  late Map<String, dynamic> parametersPayload;

  void initSut() {
    sut = SoapReceiptLoadProductsDatasource(soapAdapter);
  }

  void initInjections() {
    soapAdapter = SoapRequestSpy();
  }

  void mockSuccess() {
    soapAdapter.mockPost({
      'Produtos': productsEntities
          .map((e) => ReceiptProductModel.fromEntity(e).toJson())
          .toList(),
    });
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
    final products = await sut.get(
      workingUrl: workingUrl,
      parametersPayload: parametersPayload,
    );

    expect(
      products,
      productsEntities.map((e) => ReceiptProductModel.fromEntity(e)).toList(),
    );

    verify(
      () => soapAdapter.post(
        url: workingUrl,
        typeOfResponse: "GetProductResponse",
        soapAction: "GetProduct",
        serviceASMX: "CeltaGoodsReceivingService.asmx",
        typeOfResult: "GetProductResult",
        parameters: parametersPayload,
      ),
    ).called(1);
  });
  test('should work correctly when return a single product as Map', () async {
    soapAdapter.mockPost({
      'Produtos': ReceiptProductModel.fromEntity(
        productsEntities.first,
      ).toJson(),
    });

    final products = await sut.get(
      workingUrl: workingUrl,
      parametersPayload: parametersPayload,
    );

    expect(products, [ReceiptProductModel.fromEntity(productsEntities.first)]);

    verify(
      () => soapAdapter.post(
        url: workingUrl,
        typeOfResponse: "GetProductResponse",
        soapAction: "GetProduct",
        serviceASMX: "CeltaGoodsReceivingService.asmx",
        typeOfResult: "GetProductResult",
        parameters: parametersPayload,
      ),
    ).called(1);
  });
}
