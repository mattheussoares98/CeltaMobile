import 'dart:convert';

import 'package:celta_intelligence/core/data/datasource/supplier/supplier.dart';
import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapLoadSupplierDatasource sut;

  late SoapRequestSpy soapAdapter;

  late String workingUrl;
  late String crossIdentity;
  late String searchValue;
  late SearchSupplierType searchType;
  late List<SupplierModel> supplierModels;

  void initSut() {
    sut = SoapLoadSupplierDatasource(soapAdapter);
  }

  void initInjections() {
    soapAdapter = SoapRequestSpy();
  }

  void mockSuccess() {}

  void initEntities() {
    workingUrl = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    searchValue = faker.lorem.word();
    supplierModels = [
      EntityFactory.makeSupplierEntity(),
      EntityFactory.makeSupplierEntity(),
      EntityFactory.makeSupplierEntity(),
    ].map((e) => SupplierModel.fromEntity(e)).toList();
    searchType =
        SearchSupplierType.values[faker.randomGenerator.integer(
          SearchSupplierType.values.length,
        )];
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  setUpAll(() {
    for (var routine in SearchSupplierType.values) {
      registerFallbackValue(routine);
    }
  });

  test('should behave correctly on success', () async {
    soapAdapter.mockPost(
      json.encode(supplierModels.map((e) => e.toJson()).toList()),
    );

    final result = await sut.load(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      searchType: searchType,
      searchValue: searchValue,
    );

    expect(result, supplierModels);

    verify(
      () => soapAdapter.post(
        url: workingUrl,
        serviceASMX: "CeltaSupplierService.asmx",
        typeOfResponse: "GetSupplierJsonResponse",
        soapAction: "GetSupplierJson",
        typeOfResult: "GetSupplierJsonResult",
        parameters: {
          "filters": json.encode({
            "CrossIdentity": crossIdentity,
            "SearchValue": searchValue,
            "RoutineInt": searchType.code,
          }),
        },
      ),
    ).called(1);
  });
}
