import 'package:celta_inventario/core/data/datasource/customer/customer.dart';
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late IEcBSFCustomersDatasource sut;
  late HttpClientSpy httpClient;

  late EcRequestParams params;
  late String searchValue;
  late int enterpriseCode;
  late bool searchByPersonalizedCode;
  late List<BSFCustomerEntity> customerEntities;

  void initInjections() {
    httpClient = HttpClientSpy();
  }

  void initSut() {
    sut = EcBSFCustomersDatasource(httpClient);
  }

  void initEntities() {
    params = EntityFactory.makeEcRequestParams();
    searchValue = faker.person.name();
    enterpriseCode = faker.randomGenerator.integer(100);
    searchByPersonalizedCode = faker.randomGenerator.boolean();
    customerEntities = [
      EntityFactory.makeBSFCustomerEntity(),
      EntityFactory.makeBSFCustomerEntity(),
    ];
  }

  void mockSuccess() {
    httpClient.mockRequest(
      customerEntities
          .map((e) => BSFCustomerModel.fromEntity(e).toJson())
          .toList(),
    );
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test('should call adapter with correct params', () async {
    await sut.searchForMobileApp(
      params: params,
      searchValue: searchValue,
      enterpriseCode: enterpriseCode,
      searchByPersonalizedCode: searchByPersonalizedCode,
    );

    verify(
      () => httpClient.request(
        url: '${params.workingUrl}/Customers/SearchForMobileApp',
        method: 'post',
        headers: params.toHeaders(),
        body: {
          ...params.toMap(),
          'SearchValue': searchValue,
          'EnterpriseCode': enterpriseCode,
          'SearchByPersonalizedCode': searchByPersonalizedCode,
        },
      ),
    ).called(1);
  });

  test('should return empty list when api return null', () async {
    httpClient.mockRequest(null);

    final result = await sut.searchForMobileApp(
      params: params,
      searchValue: searchValue,
      enterpriseCode: enterpriseCode,
      searchByPersonalizedCode: searchByPersonalizedCode,
    );

    expect(result, isEmpty);
  });

  test('should return correct list of models on success', () async {
    final result = await sut.searchForMobileApp(
      params: params,
      searchValue: searchValue,
      enterpriseCode: enterpriseCode,
      searchByPersonalizedCode: searchByPersonalizedCode,
    );

    expect(
      result,
      customerEntities.map((e) => BSFCustomerModel.fromEntity(e)).toList(),
    );
  });
}
