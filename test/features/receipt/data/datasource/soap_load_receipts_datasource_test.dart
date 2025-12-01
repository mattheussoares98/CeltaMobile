import 'package:celta_intelligence/features/receipt/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/receipt/data/model/model.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapLoadReceiptsDatasource sut;

  late SoapRequestSpy soapRequest;

  late String baseUrl;
  late String crossIdentity;
  late int enterpriseCode;
  late List<ReceiptModel> receiptModels;

  void initSut() {
    sut = SoapLoadReceiptsDatasource(soapRequest);
  }

  void initInjections() {
    soapRequest = SoapRequestSpy();
  }

  void mockSuccess() {
    soapRequest.mockPost({
      "ProcRecebDocumentos": receiptModels.map((e) => e.toJson()).toList(),
    });
  }

  void initEntities() {
    baseUrl = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    enterpriseCode = faker.randomGenerator.integer(100);
    receiptModels = [
      EntityFactory.makeReceiptEntity(),
      EntityFactory.makeReceiptEntity(),
      EntityFactory.makeReceiptEntity(),
    ].map((e) => ReceiptModel.fromEntity(e)).toList();
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test('should call soap adapter with correct values', () async {
    final response = await sut.loadReceipts(
      baseUrl: baseUrl,
      crossIdentity: crossIdentity,
      enterpriseCode: enterpriseCode,
    );

    expect(response, receiptModels);

    verify(
      () => soapRequest.post(
        url: baseUrl,
        typeOfResponse: "GetActiveGRDocsStatusResponse",
        soapAction: "GetActiveGRDocsStatus",
        serviceASMX: "CeltaGoodsReceivingService.asmx",
        typeOfResult: "GetActiveGRDocsStatusResult",
        parameters: {
          "crossIdentity": crossIdentity,
          "enterpriseCode": enterpriseCode,
        },
      ),
    ).called(1);
  });
}
