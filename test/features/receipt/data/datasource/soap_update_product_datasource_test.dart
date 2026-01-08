import 'package:celta_intelligence/features/receipt/data/datasource/datasource.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapUpdateProductDatasource sut;

  late SoapRequestSpy soapRequest;

  late String urlInUse;
  late String crossIdentity;
  late int grDocCode;
  late int productCode;
  late int productPackingCode;
  late double newQuantity;
  late DateTime? newValidityDate;

  void initSut() {
    sut = SoapUpdateProductDatasource(soapRequest);
  }

  void initInjections() {
    soapRequest = SoapRequestSpy();
  }

  void mockSuccess() {}

  void initEntities() {
    urlInUse = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    grDocCode = faker.randomGenerator.integer(100);
    productCode = faker.randomGenerator.integer(100);
    productPackingCode = faker.randomGenerator.integer(100);
    newQuantity = faker.randomGenerator.decimal();
    newValidityDate = faker.date.dateTime();
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test('should call soap adapter with correct values', () async {
    await sut.update(
      urlInUse: urlInUse,
      crossIdentity: crossIdentity,
      grDocCode: grDocCode,
      productCode: productCode,
      productPackingCode: productPackingCode,
      newQuantity: newQuantity,
      newValidityDate: newValidityDate,
    );

    verify(
      () => soapRequest.post(
        url: urlInUse,
        typeOfResponse: "EntryQuantityResponse",
        soapAction: "EntryQuantity",
        serviceASMX: "CeltaGoodsReceivingService.asmx",
        typeOfResult: null,
        parameters: {
          "crossIdentity": crossIdentity,
          "grDocCode": grDocCode,
          "productgCode": productCode,
          "productPackingCode": productPackingCode,
          "quantity": newQuantity,
          "validityDate": newValidityDate?.toIso8601String(),
        },
      ),
    ).called(1);
  });

  test('should not send validityDate if receive null param', () async {
    await sut.update(
      urlInUse: urlInUse,
      crossIdentity: crossIdentity,
      grDocCode: grDocCode,
      productCode: productCode,
      productPackingCode: productPackingCode,
      newQuantity: newQuantity,
      newValidityDate: null,
    );

    verify(
      () => soapRequest.post(
        url: urlInUse,
        typeOfResponse: "EntryQuantityResponse",
        soapAction: "EntryQuantity",
        serviceASMX: "CeltaGoodsReceivingService.asmx",
        typeOfResult: null,
        parameters: {
          "crossIdentity": crossIdentity,
          "grDocCode": grDocCode,
          "productgCode": productCode,
          "productPackingCode": productPackingCode,
          "quantity": newQuantity,
          // "validityDate": newValidityDate?.toIso8601String(),
        },
      ),
    ).called(1);
  });
}
