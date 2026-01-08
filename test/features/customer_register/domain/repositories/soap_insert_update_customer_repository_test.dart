import 'package:celta_intelligence/core/data/models/customer/customer.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/features/customer_register/domain/repositories/repositories.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapInsertUpdateCustomerRepository sut;

  late SoapInsertUpdateCustomerDatasourceSpy datasource;

  late String crossIdentity;
  late String urlInUse;
  late CustomerEntity customer;

  void initSut() {
    sut = SoapInsertUpdateCustomerRepositoryImpl(datasource);
  }

  void initInjections() {
    datasource = SoapInsertUpdateCustomerDatasourceSpy();
  }

  void mockSuccess() {
    datasource.mockInsertUpdate();
  }

  void initEntities() {
    customer = EntityFactory.makeCustomerEntity();
    crossIdentity = faker.guid.guid();
    urlInUse = faker.internet.httpUrl();
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  setUpAll(() {
    registerFallbackValue(
      CustomerModel.fromEntity(EntityFactory.makeCustomerEntity()),
    );
  });
  test('should behave correctly on success', () async {
    await sut.insertOrUpdateCustomer(
      customer: customer,
      urlInUse: urlInUse,
      crossIdentity: crossIdentity,
    );

    verify(
      () => datasource.insertOrUpdateCustomer(
        customer: CustomerModel.fromEntity(customer),
        urlInUse: urlInUse,
        crossIdentity: crossIdentity,
      ),
    ).called(1);

    verifyNoMoreInteractions(datasource);
  });
}
