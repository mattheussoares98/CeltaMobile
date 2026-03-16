import 'dart:convert';

import 'package:celta_inventario/features/sale_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/sale_request/data/models/models.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapProcessCartDatasource sut;

  late SoapRequestSpy soapRequest;

  late String crossId;
  late String workingUrl;
  late int enterpriseCode;
  late int requestTypeCode;
  late int customerCode;
  late int? covenantCode;
  late List<SoapSaleRequestProductModel> products;
  late SoapProcessedCartModel processedCart;

  void initSut() {
    sut = SoapProcessCartDatasource(soapRequest);
  }

  void initInjections() {
    soapRequest = SoapRequestSpy();
  }

  void mockSuccess() {
    soapRequest.mockPost(json.encode(processedCart));
  }

  void initEntities() {
    workingUrl = faker.internet.httpsUrl();
    enterpriseCode = faker.randomGenerator.integer(1000);
    requestTypeCode = faker.randomGenerator.integer(1000);
    customerCode = faker.randomGenerator.integer(1000);
    covenantCode = faker.randomGenerator.integer(1000);
    crossId = faker.guid.guid();
    products = [
      EntityFactory.makeCartProductEntity(),
      EntityFactory.makeCartProductEntity(),
      EntityFactory.makeCartProductEntity(),
    ].map((e) => SoapSaleRequestProductModel.fromEntity(e)).toList();
    processedCart = SoapProcessedCartModel(
      crossId: crossId,
      EnterpriseCode: enterpriseCode,
      RequestTypeCode: requestTypeCode,
      SellerCode: faker.randomGenerator.integer(100),
      CovenantCode: covenantCode,
      CustomerCode: customerCode,
      Products: products,
      Instructions: faker.lorem.sentence(),
      Observations: faker.lorem.sentence(),
    );
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test('should call with correct params', () async {
    final result = await sut.process(
      crossId: crossId,
      workingUrl: workingUrl,
      enterpriseCode: enterpriseCode,
      requestTypeCode: requestTypeCode,
      customerCode: customerCode,
      covenantCode: covenantCode,
      products: products,
    );

    expect(result, processedCart);

    verify(
      () => soapRequest.post(
        url: workingUrl,
        typeOfResponse: "ProcessCartResponse",
        soapAction: "ProcessCart",
        serviceASMX: "CeltaSaleRequestService.asmx",
        typeOfResult: "ProcessCartResult",
        parameters: {
          "crossIdentity": crossId,
          "json": json.encode({
            "EnterpriseCode": enterpriseCode,
            "RequestTypeCode": requestTypeCode,
            "CovenantCode": covenantCode,
            "CustomerCode": customerCode,
            "Products": products
                .map(
                  (e) => SoapSaleRequestProductModel.fromEntity(
                    e.toEntity().copyWith(
                      DiscountValue: e.DiscountValue != null
                          ? e.DiscountValue! / e.Quantity
                          : null,
                    ),
                  ).toJson()..remove("product"),
                )
                .toList(),
          }),
        },
      ),
    ).called(1);
  });
  test(
    'should call covenantCode with zero number when pass null value',
    () async {
      final result = await sut.process(
        crossId: crossId,
        workingUrl: workingUrl,
        enterpriseCode: enterpriseCode,
        requestTypeCode: requestTypeCode,
        customerCode: customerCode,
        covenantCode: null,
        products: products,
      );

      expect(result, processedCart);

      verify(
        () => soapRequest.post(
          url: workingUrl,
          typeOfResponse: "ProcessCartResponse",
          soapAction: "ProcessCart",
          serviceASMX: "CeltaSaleRequestService.asmx",
          typeOfResult: "ProcessCartResult",
          parameters: {
            "crossIdentity": crossId,
            "json": json.encode({
              "EnterpriseCode": enterpriseCode,
              "RequestTypeCode": requestTypeCode,
              "CovenantCode": 0,
              "CustomerCode": customerCode,
              "Products": products
                  .map(
                    (e) => SoapSaleRequestProductModel.fromEntity(
                      e.toEntity().copyWith(
                        DiscountValue: e.DiscountValue != null
                            ? e.DiscountValue! / e.Quantity
                            : null,
                      ),
                    ).toJson()..remove("product"),
                  )
                  .toList(),
            }),
          },
        ),
      ).called(1);
    },
  );
}
