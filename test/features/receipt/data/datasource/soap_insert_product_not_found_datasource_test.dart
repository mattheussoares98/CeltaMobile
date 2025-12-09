import 'package:celta_intelligence/features/receipt/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/receipt/data/model/model.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapInsertProductNotFoundDatasource sut;

  late SoapRequestSpy soapRequest;

  late String baseUrl;
  late String crossIdentity;
  late ProductNotFoundModel product;
  late int receiptCode;

  void initSut() {
    sut = SoapInsertProductNotFoundDatasource(soapRequest);
  }

  void initInjections() {
    soapRequest = SoapRequestSpy();
  }

  void mockSuccess() {}

  void initEntities() {
    baseUrl = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    product = ProductNotFoundModel.fromEntity(
      EntityFactory.makeProductNotFoundEntity(),
    );
    receiptCode = faker.randomGenerator.integer(100);
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test('should call soap adapter with correct values', () async {
    await sut.insert(
      baseUrl: baseUrl,
      crossIdentity: crossIdentity,
      productNotFound: product,
      receiptCode: receiptCode,
    );

    verify(
      () => soapRequest.post(
        url: baseUrl,
        typeOfResponse: "InsertProductWithoutCadasterResponse",
        soapAction: "InsertProductWithoutCadaster",
        serviceASMX: "CeltaGoodsReceivingService.asmx",
        typeOfResult: null,
        parameters: {
          "crossIdentity": crossIdentity,
          "grDocCode": receiptCode,
          "ean": product.ean,
          "observations": product.observations,
          "quantity": product.quantity,
          "grDocProductWithoutCadasterCode": product.internalCode,
        },
      ),
    ).called(1);
  });
  test(
    'should call soap adapter with correct values when product internal code is null',
    () async {
      await sut.insert(
        baseUrl: baseUrl,
        crossIdentity: crossIdentity,
        productNotFound: ProductNotFoundModel.fromEntity(
          product.toEntity().annulValues(annulInternalCode: true),
        ),
        receiptCode: receiptCode,
      );

      verify(
        () => soapRequest.post(
          url: baseUrl,
          typeOfResponse: "InsertProductWithoutCadasterResponse",
          soapAction: "InsertProductWithoutCadaster",
          serviceASMX: "CeltaGoodsReceivingService.asmx",
          typeOfResult: null,
          parameters: {
            "crossIdentity": crossIdentity,
            "grDocCode": receiptCode,
            "ean": product.ean,
            "observations": product.observations,
            "quantity": product.quantity,
          },
        ),
      ).called(1);
    },
  );
}
