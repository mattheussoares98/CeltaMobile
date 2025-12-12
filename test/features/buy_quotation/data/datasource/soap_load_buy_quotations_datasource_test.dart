import 'dart:convert';

import 'package:celta_intelligence/features/buy_quotation/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/buy_quotation/data/models/models.dart';
import 'package:celta_intelligence/features/buy_quotation/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapLoadBuyQuotationsDatasource sut;

  late SoapRequestSpy soapRequest;
  late List<BuyQuotationModel> buyQuotationsModels;
  late String baseUrl;
  late String crossIdentity;
  late int enterpriseCode;
  late bool isCompleteSearch;
  late String searchValue;
  late SearchBuyQuotationDataType dataType;

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

    baseUrl = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    enterpriseCode = faker.randomGenerator.integer(100);
    isCompleteSearch = faker.randomGenerator.boolean();
    searchValue = faker.lorem.word();
    dataType =
        SearchBuyQuotationDataType.values[faker.randomGenerator.integer(
          SearchBuyQuotationDataType.values.length,
        )];
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
      baseUrl: baseUrl,
      crossIdentity: crossIdentity,
      enterpriseCode: enterpriseCode,
      isCompleteSearch: isCompleteSearch,
      searchValue: searchValue,
      dataType: dataType,
    );

    expect(response, buyQuotationsModels);

    verify(
      () => soapRequest.post(
        url: baseUrl,
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
            "InitialDateOfCreation": null,
            "FinalDateOfCreation": null,
            "InitialDateOfLimit": null,
            "FinalDateOfLimit": null,
            "ProductCode": null,
            "ProductPackingCode": null,
            "SupplierCode": null,
            "BuyerCode": null,
            "InclusiveExpired": null,
          }),
        },
      ),
    ).called(1);
  });
}
