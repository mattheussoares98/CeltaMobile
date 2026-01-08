import 'dart:convert';

import 'package:celta_intelligence/features/buy_request/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/buy_request/data/models/models.dart';
import 'package:celta_intelligence/features/buy_request/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapInsertBuyRequestDatasource sut;

  late SoapRequestSpy soapRequest;

  late String savedRequestNumber;
  late String urlInUse;
  late String crossIdentity;
  late int buyerCode;
  late int requestTypeCode;
  late int supplierCode;
  late String? observations;
  late List<int> enterpriseCodes;
  late List<BuyRequestProductItemEntity> products;

  void initSut() {
    sut = SoapInsertBuyRequestDatasource(soapRequest);
  }

  void initInjections() {
    soapRequest = SoapRequestSpy();
  }

  void mockSuccess() {
    soapRequest.mockPost(savedRequestNumber);
  }

  void initEntities() {
    savedRequestNumber = faker.lorem.word();
    urlInUse = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    buyerCode = faker.randomGenerator.integer(100);
    requestTypeCode = faker.randomGenerator.integer(100);
    supplierCode = faker.randomGenerator.integer(100);
    observations = faker.lorem.word();
    enterpriseCodes = [
      faker.randomGenerator.integer(100, min: 0),
      faker.randomGenerator.integer(200, min: 101),
      faker.randomGenerator.integer(300, min: 201),
    ];
    products = enterpriseCodes
        .map(
          (e) =>
              EntityFactory.makeBuyRequestProductItemEntity(enterpriseCode: e),
        )
        .toList();
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test('Should behave correctly on success', () async {
    final response = await sut.insertBuyRequest(
      urlInUse: urlInUse,
      crossIdentity: crossIdentity,
      buyerCode: buyerCode,
      requestTypeCode: requestTypeCode,
      supplierCode: supplierCode,
      observations: observations,
      enterpriseCodes: enterpriseCodes,
      products: products
          .map((e) => BuyRequestProductItemModel.fromEntity(e))
          .toList(),
    );

    expect(response, savedRequestNumber);

    verify(
      () => soapRequest.post(
        url: urlInUse,
        serviceASMX: "CeltaBuyRequestService.asmx",
        typeOfResponse: "InsertResponse",
        soapAction: "Insert",
        typeOfResult: "InsertResult",
        parameters: {
          "json": json.encode({
            "CrossIdentity": crossIdentity,
            "BuyerCode": buyerCode,
            "RequestTypeCode": requestTypeCode,
            "SupplierCode": supplierCode,
            "Observations": observations,
            "Enterprises": enterpriseCodes
                .map(
                  (e) => {
                    "IsPrincipal": e == enterpriseCodes.first,
                    "EnterpriseCode": e,
                  },
                )
                .toList(),
            "Products": products
                .map(
                  (e) => {
                    'EnterpriseCode': e.product.EnterpriseCode,
                    'ProductPackingCode': e.product.ProductPackingCode,
                    'Value': e.cost,
                    'Quantity': e.quantity,
                    'IncrementPercentageOrValue': "R\$",
                    'IncrementValue': 0,
                    'DiscountPercentageOrValue': "R\$",
                    'DiscountValue': 0,
                  },
                )
                .toList(),
          }),
        },
      ),
    ).called(1);
  });
}
