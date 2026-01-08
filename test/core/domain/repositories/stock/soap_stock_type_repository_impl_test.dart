import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/domain/repositories/stock/stock.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapStockTypeRepository sut;

  late SoapStockTypeDatasourceSpy soapStockTypeDatasource;

  late List<StockTypeEntity> stockTypeEntities;
  late String urlInUse;
  late String crossIdentity;

  void initSut() {
    sut = SoapStockTypeRepositoryImpl(soapStockTypeDatasource);
  }

  void initInjections() {
    soapStockTypeDatasource = SoapStockTypeDatasourceSpy();
  }

  void mockSuccess() {
    soapStockTypeDatasource.mockLoad(
      stockTypeEntities.map((e) => StockTypeModel.fromEntity(e)).toList(),
    );
  }

  void initEntities() {
    stockTypeEntities = [
      EntityFactory.makeStockTypeEntity(),
      EntityFactory.makeStockTypeEntity(),
      EntityFactory.makeStockTypeEntity(),
    ];
    urlInUse = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });
  setUpAll(() {
    for (var routine in BsRoutine.values) {
      registerFallbackValue(routine);
    }
    for (var searchType in SearchType.values) {
      registerFallbackValue(searchType);
    }
    registerFallbackValue(EntityFactory.makeEnterpriseEntity());
  });

  test("Should behave correctly on get", () async {
    final response = await sut.load(
      urlInUse: urlInUse,
      crossIdentity: crossIdentity,
    );

    expect(response, stockTypeEntities);

    verify(
      () => soapStockTypeDatasource.load(
        urlInUse: urlInUse,
        crossIdentity: crossIdentity,
      ),
    ).called(1);
  });
}
