import 'dart:convert';

import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/features/transfer_request/data/datasource/datasource.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapLoadDestinyEnterprisesDatasource sut;

  late SoapRequestSpy soapRequest;

  late List<SoapEnterpriseModel> enterprisesModels;
  late String baseUrl;
  late String crossIdentity;
  late int requestTypeCode;
  late int enterpriseOriginCode;

  void initDependencies() {
    soapRequest = SoapRequestSpy();
  }

  void initSut() {
    sut = SoapLoadDestinyEnterprisesDatasource(soapRequest);
  }

  void initEntities() {
    enterprisesModels = [
      EntityFactory.makeEnterpriseEntity(),
      EntityFactory.makeEnterpriseEntity(),
      EntityFactory.makeEnterpriseEntity(),
    ].map((e) => SoapEnterpriseModel.fromEntity(e)).toList();

    baseUrl = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    requestTypeCode = faker.randomGenerator.integer(100);
    enterpriseOriginCode = faker.randomGenerator.integer(100);
  }

  void mockSuccess() {
    soapRequest.mockPost(
      json.encode(enterprisesModels.map((e) => e.toJson()).toList()),
    );
  }

  setUp(() {
    initEntities();
    initDependencies();
    initSut();
    mockSuccess();
  });

  group('load', () {
    test('should works correctly on success', () async {
      final result = await sut.load(
        baseUrl: baseUrl,
        crossIdentity: crossIdentity,
        requestTypeCode: requestTypeCode,
        enterpriseOriginCode: enterpriseOriginCode,
      );

      // ASSERT
      expect(result, enterprisesModels);

      verify(
        () => soapRequest.post(
          url: baseUrl,
          typeOfResponse: "GetEnterprisesDestinyJsonResponse",
          soapAction: "GetEnterprisesDestinyJson",
          serviceASMX: "CeltaEnterpriseService.asmx",
          typeOfResult: "GetEnterprisesDestinyJsonResult",
          parameters: {
            "crossIdentity": crossIdentity,
            "requestTypeCode": requestTypeCode,
            "enterpriseOriginCode": enterpriseOriginCode,
          },
        ),
      ).called(1);
    });
  });
}
