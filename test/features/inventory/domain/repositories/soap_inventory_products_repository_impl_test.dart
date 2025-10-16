import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/features/inventory/data/models/models.dart';
import 'package:celta_intelligence/features/inventory/domain/repositories/repositories.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapInventoryProductsRepository sut;

  late SoapInventoryProductsDatasourceSpy datasource;

  late List<InventoryProductModel> productsModels;
  late String baseUrl;
  late String crossIdentity;
  late int enterpriseCode;
  late String searchValue;
  late int inventoryProcessCode;
  late SearchType searchType;
  late int inventoryCountingCode;
  late EnterpriseEntity selectedEnterprise;

  void initSut() {
    sut = SoapInventoryProductsRepositoryImpl(datasource);
  }

  void initInjections() {
    datasource = SoapInventoryProductsDatasourceSpy();
  }

  void mockSuccess() {
    datasource.mockLoad(productsModels);
  }

  void initEntities() {
    productsModels = [
      EntityFactory.makeInventoryProductEntity(),
      EntityFactory.makeInventoryProductEntity(),
      EntityFactory.makeInventoryProductEntity(),
    ].map((e) => InventoryProductModel.fromEntity(e)).toList();
    baseUrl = faker.internet.httpsUrl();
    crossIdentity = faker.guid.guid();
    enterpriseCode = faker.randomGenerator.integer(1000);
    searchValue = faker.lorem.word();
    inventoryProcessCode = faker.randomGenerator.integer(1000);
    searchType = SearchType
        .values[faker.randomGenerator.integer(SearchType.values.length)];
    inventoryCountingCode = faker.randomGenerator.integer(1000);
    selectedEnterprise = EntityFactory.makeEnterpriseEntity();
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  setUpAll(() {
    for (var value in SearchType.values) {
      registerFallbackValue(value);
    }
    registerFallbackValue(EntityFactory.makeEnterpriseEntity());
  });

  test('should behave correctly on success', () async {
    final response = await sut.load(
      baseUrl: baseUrl,
      searchValue: searchValue,
      codigoInternoInventario: inventoryProcessCode,
      searchType: searchType,
      crossIdentity: crossIdentity,
      enterpriseCode: enterpriseCode,
      codigoInternoInvCont: inventoryCountingCode,
      selectedEnterprise: selectedEnterprise,
    );

    expect(response, productsModels.map((e) => e.toEntity()).toList());

    verify(
      () => datasource.load(
        baseUrl: baseUrl,
        searchValue: searchValue,
        codigoInternoInventario: inventoryProcessCode,
        searchType: searchType,
        crossIdentity: crossIdentity,
        enterpriseCode: enterpriseCode,
        codigoInternoInvCont: inventoryCountingCode,
        selectedEnterprise: selectedEnterprise,
      ),
    );
    verifyNoMoreInteractions(datasource);
  });
}
