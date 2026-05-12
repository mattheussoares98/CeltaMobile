import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/data/repositories/customer/customer.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/domain/repositories/customer/customer.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late IEcBSFCustomersRepository sut;
  late EcBSFCustomersDatasourceSpy datasource;

  late EcRequestParams params;
  late String searchValue;
  late int enterpriseCode;
  late bool searchByPersonalizedCode;
  late List<BSFCustomerModel> customerModels;

  void initInjections() {
    datasource = EcBSFCustomersDatasourceSpy();
  }

  void initSut() {
    sut = EcBSFCustomersRepositoryImpl(datasource);
  }

  void initEntities() {
    params = EntityFactory.makeEcRequestParams();
    searchValue = faker.person.name();
    enterpriseCode = faker.randomGenerator.integer(100);
    searchByPersonalizedCode = faker.randomGenerator.boolean();
    customerModels = [
      BSFCustomerModel.fromEntity(EntityFactory.makeBSFCustomerEntity()),
      BSFCustomerModel.fromEntity(EntityFactory.makeBSFCustomerEntity()),
    ];
  }

  void mockSuccess() {
    datasource.mockSearchForMobileApp(customerModels);
  }

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeEcRequestParams());
  });

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test('should behave correctly on success', () async {
    final result = await sut.searchForMobileApp(
      params: params,
      searchValue: searchValue,
      enterpriseCode: enterpriseCode,
      searchByPersonalizedCode: searchByPersonalizedCode,
    );

    expect(result, customerModels.map((e) => e.toEntity()).toList());

    verify(
      () => datasource.searchForMobileApp(
        params: params,
        searchValue: searchValue,
        enterpriseCode: enterpriseCode,
        searchByPersonalizedCode: searchByPersonalizedCode,
      ),
    ).called(1);
  });

  test('should throw if datasource throws', () async {
    datasource.mockSearchForMobileAppError();

    final future = sut.searchForMobileApp(
      params: params,
      searchValue: searchValue,
      enterpriseCode: enterpriseCode,
      searchByPersonalizedCode: searchByPersonalizedCode,
    );

    expect(future, throwsA(isA<Exception>()));
  });
}
