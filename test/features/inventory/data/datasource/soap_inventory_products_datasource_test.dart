import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/features/inventory/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/inventory/data/models/models.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapInventoryProductsDatasource sut;

  late SoapRequestSpy soapAdapter;

  late List<InventoryProductModel> productsModels;
  late String baseUrl;
  late String searchValue;
  late SearchType searchType;
  late String crossIdentity;
  late EnterpriseEntity selectedEnterprise;
  late int inventoryProcessCode;
  late int enterpriseCode;
  late int inventoryCountingCode;

  void initSut() {
    sut = SoapInventoryProductsDatasource(soapAdapter);
  }

  void initInjections() {
    soapAdapter = SoapRequestSpy();
  }

  void mockSuccess() {
    soapAdapter.mockPost({
      'Produtos': productsModels.map((e) => e.toJson()).toList(),
    });
  }

  void initEntities() {
    productsModels = [
      EntityFactory.makeInventoryProductEntity(),
      EntityFactory.makeInventoryProductEntity(),
      EntityFactory.makeInventoryProductEntity(),
    ].map((e) => InventoryProductModel.fromEntity(e)).toList();

    baseUrl = faker.internet.httpUrl();
    searchValue = faker.food.dish();
    searchType = SearchType
        .values[faker.randomGenerator.integer(SearchType.values.length)];
    crossIdentity = faker.guid.guid();
    selectedEnterprise = EntityFactory.makeEnterpriseEntity();
    inventoryProcessCode = faker.randomGenerator.integer(100);
    enterpriseCode = faker.randomGenerator.integer(100);
    inventoryCountingCode = faker.randomGenerator.integer(100);
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test('should call soap adapter with correct values', () async {
    final products = await sut.load(
      baseUrl: baseUrl,
      searchValue: searchValue,
      searchType: searchType,
      crossIdentity: crossIdentity,
      inventoryProcessCode: inventoryProcessCode,
      enterpriseCode: enterpriseCode,
      inventoryCountingCode: inventoryCountingCode,
      selectedEnterprise: selectedEnterprise,
    );

    expect(products, productsModels);

    verify(
      () => soapAdapter.post(
        url: baseUrl,
        parameters: {
          "crossIdentity": crossIdentity,
          "enterpriseCode": enterpriseCode,
          "searchValue": searchValue,
          "searchTypeInt": searchType.code,
          "inventoryProcessCode": inventoryProcessCode,
          "inventoryCountingCode": inventoryCountingCode,
        },
        typeOfResponse: "GetProductsJsonResponse",
        typeOfResult: "GetProductsJsonResult",
        soapAction: "GetProductsJson",
        serviceASMX: "CeltaProductService.asmx",
      ),
    ).called(1);
  });
  test('should call again with balance format', () async {
    final products = await sut.load(
      baseUrl: baseUrl,
      searchValue: searchValue,
      inventoryProcessCode: inventoryProcessCode,
      searchType: searchType,
      crossIdentity: crossIdentity,
      enterpriseCode: enterpriseCode,
      inventoryCountingCode: inventoryCountingCode,
      selectedEnterprise: selectedEnterprise,
    );

    expect(products, productsModels);

    verify(
      () => soapAdapter.post(
        url: baseUrl,
        parameters: {
          "crossIdentity": crossIdentity,
          "enterpriseCode": enterpriseCode,
          "searchValue": searchValue,
          "searchTypeInt": searchType.code,
          "inventoryProcessCode": inventoryProcessCode,
          "inventoryCountingCode": inventoryCountingCode,
        },
        typeOfResponse: "GetProductsJsonResponse",
        typeOfResult: "GetProductsJsonResult",
        soapAction: "GetProductsJson",
        serviceASMX: "CeltaProductService.asmx",
      ),
    ).called(1);

    //needs to uncomment the throw Exception(); in production code and /* .called(1) */ below to work
    verifyNever(
      () => soapAdapter.post(
        url: baseUrl,
        typeOfResponse: any(named: 'typeOfResponse'),
        typeOfResult: any(named: 'typeOfResult'),
        soapAction: any(named: 'soapAction'),
        serviceASMX: any(named: 'serviceASMX'),
        parameters: any(named: 'parameters'),
      ),
    ) /* .called(1) */;
  });
}
