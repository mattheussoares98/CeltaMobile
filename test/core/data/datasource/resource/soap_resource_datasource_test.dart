import 'dart:convert';

import 'package:celta_intelligence/core/data/datasource/resource/resource.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late SoapResourceDatasource sut;

  late SoapRequestSpy soapAdapter;

  late BsResource resource;
  late BsRoutine routine;
  late String baseUrl;
  late String crossIdentity;
  late bool canAccess;

  void initSut() {
    sut = SoapResourceDatasource(soapAdapter);
  }

  void initInjections() {
    soapAdapter = SoapRequestSpy();
  }

  void mockSuccess() {}

  void initEntities() {
    resource = BsResource
        .values[faker.randomGenerator.integer(BsResource.values.length)];
    routine = BsRoutine
        .values[faker.randomGenerator.integer(BsRoutine.values.length)];
    baseUrl = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    canAccess = faker.randomGenerator.boolean();
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  setUpAll(() {
    for (var routine in BsRoutine.values) {
      registerFallbackValue(routine);
    }

    for (var resource in BsResource.values) {
      registerFallbackValue(resource);
    }
  });

  group('Can access resource', () {
    test('should behave correctly', () async {
      soapAdapter.mockPost('''{"CanAccess":$canAccess}''');

      final result = await sut.canAccessResource(
        resource: resource,
        baseUrl: baseUrl,
        crossIdentity: crossIdentity,
        routine: routine,
      );

      expect(result, canAccess);

      verify(
        () => soapAdapter.post(
          url: baseUrl.toLowerCase().removeWhiteSpaces(),
          parameters: {
            "jsonParameters": json.encode({
              "CrossIdentity": crossIdentity,
              "ResourceCode": resource.code,
              "RoutineInt": routine.code,
            }),
          },
          typeOfResponse: "UserCanAccessCrossResourceResponse",
          soapAction: "UserCanAccessCrossResource",
          serviceASMX: "CeltaSecurityService.asmx",
          typeOfResult: "UserCanAccessCrossResourceResult",
        ),
      ).called(1);
    });
  });
}
