import 'dart:convert';

import 'package:celta_inventario/core/data/datasource/customer/customer.dart';
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late IEcCustomersDatasource sut;
  late HttpClientSpy httpClient;

  late EcGetCustomersParams params;
  late List<BSFCustomerEntity> customerEntities;

  void initInjections() {
    httpClient = HttpClientSpy();
  }

  void initSut() {
    sut = EcCustomersDatasource(httpClient);
  }

  void initEntities() {
    params = EcGetCustomersParams(
      params: EntityFactory.makeEcRequestParams(),
      searchValue: faker.person.name(),
      enterpriseCode: faker.randomGenerator.integer(100),
      sellerCode: faker.randomGenerator.integer(100),
      searchByPersonalizedCode: faker.randomGenerator.boolean(),
    );

    customerEntities = [
      EntityFactory.makeBSFCustomerEntity(),
      EntityFactory.makeBSFCustomerEntity(),
    ];
  }

  void mockSuccess() {
    httpClient.mockRequest(
      json.encode(
        customerEntities
            .map((e) => BSFCustomerModel.fromEntity(e).toJson())
            .toList(),
      ),
    );
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test('should call adapter with correct params', () async {
    await sut.searchForMobileApp(params);

    verify(
      () => httpClient.request(
        url: '${params.params.workingUrl}/api/Customers/SearchForMobileApp',
        method: 'post',
        headers: params.params.toHeaders(),
        body: params.toJson(),
      ),
    ).called(1);
  });

  test('should return empty list when api return empty or null', () async {
    httpClient.mockRequest(faker.randomGenerator.boolean() ? null : '');

    final result = await sut.searchForMobileApp(params);

    expect(result, isEmpty);
  });

  test('should return correct list of models on success', () async {
    final result = await sut.searchForMobileApp(params);

    expect(
      result,
      customerEntities.map((e) => BSFCustomerModel.fromEntity(e)).toList(),
    );
  });
}
