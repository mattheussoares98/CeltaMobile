import 'package:celta_intelligence/core/data/models/customer/customer.dart';
import 'package:celta_intelligence/core/domain/entities/customer/customer.dart';
import 'package:celta_intelligence/core/domain/repositories/customer/customer.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late SoapCustomerRepositoryImpl sut;

  late SoapCustomerDatasourceSpy soapCustomerDatasource;

  late List<CustomerEntity> customersEntities;
  late SearchCustomerType searchType;
  late String searchValue;
  late String crossIdentity;
  late int enterpriseCode;
  late String urlInUse;

  void initSut() {
    sut = SoapCustomerRepositoryImpl(soapCustomerDatasource);
  }

  void initInjections() {
    soapCustomerDatasource = SoapCustomerDatasourceSpy();
  }

  void mockSuccess() {
    soapCustomerDatasource.mockLoad(
      customersEntities.map((e) => CustomerModel.fromEntity(e)).toList(),
    );
  }

  void initEntities() {
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
    crossIdentity = faker.guid.guid();
    enterpriseCode = faker.randomGenerator.integer(100);
    urlInUse = faker.internet.httpUrl();
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  setUpAll(() {
    for (var value in SearchCustomerType.values) {
      registerFallbackValue(value);
    }
  });

  test('should behave correctly on success', () async {
    final response = await sut.loadCustomer(
      searchType: searchType,
      searchValue: searchValue,
      crossIdentity: crossIdentity,
      enterpriseCode: enterpriseCode,
      urlInUse: urlInUse,
    );

    expect(response, customersEntities);
    verify(
      () => soapCustomerDatasource.loadCustomer(
        searchType: searchType,
        searchValue: searchValue,
        crossIdentity: crossIdentity,
        enterpriseCode: enterpriseCode,
        urlInUse: urlInUse,
      ),
    );
    verifyNoMoreInteractions(soapCustomerDatasource);
  });
}
