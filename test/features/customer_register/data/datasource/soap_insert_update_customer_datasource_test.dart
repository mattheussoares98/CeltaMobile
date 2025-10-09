import 'dart:convert';

import 'package:celta_intelligence/core/data/models/customer/customer.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/features/customer_register/data/datasource/datasource.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapInsertUpdateCustomerDatasource sut;

  late SoapRequestSpy soapAdapter;

  late String baseUrl;
  late String crossIdentity;
  late CustomerEntity customer;

  void initSut() {
    sut = SoapInsertUpdateCustomerDatasource(soapAdapter);
  }

  void initInjections() {
    soapAdapter = SoapRequestSpy();
  }

  void mockSuccess() {}

  void initEntities() {
    baseUrl = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    customer = EntityFactory.makeCustomerEntity();
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test('should call with correct params', () async {
    await sut.insertOrUpdateCustomer(
      customer: CustomerModel.fromEntity(customer),
      baseUrl: baseUrl,
      crossIdentity: crossIdentity,
    );

    verify(
      () => soapAdapter.post(
        url: baseUrl,
        typeOfResponse: "InsertUpdateCustomerResponse",
        soapAction: "InsertUpdateCustomer",
        serviceASMX: "CeltaCustomerService.asmx",
        typeOfResult: "InsertUpdateCustomerResult",
        parameters: {
          "crossIdentity": crossIdentity,
          "json": json.encode(CustomerModel.fromEntity(customer).toJson()),
        },
      ),
    ).called(1);
  });
}
