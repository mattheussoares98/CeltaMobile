import 'package:celta_intelligence/core/data/datasource/products/products.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/features/inventory/data/models/models.dart';
import 'package:celta_intelligence/features/inventory/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapInventoryLoadProductsDatasource sut;

  late SoapRequestSpy soapAdapter;

  late List<InventoryProductEntity> productsEntities;
  late String baseUrl;
  late Map<String, dynamic> parametersPayload;

  void initSut() {
    sut = SoapInventoryLoadProductsDatasource(soapAdapter);
  }

  void initInjections() {
    soapAdapter = SoapRequestSpy();
  }

  void mockSuccess() {
    soapAdapter.mockPost({
      'Produtos': productsEntities
          .map((e) => InventoryProductModel.fromEntity(e).toJson())
          .toList(),
    });
  }

  void initEntities() {
    productsEntities = [
      EntityFactory.makeInventoryProductEntity(),
      EntityFactory.makeInventoryProductEntity(),
      EntityFactory.makeInventoryProductEntity(),
    ];

    baseUrl = faker.internet.httpUrl();
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
      baseUrl: baseUrl,
      parametersPayload: parametersPayload,
    );

    expect(
      products,
      productsEntities.map((e) => InventoryProductModel.fromEntity(e)).toList(),
    );

    verify(
      () => soapAdapter.post(
        url: baseUrl,
        typeOfResponse: "GetProductResponse",
        soapAction: "GetProduct",
        serviceASMX: "CeltaInventoryService.asmx",
        typeOfResult: "GetProductResult",
        parameters: parametersPayload,
      ),
    ).called(1);
  });
}
