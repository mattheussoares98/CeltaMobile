import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/data/repositories/customer/customer.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/domain/repositories/customer/customer.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late IEcCustomersRepository sut;
  late EcBSFCustomersDatasourceSpy datasource;

  late EcGetCustomersParams params;
  late List<BSFCustomerModel> customerModels;

  void initInjections() {
    datasource = EcBSFCustomersDatasourceSpy();
  }

  void initSut() {
    sut = EcCustomersRepositoryImpl(datasource);
  }

  void initEntities() {
    params = EcGetCustomersParams(
      params: EntityFactory.makeEcRequestParams(),
      searchValue: faker.person.name(),
      enterpriseCode: faker.randomGenerator.integer(100),
      sellerCode: faker.randomGenerator.integer(100),
      searchByPersonalizedCode: faker.randomGenerator.boolean(),
    );
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
    final result = await sut.searchForMobileApp(params);

    expect(result, customerModels.map((e) => e.toEntity()).toList());

    verify(() => datasource.searchForMobileApp(params)).called(1);
  });

  test('should throw if datasource throws', () async {
    datasource.mockSearchForMobileAppError();

    final future = sut.searchForMobileApp(params);

    expect(future, throwsA(isA<Exception>()));
  });
}
