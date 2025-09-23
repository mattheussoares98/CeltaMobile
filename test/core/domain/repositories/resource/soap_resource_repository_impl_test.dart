import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/domain/repositories/resource/resource.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late SoapResourceRepositoryImpl sut;

  late SoapResourceDatasourceSpy soapResourceDatasource;

  late BsResource resource;
  late BsRoutine routine;
  late String baseUrl;
  late String crossIdentity;
  late bool canAccess;

  void initSut() {
    sut = SoapResourceRepositoryImpl(soapResourceDatasource);
  }

  void initInjections() {
    soapResourceDatasource = SoapResourceDatasourceSpy();
  }

  void mockSuccess() {
    soapResourceDatasource.mockCanAccessResource(canAccess);
  }

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

  test("Should behave correctly on save", () async {
    final value = await sut.canAccessResource(
      resource: resource,
      routine: routine,
      baseUrl: baseUrl,
      crossIdentity: crossIdentity,
    );

    expect(value, canAccess);

    verify(
      () => soapResourceDatasource.canAccessResource(
        resource: resource,
        baseUrl: baseUrl,
        crossIdentity: crossIdentity,
        routine: routine,
      ),
    ).called(1);
  });
}
