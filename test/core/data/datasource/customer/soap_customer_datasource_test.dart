import 'dart:convert';

import 'package:celta_intelligence/core/data/datasource/customer/customer.dart';
import 'package:celta_intelligence/core/data/models/customer/customer.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapCustomerDatasource sut;

  late SoapRequestSpy soapRequest;

  late String crossIdentity;
  late SearchCustomerType searchType;
  late String searchValue;
  late int enterpriseCode;
  late String baseUrl;
  late List<CustomerModel> customersModels;

  void initEntities() {
    searchType =
        SearchCustomerType.values[faker.randomGenerator.integer(
          SearchCustomerType.values.length,
        )];
    searchValue = faker.lorem.word();
    enterpriseCode = faker.randomGenerator.integer(100);
    baseUrl = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    customersModels = [
      EntityFactory.makeCustomerEntity(),
      EntityFactory.makeCustomerEntity(),
      EntityFactory.makeCustomerEntity(),
    ].map((e) => CustomerModel.fromEntity(e)).toList();
  }

  void initSut() {
    sut = SoapCustomerDatasource(soapRequest);
  }

  void initInjections() {
    soapRequest = SoapRequestSpy();
  }

  void mockSuccess() {
    soapRequest.mockPost(json.encode(customersModels));
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  group('Get enterprise', () {
    test('should behave correctly on success', () async {
      final result = await sut.loadCustomer(
        searchType: searchType,
        searchValue: searchValue,
        crossIdentity: crossIdentity,
        enterpriseCode: enterpriseCode,
        baseUrl: baseUrl,
      );

      expect(result, customersModels);

      verify(
        () => soapRequest.post(
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
      );
    });
  });
}
