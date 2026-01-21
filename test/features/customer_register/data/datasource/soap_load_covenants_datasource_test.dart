import 'dart:convert';

import 'package:celta_inventario/features/customer_register/data/datasource/datasource.dart';
import 'package:celta_inventario/features/customer_register/data/models/models.dart';
import 'package:celta_inventario/features/customer_register/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapLoadCovenantsDatasource sut;

  late SoapRequestSpy soapAdapter;

  late String workingUrl;
  late String crossIdentity;
  late List<CovenantModel> covenantModels;
  late SearchCovenantType searchCovenantType;
  late String searchValue;

  void initSut() {
    sut = SoapLoadCovenantsDatasource(soapAdapter);
  }

  void initInjections() {
    soapAdapter = SoapRequestSpy();
  }

  void mockSuccess() {
    soapAdapter.mockPost(
      json.encode(covenantModels.map((e) => e.toJson()).toList()),
    );
  }

  void initEntities() {
    workingUrl = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    covenantModels = [
      EntityFactory.makeCovenantEntity(),
      EntityFactory.makeCovenantEntity(),
      EntityFactory.makeCovenantEntity(),
    ].map((e) => CovenantModel.fromEntity(e)).toList();
    searchCovenantType =
        SearchCovenantType.values[faker.randomGenerator.integer(
          SearchCovenantType.values.length,
        )];
    searchValue = faker.lorem.word();
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  setUpAll(() {
    for (var value in SearchCovenantType.values) {
      registerFallbackValue(value);
    }
  });

  test('should call with correct params', () async {
    final value = await sut.load(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      searchCovenantType: searchCovenantType,
      searchValue: searchValue,
    );

    expect(value, covenantModels);

    verify(
      () => soapAdapter.post(
        url: workingUrl,
        typeOfResponse: "GetCovenantJsonResponse",
        soapAction: "GetCovenantJson",
        serviceASMX: "CeltaCustomerService.asmx",
        typeOfResult: "GetCovenantJsonResult",
        parameters: {
          "crossIdentity": crossIdentity,
          "covenantData": searchValue, //% to find everything
          "covenantDataType": searchCovenantType.code,
        },
      ),
    ).called(1);
  });
}
