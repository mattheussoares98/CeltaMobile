import 'dart:convert';

import 'package:celta_inventario/features/expedition_conference/data/datasource/datasource.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapConfirmConferenceDatasource sut;

  late SoapRequestSpy soapRequest;

  late String workingUrl;
  late String crossIdentity;
  late int expeditionControlCode;
  late int stepCode;

  void initSut() {
    sut = SoapConfirmConferenceDatasource(soapRequest);
  }

  void initInjections() {
    soapRequest = SoapRequestSpy();
  }

  void mockSuccess() {}

  void initEntities() {
    workingUrl = faker.internet.httpsUrl();
    crossIdentity = faker.guid.guid();
    expeditionControlCode = faker.randomGenerator.integer(1000);
    stepCode = faker.randomGenerator.integer(1000);
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test('should call with correct params', () async {
    await sut.confirm(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      expeditionControlCode: expeditionControlCode,
      stepCode: stepCode,
    );

    verify(
      () => soapRequest.post(
        url: workingUrl,
        typeOfResponse: "ConfirmConferenceResponse",
        soapAction: "ConfirmConference",
        serviceASMX: "CeltaProductService.asmx",
        typeOfResult: null,
        parameters: {
          "parametersString": json.encode({
            "CrossIdentity": crossIdentity,
            "ExpeditionControlCode": expeditionControlCode,
            "StepCode": stepCode,
            "Confered": true,
          }),
        },
      ),
    ).called(1);
  });
}
