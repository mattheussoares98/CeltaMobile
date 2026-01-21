import 'dart:convert';

import 'package:celta_inventario/core/data/datasource/buyer/buyer.dart';
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapLoadBuyersDatasource sut;

  late SoapRequestSpy soapAdapter;

  late String workingUrl;
  late String crossIdentity;
  late List<BuyerModel> buyersModels;

  void initSut() {
    sut = SoapLoadBuyersDatasource(soapAdapter);
  }

  void initInjections() {
    soapAdapter = SoapRequestSpy();
  }

  void mockSuccess() {
    soapAdapter.mockPost(
      json.encode(buyersModels.map((e) => e.toJson()).toList()),
    );
  }

  void initEntities() {
    workingUrl = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    buyersModels = [
      EntityFactory.makeBuyerEntity(),
      EntityFactory.makeBuyerEntity(),
      EntityFactory.makeBuyerEntity(),
    ].map((e) => BuyerModel.fromEntity(e)).toList();
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
    );

    expect(value, buyersModels);

    verify(
      () => soapAdapter.post(
        url: workingUrl,
        typeOfResponse: "GetEmployeeJsonResponse",
        soapAction: "GetEmployeeJson",
        serviceASMX: "CeltaEmployeeService.asmx",
        typeOfResult: "GetEmployeeJsonResult",
        parameters: {
          "filters": json.encode({
            "CrossIdentity": crossIdentity,
            "RoutineInt": 2,
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
    );

    expect(result, throwsA(isA<Exception>()));
  });
}
