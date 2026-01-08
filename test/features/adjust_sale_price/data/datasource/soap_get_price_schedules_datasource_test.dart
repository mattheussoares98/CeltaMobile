import 'dart:convert';

import 'package:celta_intelligence/features/adjust_sale_price/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/adjust_sale_price/data/models/models.dart';
import 'package:celta_intelligence/features/adjust_sale_price/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late SoapGetPriceSchedulesDatasource sut;

  late SoapRequestSpy soapAdapter;

  late String workingUrl;
  late String crossIdentity;
  late int enterpriseCode;
  late int productCode;
  late int productPackingCode;
  late List<PriceScheduleEntity> priceScheduleEntities;

  void initSut() {
    sut = SoapGetPriceSchedulesDatasource(soapRequest: soapAdapter);
  }

  void initInjections() {
    soapAdapter = SoapRequestSpy();
  }

  void mockSuccess() {
    soapAdapter.mockPost(
      json.encode(
        priceScheduleEntities
            .map((e) => PriceScheduleModel.fromEntity(e).toJson())
            .toList(),
      ),
    );
  }

  void initEntities() {
    workingUrl = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    enterpriseCode = faker.randomGenerator.integer(100);
    productCode = faker.randomGenerator.integer(100);
    productPackingCode = faker.randomGenerator.integer(100);
    priceScheduleEntities = [
      EntityFactory.makePriceScheduleEntity(),
      EntityFactory.makePriceScheduleEntity(),
      EntityFactory.makePriceScheduleEntity(),
    ];
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test('should behave correctly on success', () async {
    final value = await sut.getPriceSchedules(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      enterpriseCode: enterpriseCode,
      productCode: productCode,
      productPackingCode: productPackingCode,
    );

    expect(
      value,
      priceScheduleEntities
          .map((e) => PriceScheduleModel.fromEntity(e))
          .toList(),
    );

    verify(
      () => soapAdapter.post(
        url: workingUrl,
        typeOfResponse: "GetPriceSchedulesResponse",
        soapAction: "GetPriceSchedules",
        serviceASMX: "CeltaProductService.asmx",
        typeOfResult: "GetPriceSchedulesResult",
        parameters: {
          "filters": json.encode({
            "CrossIdentity": crossIdentity,
            "EnterpriseCode": enterpriseCode,
            "ProductCode": productCode,
            "ProductPackingCode": productPackingCode,
            "SaleTypeInt": 1,
          }),
        },
      ),
    ).called(1);
  });

  test("Should behave correctly on error", () async {
    soapAdapter.mockPostError();

    final result = sut.getPriceSchedules(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      enterpriseCode: enterpriseCode,
      productCode: productCode,
      productPackingCode: productPackingCode,
    );

    expect(result, throwsA(isA<Exception>()));
  });
}
