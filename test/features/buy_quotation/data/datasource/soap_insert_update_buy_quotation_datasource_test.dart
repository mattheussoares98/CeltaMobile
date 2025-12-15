import 'dart:convert';

import 'package:celta_intelligence/features/buy_quotation/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/buy_quotation/data/models/models.dart';
import 'package:celta_intelligence/features/buy_quotation/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapInsertUpdateBuyQuotationDatasource sut;

  late SoapRequestSpy soapRequest;
  late BuyQuotationModel buyQuotation;
  late String baseUrl;
  late String crossIdentity;

  void initSut() {
    sut = SoapInsertUpdateBuyQuotationDatasource(soapRequest);
  }

  void initInjections() {
    soapRequest = SoapRequestSpy();
  }

  void mockSuccess() {
    soapRequest.mockPost({});
  }

  void initEntities() {
    buyQuotation = BuyQuotationModel.fromEntity(
      EntityFactory.makeBuyQuotationEntity(),
    );
    baseUrl = faker.internet.httpsUrl();
    crossIdentity = faker.guid.guid();
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  setUpAll(() {});

  test('Should behave correctly on success', () async {
    final response = await sut.load(
      baseUrl: baseUrl,
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
      baseUrl: baseUrl,
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
