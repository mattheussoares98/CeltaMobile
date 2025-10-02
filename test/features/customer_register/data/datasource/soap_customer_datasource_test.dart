import 'dart:convert';

import 'package:celta_intelligence/features/customer_register/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/customer_register/data/models/models.dart';
import 'package:celta_intelligence/features/customer_register/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late SoapCustomerDatasource sut;

  late SoapRequestSpy soapAdapter;

  late String baseUrl;
  late String crossIdentity;
  late int enterpriseCode;
  late List<CustomerEntity> customersEntities;
  late SearchCustomerType searchType;
  late String searchValue;

  void initSut() {
    sut = SoapCustomerDatasource(soapAdapter);
  }

  void initInjections() {
    soapAdapter = SoapRequestSpy();
  }

  void mockSuccess() {
    soapAdapter.mockPost(
      json.encode(
        customersEntities
            .map((e) => CustomerModel.fromEntity(e).toJson())
            .toList(),
      ),
    );
  }

  void initEntities() {
    baseUrl = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    enterpriseCode = faker.randomGenerator.integer(100);
    customersEntities = [
      EntityFactory.makeCustomerEntity(),
      EntityFactory.makeCustomerEntity(),
      EntityFactory.makeCustomerEntity(),
    ];
    searchType =
        SearchCustomerType.values[faker.randomGenerator.integer(
          SearchCustomerType.values.length,
        )];
    searchValue = faker.guid.guid();
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test('should behave correctly on success', () async {
    final value = await sut.loadCustomer(
      searchType: searchType,
      searchValue: searchValue,
      crossIdentity: crossIdentity,
      enterpriseCode: enterpriseCode,
      baseUrl: baseUrl,
    );

    expect(
      value,
      customersEntities.map((e) => CustomerModel.fromEntity(e)).toList(),
    );

    verify(
      () => soapAdapter.post(
        url: baseUrl,
        parameters: {
          "filters": json.encode({
            "crossIdentity": crossIdentity,
            "customerData": searchValue,
            "customerDataType": searchType.code,
            "enterpriseCode": enterpriseCode,
          }),
        },
        typeOfResponse: "GetCustomerJsonResponse",
        soapAction: "GetCustomerJson",
        serviceASMX: "CeltaCustomerService.asmx",
        typeOfResult: "GetCustomerJsonResult",
      ),
    ).called(1);
  });
}
