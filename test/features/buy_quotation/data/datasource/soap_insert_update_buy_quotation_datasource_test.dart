import 'dart:convert';

import 'package:celta_intelligence/features/buy_quotation/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/buy_quotation/data/models/models.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapInsertUpdateBuyQuotationDatasource sut;

  late SoapRequestSpy soapRequest;
  late BuyQuotationModel buyQuotation;
  late String workingUrl;
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
    workingUrl = faker.internet.httpsUrl();
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
    await sut.insertUpdate(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      buyQuotation: buyQuotation,
    );

    verify(
      () => soapRequest.post(
        url: workingUrl,
        typeOfResponse: "InsertUpdateBuyQuotationResponse",
        soapAction: "InsertUpdateBuyQuotation",
        serviceASMX: "CeltaBuyRequestService.asmx",
        typeOfResult: "InsertUpdateBuyQuotationResult",
        parameters: {
          "json": json.encode({
            "CrossIdentity": crossIdentity,
            "Code": buyQuotation.Code,
            "DateOfCreation": buyQuotation.DateOfCreation?.toIso8601String(),
            "DateOfLimit": buyQuotation.DateOfLimit?.toIso8601String(),
            "PersonalizedCode": buyQuotation.PersonalizedCode,
            "Observations": buyQuotation.Observations,
            "Buyer": buyQuotation.Buyer?.toJson(),
            "Enterprises": buyQuotation.Enterprises?.map(
              (e) => e.toJson(),
            ).toList(),
            "Products": buyQuotation.Products?.map((e) => e.toJson()).toList(),
          }),
        },
      ),
    ).called(1);
  });
}
