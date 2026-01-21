import 'dart:convert';

import 'package:celta_inventario/features/buy_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/buy_request/data/models/models.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapLoadEnterpriseByFiltersDatasource sut;

  late SoapRequestSpy soapAdapter;

  late String workingUrl;
  late String crossIdentity;
  late int supplierCode;
  late int requestTypeCode;
  late List<SoapEnterpriseByFiltersModel> enterpriseModels;

  void initSut() {
    sut = SoapLoadEnterpriseByFiltersDatasource(soapAdapter);
  }

  void initInjections() {
    soapAdapter = SoapRequestSpy();
  }

  void mockSuccess() {
    soapAdapter.mockPost(
      json.encode(enterpriseModels.map((e) => e.toJson()).toList()),
    );
  }

  void initEntities() {
    workingUrl = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    enterpriseModels = [
      EntityFactory.makeEnterpriseEntity(),
      EntityFactory.makeEnterpriseEntity(),
      EntityFactory.makeEnterpriseEntity(),
    ].map((e) => SoapEnterpriseByFiltersModel.fromEntity(e)).toList();
    supplierCode = faker.randomGenerator.integer(100);
    requestTypeCode = faker.randomGenerator.integer(100);
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test('should behave correctly on success', () async {
    final value = await sut.load(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      supplierCode: supplierCode,
      requestTypeCode: requestTypeCode,
    );

    expect(value, enterpriseModels);

    verify(
      () => soapAdapter.post(
        url: workingUrl,
        serviceASMX: "CeltaEnterpriseService.asmx",
        typeOfResponse: "GetEnterprisesJsonByFiltersResponse",
        soapAction: "GetEnterprisesJsonByFilters",
        typeOfResult: "GetEnterprisesJsonByFiltersResult",
        parameters: {
          "filters": json.encode({
            "CrossIdentity": crossIdentity,
            "RoutineInt": 2,
            "SupplierCode": supplierCode,
            "RequestTypeCode": requestTypeCode,
          }),
        },
      ),
    ).called(1);
  });

  test("Should behave correctly on error", () async {
    soapAdapter.mockPostError();

    final result = sut.load(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      supplierCode: supplierCode,
      requestTypeCode: requestTypeCode,
    );

    expect(result, throwsA(isA<Exception>()));
  });
}
