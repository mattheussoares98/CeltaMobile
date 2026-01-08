import 'dart:convert';

import 'package:celta_intelligence/features/expedition_conference/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/expedition_conference/data/models/models.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapLoadExpeditionDocumentsDatasource sut;

  late SoapRequestSpy soapRequest;

  late List<ExpeditionDocumentModel> expeditionsModels;
  late String urlInUse;
  late String crossIdentity;
  late int enterpriseCode;

  void initSut() {
    sut = SoapLoadExpeditionDocumentsDatasource(soapRequest);
  }

  void initInjections() {
    soapRequest = SoapRequestSpy();
  }

  void mockSuccess() {
    soapRequest.mockPost(
      json.encode(expeditionsModels.map((e) => e.toJson()).toList()),
    );
  }

  void initEntities() {
    expeditionsModels = [
      EntityFactory.makeExpeditionDocumentEntity(),
      EntityFactory.makeExpeditionDocumentEntity(),
      EntityFactory.makeExpeditionDocumentEntity(),
    ].map((e) => ExpeditionDocumentModel.fromEntity(e)).toList();
    urlInUse = faker.internet.httpsUrl();
    crossIdentity = faker.guid.guid();
    enterpriseCode = faker.randomGenerator.integer(1000);
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test('should call with correct params', () async {
    final result = await sut.load(
      urlInUse: urlInUse,
      crossIdentity: crossIdentity,
      enterpriseCode: enterpriseCode,
    );

    expect(result, expeditionsModels);

    verify(
      () => soapRequest.post(
        url: urlInUse,
        typeOfResponse: "GetExpeditionControlsToConferenceResponse",
        soapAction: "GetExpeditionControlsToConference",
        serviceASMX: "celtaproductservice.asmx",
        typeOfResult: "GetExpeditionControlsToConferenceResult",
        parameters: {
          "stringFilters": json.encode({
            "CrossIdentity": crossIdentity,
            "EnterpriseCode": enterpriseCode,
          }),
        },
      ),
    ).called(1);
  });
}
