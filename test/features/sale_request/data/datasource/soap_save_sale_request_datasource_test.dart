import 'dart:convert';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/sale_request/data/models/models.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapSaveSaleRequestDatasource sut;

  late SoapRequestSpy soapRequest;

  late String workingUrl;
  late String crossIdentity;
  late int enterpriseCode;
  late int requestTypeCode;
  late SoapPendingSaleRequestModel saleRequest;
  late String response;

  void initSut() {
    sut = SoapSaveSaleRequestDatasource(soapRequest);
  }

  void initInjections() {
    soapRequest = SoapRequestSpy();
  }

  void mockSuccess() {
    soapRequest.mockPost(response);
  }

  void initEntities() {
    workingUrl = faker.internet.httpsUrl();
    enterpriseCode = faker.randomGenerator.integer(1000);
    requestTypeCode = faker.randomGenerator.integer(1000);
    crossIdentity = faker.guid.guid();
    saleRequest = SoapPendingSaleRequestModel.fromEntity(
      EntityFactory.makePendingSaleRequestEntity(),
    );
    response = faker.randomGenerator.integer(100).toString();
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test('should call with correct params', () async {
    final result = await sut.save(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      enterpriseCode: enterpriseCode,
      requestTypeCode: requestTypeCode,
      saleRequest: saleRequest,
    );

    expect(result, response);

    verify(
      () => soapRequest.post(
        url: workingUrl,
        typeOfResult: null,
        typeOfResponse: "InsertResponse",
        soapAction: "Insert",
        serviceASMX: "CeltaSaleRequestService.asmx",
        parameters: {
          "crossIdentity": crossIdentity,
          "json": json.encode({
            "crossId": crossIdentity,
            "EnterpriseCode": enterpriseCode,
            "RequestTypeCode": requestTypeCode,
            "SellerCode":
                0, //bind to the same seller that is linked in the user register that is saving the sale request
            "CovenantCode": saleRequest.covenant?.covenant?.Code ?? 0,
            "CustomerCode": saleRequest.customer?.Code ?? 0,
            "Instructions": saleRequest.instructions,
            "Observations": saleRequest.observations,
            "Products": saleRequest.cart.values
                .map((e) => e.toJson()..remove('product'))
                .toList(),
          }),
          "printerName": "",
        },
      ),
    ).called(1);
  });
  test(
    'should call covenant and customer with zero number when pass null value',
    () async {
      final result = await sut.save(
        workingUrl: workingUrl,
        crossIdentity: crossIdentity,
        enterpriseCode: enterpriseCode,
        requestTypeCode: requestTypeCode,
        saleRequest: SoapPendingSaleRequestModel.fromEntity(
          saleRequest.toEntity().copyWith(
            customer: CustomerEntity.empty(),
            covenant: CustomerCovenantEntity.empty(),
          ),
        ),
      );

      expect(result, response);

      verify(
        () => soapRequest.post(
          url: workingUrl,
          typeOfResult: null,
          typeOfResponse: "InsertResponse",
          soapAction: "Insert",
          serviceASMX: "CeltaSaleRequestService.asmx",
          parameters: {
            "crossIdentity": crossIdentity,
            "json": json.encode({
              "crossId": crossIdentity,
              "EnterpriseCode": enterpriseCode,
              "RequestTypeCode": requestTypeCode,
              "SellerCode":
                  0, //bind to the same seller that is linked in the user register that is saving the sale request
              "CovenantCode": 0,
              "CustomerCode": 0,
              "Instructions": saleRequest.instructions,
              "Observations": saleRequest.observations,
              "Products": saleRequest.cart.values
                  .map((e) => e.toJson()..remove('product'))
                  .toList(),
            }),
            "printerName": "",
          },
        ),
      ).called(1);
    },
  );
}
