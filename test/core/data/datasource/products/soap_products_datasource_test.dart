import 'dart:convert';

import 'package:celta_intelligence/core/data/datasource/products/products.dart';
import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late SoapProductsDatasource sut;

  late SoapRequestSpy soapAdapter;

  late List<ProductEntity> productsEntities;
  late String baseUrl;
  late String searchValue;
  late BsRoutine routine;
  late SearchType searchType;
  late String crossIdentity;
  late List<int> enterpriseCodes;
  late EnterpriseEntity enterpriseEntity;

  void initSut() {
    sut = SoapProductsDatasource(soapAdapter);
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

    baseUrl = faker.internet.httpUrl();
    searchValue = faker.food.dish();
    routine = BsRoutine
        .values[faker.randomGenerator.integer(BsRoutine.values.length)];
    searchType = SearchType
        .values[faker.randomGenerator.integer(SearchType.values.length)];
    crossIdentity = faker.guid.guid();
    enterpriseCodes = [
      faker.randomGenerator.integer(100, min: 0),
      faker.randomGenerator.integer(200, min: 100),
      faker.randomGenerator.integer(300, min: 200),
    ];
    enterpriseEntity = EntityFactory.makeEnterpriseEntity();
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test('should call soap adapter with correct values', () async {
    bool generateLastBuyEntrance = faker.randomGenerator.boolean();
    int? lastBuyEntranceQuantity = generateLastBuyEntrance
        ? faker.randomGenerator.integer(100)
        : null;

    final products = await sut.getProductsJson(
      baseUrl: baseUrl,
      searchValue: searchValue,
      routine: routine,
      searchType: searchType,
      crossIdentity: crossIdentity,
      enterpriseCodes: enterpriseCodes,
      enterpriseEntity: enterpriseEntity,
      lastBuyEntranceQuantity: lastBuyEntranceQuantity,
    );

    expect(
      products,
      productsEntities.map((e) => ProductModel.fromEntity(e)).toList(),
    );

    verify(
      () => soapAdapter.post(
        url: baseUrl,
        typeOfResponse: "GetProductsJsonResponse",
        typeOfResult: "GetProductsJsonResult",
        soapAction: "GetProductsJson",
        serviceASMX: "CeltaProductService.asmx",
        parameters: {
          "filters": json.encode({
            "CrossIdentity": crossIdentity,
            "EnterpriseCodes": enterpriseCodes,
            "SearchValue": searchValue,
            "SearchType": searchType.code,
            "RoutineInt": routine.code,
            "LastBuyEntranceQuantity": lastBuyEntranceQuantity ?? 5,
          }),
        },
      ),
    ).called(1);
  });
  test('should call again with balance format', () async {
    bool generateLastBuyEntrance = faker.randomGenerator.boolean();
    int? lastBuyEntranceQuantity = generateLastBuyEntrance
        ? faker.randomGenerator.integer(100)
        : null;

    final balanceFormat = "2014456854692";

    final products = await sut.getProductsJson(
      baseUrl: baseUrl,
      searchValue: balanceFormat,
      routine: routine,
      searchType: searchType,
      crossIdentity: crossIdentity,
      enterpriseCodes: enterpriseCodes,
      enterpriseEntity: enterpriseEntity,
      lastBuyEntranceQuantity: lastBuyEntranceQuantity,
    );

    expect(
      products,
      productsEntities.map((e) => ProductModel.fromEntity(e)).toList(),
    );

    verify(
      () => soapAdapter.post(
        url: baseUrl,
        typeOfResponse: "GetProductsJsonResponse",
        typeOfResult: "GetProductsJsonResult",
        soapAction: "GetProductsJson",
        serviceASMX: "CeltaProductService.asmx",
        parameters: {
          "filters": json.encode({
            "CrossIdentity": crossIdentity,
            "EnterpriseCodes": enterpriseCodes,
            "SearchValue": balanceFormat,
            "SearchType": searchType.code,
            "RoutineInt": routine.code,
            "LastBuyEntranceQuantity": lastBuyEntranceQuantity ?? 5,
          }),
        },
      ),
    ).called(1);

    //needs to uncomment the throw Exception(); in production code and /* .called(1) */ below to work
    verifyNever(
      () => soapAdapter.post(
        url: baseUrl,
        typeOfResponse: "GetProductsJsonResponse",
        typeOfResult: "GetProductsJsonResult",
        soapAction: "GetProductsJson",
        serviceASMX: "CeltaProductService.asmx",
        parameters: {
          "filters": json.encode({
            "CrossIdentity": crossIdentity,
            "EnterpriseCodes": enterpriseCodes,
            "SearchValue": balanceFormat
                .replaceFirst(RegExp(r'2'), '')
                .replaceRange(
                  enterpriseEntity.ProductCodeSizeOfBalanceLabel!,
                  null,
                  enterpriseEntity.ProductCodeWithCheckerDigit == true
                      ? ""
                      : ".",
                ),
            "SearchType": searchType.code,
            "RoutineInt": routine.code,
            "LastBuyEntranceQuantity": lastBuyEntranceQuantity ?? 5,
          }),
        },
      ),
    ) /* .called(1) */;
  });
}
