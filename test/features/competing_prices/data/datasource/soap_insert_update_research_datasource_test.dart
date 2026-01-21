import 'dart:convert';

import 'package:celta_inventario/features/competing_prices/data/datasource/datasource.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapInsertUpdateResearchDatasource sut;

  late SoapRequestSpy soapRequest;

  late String workingUrl;
  late String crossIdentity;
  late int enterpriseCode;
  late String observations;
  late String name;
  late int researchCode;
  late Map<String, dynamic> associatingConcurrentParams;

  void initSut() {
    sut = SoapInsertUpdateResearchDatasource(soapRequest);
  }

  void initInjections() {
    soapRequest = SoapRequestSpy();
  }

  void mockSuccess() {}

  void initEntities() {
    workingUrl = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    enterpriseCode = faker.randomGenerator.integer(1000);
    observations = faker.lorem.sentence();
    name = faker.lorem.word();
    researchCode = faker.randomGenerator.integer(100);
    associatingConcurrentParams = {};
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test('Should behave correctly on success', () async {
    await sut.insertUpdate(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      enterpriseCode: enterpriseCode,
      name: name,
      observations: observations,
      researchCode: researchCode,
      associateConcurrentParams: associatingConcurrentParams,
    );

    verify(
      () => soapRequest.post(
        url: workingUrl,
        typeOfResponse: "InsertUpdateResearchOfPriceResponse",
        soapAction: "InsertUpdateResearchOfPrice",
        serviceASMX: "CeltaResearchOfPriceService.asmx",
        typeOfResult: "InsertUpdateResearchOfPriceResult",
        parameters: {
          "json": json.encode({
            "CrossIdentity": crossIdentity,
            "Code": researchCode,
            "EnterpriseCode": enterpriseCode,
            "Name": name,
            "Observation": observations,
            ...associatingConcurrentParams,
          }),
        },
      ),
    ).called(1);
  });
}
