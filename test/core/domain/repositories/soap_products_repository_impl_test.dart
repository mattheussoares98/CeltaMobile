import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/domain/repositories/repositores.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/mocks.dart';

void main() {
  late SoapProductsRepositoryImpl sut;

  late SoapProductsDatasourceSpy soapProductsDatasource;

  late List<ProductEntity> products;
  late String baseUrl;
  late String searchValue;
  late Routine routine;
  late SearchType searchType;
  late String crossIdentity;
  late List<int> enterpriseCodes;
  late EnterpriseEntity enterpriseEntity;
  late int lastBuyEntranceQuantity;

  void initSut() {
    sut = SoapProductsRepositoryImpl(soapProductsDatasource);
  }

  void initInjections() {
    soapProductsDatasource = SoapProductsDatasourceSpy();
  }

  void mockSuccess() {
    soapProductsDatasource.mockGetProductsJson(
      products.map((e) => ProductModel.fromEntity(e)).toList(),
    );
  }

  void initEntities() {
    products = [
      EntityFactory.makeProductEntity(),
      EntityFactory.makeProductEntity(),
      EntityFactory.makeProductEntity(),
    ];
    baseUrl = faker.internet.httpUrl();
    searchValue = faker.randomGenerator.string(13);
    routine =
        Routine.values[faker.randomGenerator.integer(Routine.values.length)];
    searchType = SearchType
        .values[faker.randomGenerator.integer(SearchType.values.length)];
    crossIdentity = faker.guid.guid();
    enterpriseCodes = [
      faker.randomGenerator.integer(100),
      faker.randomGenerator.integer(100),
      faker.randomGenerator.integer(100),
    ];
    enterpriseEntity = EntityFactory.makeEnterpriseEntity();
    lastBuyEntranceQuantity = faker.randomGenerator.integer(100);
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });
  setUpAll(() {
    for (var routine in Routine.values) {
      registerFallbackValue(routine);
    }
    for (var searchType in SearchType.values) {
      registerFallbackValue(searchType);
    }
    registerFallbackValue(EntityFactory.makeEnterpriseEntity());
  });

  test("Should behave correctly on get", () async {
    await sut.getProductsJson(
      baseUrl: baseUrl,
      searchValue: searchValue,
      routine: routine,
      searchType: searchType,
      crossIdentity: crossIdentity,
      enterpriseCodes: enterpriseCodes,
      enterpriseEntity: enterpriseEntity,
      lastBuyEntranceQuantity: lastBuyEntranceQuantity,
    );

    verify(
      () => soapProductsDatasource.getProductsJson(
        baseUrl: baseUrl,
        searchValue: searchValue,
        routine: routine,
        searchType: searchType,
        crossIdentity: crossIdentity,
        enterpriseCodes: enterpriseCodes,
        enterpriseEntity: enterpriseEntity,
        lastBuyEntranceQuantity: lastBuyEntranceQuantity,
      ),
    ).called(1);
  });
}
