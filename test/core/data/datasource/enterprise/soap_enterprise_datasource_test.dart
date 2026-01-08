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
  late int? enterpriseOriginCode;
  late int? requestTypeCode;

  void initEntities() {
    enterpriseEntities = [
      EntityFactory.makeEnterpriseEntity(),
      EntityFactory.makeEnterpriseEntity(),
      EntityFactory.makeEnterpriseEntity(),
    ];
    url = faker.internet.httpsUrl();
    crossIdentity = faker.guid.guid();
    enterpriseOriginCode = faker.randomGenerator.boolean() == true
        ? faker.randomGenerator.integer(100)
        : null;
    requestTypeCode = faker.randomGenerator.boolean() == true
        ? faker.randomGenerator.integer(100)
        : null;
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
        workingUrl: url,
        crossIdentity: crossIdentity,
        enterpriseOriginCode: enterpriseOriginCode,
        requestTypeCode: requestTypeCode,
      );

      verify(
        () => soapRequest.post(
          url: url.toLowerCase().removeWhiteSpaces(),
          parameters: {
            "crossIdentity": crossIdentity,
            "simpleSearchValue": "",
            if (requestTypeCode != null) "requestTypeCode": requestTypeCode,
            if (enterpriseOriginCode != null)
              "enterpriseOriginCode": enterpriseOriginCode,
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
        sut.getEnterprises(workingUrl: url, crossIdentity: crossIdentity),
        throwsA(isA<BsError>()),
      );
    });
  });
}
