import 'dart:convert';

import 'package:celta_inventario/core/data/datasource/bs_version/bs_version.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapBsVersionDatasource sut;

  late SoapRequestSpy soapAdapter;

  late String workingUrl;
  late DateTime bsVersion;

  void initSut() {
    sut = SoapBsVersionDatasource(soapAdapter);
  }

  void initInjections() {
    soapAdapter = SoapRequestSpy();
  }

  void mockSuccess() {
    soapAdapter.mockPost(
      json.encode({'VersionDate': bsVersion.toIso8601String()}),
    );
  }

  void initEntities() {
    workingUrl = faker.internet.httpUrl();
    bsVersion = faker.date.dateTime();
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test('should behave correctly on success', () async {
    final value = await sut.get(workingUrl);

    expect(value, bsVersion);

    verify(
      () => soapAdapter.post(
        url: workingUrl,
        parameters: {},
        typeOfResponse: "GetVersionDateResponse",
        soapAction: "GetVersionDate",
        serviceASMX: "CeltaSecurityService.asmx",
        typeOfResult: "GetVersionDateResult",
      ),
    ).called(1);
  });
}
