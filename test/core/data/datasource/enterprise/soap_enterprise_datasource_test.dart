import 'dart:convert';

import 'package:celta_intelligence/core/data/datasource/enterprise/enterprise.dart';
import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/domain/errors/errors.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late SoapEnterpriseDatasource sut;

  late SoapRequestSpy soapRequest;

  late List<EnterpriseEntity> enterpriseEntities;
  late String url;
  late String crossIdentity;

  void initEntities() {
    enterpriseEntities = [
      EntityFactory.makeEnterpriseEntity(),
      EntityFactory.makeEnterpriseEntity(),
      EntityFactory.makeEnterpriseEntity(),
    ];
    url = faker.internet.httpsUrl();
    crossIdentity = faker.guid.guid();
  }

  void initSut() {
    sut = SoapEnterpriseDatasource(soapAdapter: soapRequest);
  }

  void initInjections() {
    soapRequest = SoapRequestSpy();
  }

  void mockSuccess() {
    soapRequest.mockPost(
      json.encode(
        enterpriseEntities
            .map((e) => SoapEnterpriseModel.fromEntity(e).toJson())
            .toList(),
      ),
    );
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  group('Get enterprise', () {
    test('should behave correctly on success', () async {
      final result = await sut.getEnterprises(
        baseUrl: url,
        crossIdentity: crossIdentity,
      );

      verify(
        () => soapRequest.post(
          url: url.toLowerCase().removeWhiteSpaces(),
          parameters: {
            "crossIdentity": crossIdentity,
            "simpleSearchValue": "",
            "requestTypeCode": 0,
          },
          soapAction: "GetEnterprisesJson",
          typeOfResponse: "GetEnterprisesJsonResponse",
          serviceASMX: "celtaenterpriseService.asmx",
          typeOfResult: "GetEnterprisesJsonResult",
        ),
      );

      expect(
        result,
        enterpriseEntities
            .map((e) => SoapEnterpriseModel.fromEntity(e))
            .toList(),
      );
    });
    test('should behave correctly on soap error', () async {
      soapRequest.mockPostError();

      expect(
        sut.getEnterprises(baseUrl: url, crossIdentity: crossIdentity),
        throwsA(isA<BsError>()),
      );
    });
  });
}
