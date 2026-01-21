import 'dart:convert';

import 'package:celta_inventario/features/buy_quotation/data/datasource/datasource.dart';
import 'package:celta_inventario/features/buy_quotation/data/models/models.dart';
import 'package:celta_inventario/features/buy_quotation/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapLoadBuyQuotationsDatasource sut;

  late SoapRequestSpy soapRequest;
  late List<BuyQuotationModel> buyQuotationsModels;
  late String workingUrl;
  late String crossIdentity;
  late int enterpriseCode;
  late bool isCompleteSearch;
  late String searchValue;
  late SearchBuyQuotationDataType dataType;
  late bool inclusiveExpired;

  void initSut() {
    sut = SoapLoadBuyQuotationsDatasource(soapRequest);
  }

  void initInjections() {
    soapRequest = SoapRequestSpy();
  }

  void mockSuccess() {
    soapRequest.mockPost(
      json.encode(buyQuotationsModels.map((e) => e.toJson()).toList()),
    );
  }

  void initEntities() {
    buyQuotationsModels = [
      EntityFactory.makeBuyQuotationEntity(),
      EntityFactory.makeBuyQuotationEntity(),
      EntityFactory.makeBuyQuotationEntity(),
    ].map((e) => BuyQuotationModel.fromEntity(e)).toList();

    workingUrl = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    enterpriseCode = faker.randomGenerator.integer(100);
    isCompleteSearch = faker.randomGenerator.boolean();
    searchValue = faker.lorem.word();
    dataType =
        SearchBuyQuotationDataType.values[faker.randomGenerator.integer(
          SearchBuyQuotationDataType.values.length,
        )];
    inclusiveExpired = faker.randomGenerator.boolean();
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  setUpAll(() {
    for (var value in SearchBuyQuotationDataType.values) {
      registerFallbackValue(value);
    }
  });

  test('Should behave correctly on success', () async {
    final response = await sut.load(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      enterpriseCode: enterpriseCode,
      isCompleteSearch: isCompleteSearch,
      searchValue: searchValue,
      dataType: dataType,
      inclusiveExpired: inclusiveExpired,
    );

    expect(response, buyQuotationsModels);

    verify(
      () => soapRequest.post(
        url: workingUrl,
        typeOfResponse: "GetBuyQuotationJsonResponse",
        soapAction: "GetBuyQuotationJson",
        serviceASMX: "CeltaBuyRequestService.asmx",
        typeOfResult: "GetBuyQuotationJsonResult",
        parameters: {
          "filters": json.encode({
            "CrossIdentity": crossIdentity,
            "Complete": isCompleteSearch,
            "Data": searchValue,
            "EnterpriseCode": enterpriseCode,
            "DataType": dataType.code,
            "InclusiveExpired": inclusiveExpired,
            "InitialDateOfCreation": null,
            "FinalDateOfCreation": null,
            "InitialDateOfLimit": null,
            "FinalDateOfLimit": null,
            "ProductCode": null,
            "ProductPackingCode": null,
            "SupplierCode": null,
            "BuyerCode": null,
          }),
        },
      ),
    ).called(1);
  });

  test('Should return null if dateOfLimit is 01/01/0001', () async {
    soapRequest.mockPost(
      json.encode([
        BuyQuotationModel.fromEntity(
          EntityFactory.makeBuyQuotationEntity(
            dateOfLimit: DateTime(0001, 01, 01),
          ),
        ),
      ]),
    );

    final response = await sut.load(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      enterpriseCode: enterpriseCode,
      isCompleteSearch: isCompleteSearch,
      searchValue: searchValue,
      dataType: dataType,
      inclusiveExpired: inclusiveExpired,
    );

    expect(response.first.DateOfLimit, isNull);
  });
}
