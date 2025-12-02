import 'dart:convert';

import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/features/transfer_request/data/datasource/datasource.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapLoadProductByRequestTypeDatasource sut;

  late SoapRequestSpy soapAdapter;

  late List<ProductEntity> productsEntities;
  late String baseUrl;
  late String searchValue;
  late SearchType searchType;
  late String crossIdentity;
  late EnterpriseEntity enterpriseEntity;
  late int enterpriseOriginCode;
  late int enterpriseDestinyCode;
  late int requestTypeCode;

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

    baseUrl = faker.internet.httpUrl();
    searchValue = faker.food.dish();
    searchType = SearchType
        .values[faker.randomGenerator.integer(SearchType.values.length)];
    crossIdentity = faker.guid.guid();
    enterpriseEntity = EntityFactory.makeEnterpriseEntity();
    enterpriseOriginCode = faker.randomGenerator.integer(100);
    enterpriseDestinyCode = faker.randomGenerator.integer(100);
    requestTypeCode = faker.randomGenerator.integer(100);
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
      crossIdentity: crossIdentity,
      enterpriseOriginCode: enterpriseOriginCode,
      enterpriseDestinyCode: enterpriseDestinyCode,
      requestTypeCode: requestTypeCode,
      searchValue: searchValue,
      enterpriseEntity: enterpriseEntity,
      searchType: searchType,
    );

    expect(
      products,
      productsEntities.map((e) => ProductModel.fromEntity(e)).toList(),
    );

    verify(
      () => soapAdapter.post(
        url: baseUrl,
        parameters: {
          "crossIdentity": crossIdentity,
          "enterpriseCode": enterpriseOriginCode,
          "enterpriseDestinyCode": enterpriseDestinyCode,
          "requestTypeCode": requestTypeCode,
          "searchValue": searchValue,
          "routineTypeInt": BsRoutine.transferRequest.code,
          "searchTypeInt": searchType.code,
        },
        typeOfResponse: "GetProductJsonByRequestTypeResponse",
        soapAction: "GetProductJsonByRequestType",
        serviceASMX: "CeltaProductService.asmx",
        typeOfResult: "GetProductJsonByRequestTypeResult",
      ),
    ).called(1);
  });
  test('should call again with balance format', () async {
    const balanceFormat = "2014456854692";

    final products = await sut.load(
      baseUrl: baseUrl,
      crossIdentity: crossIdentity,
      enterpriseOriginCode: enterpriseOriginCode,
      enterpriseDestinyCode: enterpriseDestinyCode,
      requestTypeCode: requestTypeCode,
      searchValue: balanceFormat,
      enterpriseEntity: enterpriseEntity,
      searchType: searchType,
    );

    expect(
      products,
      productsEntities.map((e) => ProductModel.fromEntity(e)).toList(),
    );

    verify(
      () => soapAdapter.post(
        url: baseUrl,
        parameters: {
          "crossIdentity": crossIdentity,
          "enterpriseCode": enterpriseOriginCode,
          "enterpriseDestinyCode": enterpriseDestinyCode,
          "requestTypeCode": requestTypeCode,
          "searchValue": balanceFormat,
          "routineTypeInt": BsRoutine.transferRequest.code,
          "searchTypeInt": searchType.code,
        },
        typeOfResponse: "GetProductJsonByRequestTypeResponse",
        soapAction: "GetProductJsonByRequestType",
        serviceASMX: "CeltaProductService.asmx",
        typeOfResult: "GetProductJsonByRequestTypeResult",
      ),
    ).called(1);

    //needs to uncomment the throw Exception(); in production code and /* .called(1) */ below to work
    verifyNever(
      () => soapAdapter.post(
        url: any(named: 'url'),
        typeOfResponse: any(named: 'typeOfResponse'),
        typeOfResult: any(named: 'typeOfResult'),
        soapAction: any(named: 'soapAction'),
        serviceASMX: any(named: 'serviceASMX'),
        parameters: any(named: "parameters"),
      ),
    );
  });

  test(
    'should call soap adapter with correct values when buyRequestParams is null',
    () async {
      final products = await sut.load(
        baseUrl: baseUrl,
        crossIdentity: crossIdentity,
        enterpriseOriginCode: enterpriseOriginCode,
        enterpriseDestinyCode: enterpriseDestinyCode,
        requestTypeCode: requestTypeCode,
        searchValue: searchValue,
        enterpriseEntity: enterpriseEntity,
        searchType: searchType,
      );

      expect(
        products,
        productsEntities.map((e) => ProductModel.fromEntity(e)).toList(),
      );

      verify(
        () => soapAdapter.post(
          url: baseUrl,
          typeOfResponse: "GetProductJsonByRequestTypeResponse",
          soapAction: "GetProductJsonByRequestType",
          serviceASMX: "CeltaProductService.asmx",
          typeOfResult: "GetProductJsonByRequestTypeResult",
          parameters: {
            "crossIdentity": crossIdentity,
            "enterpriseCode": enterpriseOriginCode,
            "enterpriseDestinyCode": enterpriseDestinyCode,
            "requestTypeCode": requestTypeCode,
            "searchValue": searchValue,
            "searchTypeInt": searchType.code,
            "routineTypeInt": BsRoutine.transferRequest.code,
          },
        ),
      ).called(1);
    },
  );
}
