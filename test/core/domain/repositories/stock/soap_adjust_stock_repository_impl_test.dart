import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/domain/repositories/stock/stock.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapAdjustStockRepository sut;

  late SoapAdjustStockDatasourceSpy soapAdjustStockDatasource;

  late List<AdjustStockItemModel> items;
  late String baseUrl;
  late String crossIdentity;

  void initSut() {
    sut = SoapAdjustStockRepositoryImpl(soapAdjustStockDatasource);
  }

  void initInjections() {
    soapAdjustStockDatasource = SoapAdjustStockDatasourceSpy();
  }

  void mockSuccess() {}

  void initEntities() {
    items = [
      EntityFactory.makeAdjustStockItemEntity(),
      EntityFactory.makeAdjustStockItemEntity(),
      EntityFactory.makeAdjustStockItemEntity(),
    ].map((e) => AdjustStockItemModel.fromEntity(e)).toList();
    baseUrl = faker.internet.httpUrl();
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

  test("Should call datasource with correct params", () async {
    await sut.confirm(
      baseUrl: baseUrl,
      crossIdentity: crossIdentity,
      items: items.map((e) => e.toEntity()).toList(),
    );

    verify(
      () => soapAdjustStockDatasource.confirm(
        baseUrl: baseUrl,
        crossIdentity: crossIdentity,
        items: items,
      ),
    ).called(1);
  });
}
