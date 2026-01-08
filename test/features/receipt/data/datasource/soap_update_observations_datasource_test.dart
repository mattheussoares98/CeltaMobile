import 'package:celta_intelligence/features/receipt/data/datasource/datasource.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapUpdateObservationsDatasource sut;

  late SoapRequestSpy soapRequest;

  late String workingUrl;
  late String crossIdentity;
  late int CodigoInterno_ProcRecebDoc;
  late String observations;

  void initSut() {
    sut = SoapUpdateObservationsDatasource(soapRequest);
  }

  void initInjections() {
    soapRequest = SoapRequestSpy();
  }

  void mockSuccess() {}

  void initEntities() {
    workingUrl = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    CodigoInterno_ProcRecebDoc = faker.randomGenerator.integer(100);
    observations = faker.lorem.sentence();
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test('should call soap adapter with correct values', () async {
    await sut.update(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      CodigoInterno_ProcRecebDoc: CodigoInterno_ProcRecebDoc,
      observations: observations,
    );

    verify(
      () => soapRequest.post(
        url: workingUrl,
        typeOfResponse: "UpdateObservationsResponse",
        soapAction: "UpdateObservations",
        serviceASMX: "CeltaGoodsReceivingService.asmx",
        typeOfResult: null,
        parameters: {
          "crossIdentity": crossIdentity,
          "grDocCode": CodigoInterno_ProcRecebDoc,
          "observations": observations,
        },
      ),
    ).called(1);
  });
}
