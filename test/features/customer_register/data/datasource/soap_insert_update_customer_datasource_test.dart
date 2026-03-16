import 'dart:convert';

import 'package:celta_inventario/core/data/models/customer/customer.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/customer_register/data/datasource/datasource.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapInsertUpdateCustomerDatasource sut;

  late SoapRequestSpy soapAdapter;

  late String workingUrl;
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
    workingUrl = faker.internet.httpUrl();
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
      customer: SoapCustomerModel.fromEntity(customer),
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
    );

    verify(
      () => soapAdapter.post(
        url: workingUrl,
        typeOfResponse: "InsertUpdateCustomerResponse",
        soapAction: "InsertUpdateCustomer",
        serviceASMX: "CeltaCustomerService.asmx",
        typeOfResult: "InsertUpdateCustomerResult",
        parameters: {
          "crossIdentity": crossIdentity,
          "json": json.encode(SoapCustomerModel.fromEntity(customer).toJson()),
        },
      ),
    ).called(1);
  });
}
