import 'package:celta_intelligence/features/receipt/data/datasource/datasource.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapLiberateDocumentDatasource sut;

  late SoapRequestSpy soapRequest;

  late String workingUrl;
  late String crossIdentity;
  late int CodigoInterno_ProcRecebDoc;

  void initSut() {
    sut = SoapLiberateDocumentDatasource(soapRequest);
  }

  void initInjections() {
    soapRequest = SoapRequestSpy();
  }

  void mockSuccess() {}

  void initEntities() {
    workingUrl = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    CodigoInterno_ProcRecebDoc = faker.randomGenerator.integer(100);
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test('should call soap adapter with correct values', () async {
    await sut.liberate(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      CodigoInterno_ProcRecebDoc: CodigoInterno_ProcRecebDoc,
    );

    verify(
      () => soapRequest.post(
        url: workingUrl,
        typeOfResponse: "LiberateGRDocResponse",
        soapAction: "LiberateGRDoc",
        serviceASMX: "CeltaGoodsReceivingService.asmx",
        typeOfResult: "LiberateGRDocResult",
        parameters: {
          "crossIdentity": crossIdentity,
          "grDocCode": CodigoInterno_ProcRecebDoc,
        },
      ),
    ).called(1);
  });
}
