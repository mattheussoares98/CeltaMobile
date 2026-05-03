import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/domain/repositories/supplier/supplier.dart';
import 'package:celta_inventario/core/data/repositories/supplier/supplier.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapLoadSupplierRepository sut;

  late SoapLoadSupplierDatasourceSpy soapStockTypeDatasource;

  late List<SupplierEntity> supplierEntities;
  late String workingUrl;
  late String crossIdentity;
  late String searchValue;
  late SearchSupplierType searchType;

  void initSut() {
    sut = SoapLoadSupplierRepositoryImpl(soapStockTypeDatasource);
  }

  void initInjections() {
    soapStockTypeDatasource = SoapLoadSupplierDatasourceSpy();
  }

  void mockSuccess() {
    soapStockTypeDatasource.mockLoad(
      supplierEntities.map((e) => SupplierModel.fromEntity(e)).toList(),
    );
  }

  void initEntities() {
    supplierEntities = [
      EntityFactory.makeSupplierEntity(),
      EntityFactory.makeSupplierEntity(),
      EntityFactory.makeSupplierEntity(),
    ];
    workingUrl = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    searchType =
        SearchSupplierType.values[faker.randomGenerator.integer(
          SearchSupplierType.values.length,
        )];
    searchValue = faker.lorem.word();
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });
  setUpAll(() {
    for (var value in SearchSupplierType.values) {
      registerFallbackValue(value);
    }
  });

  test("Should behave correctly on get", () async {
    final response = await sut.load(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      searchType: searchType,
      searchValue: searchValue,
    );

    expect(response, supplierEntities);

    verify(
      () => soapStockTypeDatasource.load(
        workingUrl: workingUrl,
        crossIdentity: crossIdentity,
        searchType: searchType,
        searchValue: searchValue,
      ),
    ).called(1);
  });
}
