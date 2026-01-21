import 'package:celta_inventario/features/inventory/data/models/models.dart';
import 'package:celta_inventario/features/inventory/domain/repositories/repositories.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapLoadInventoryRepository sut;

  late SoapLoadInventoryDatasourceSpy datasource;

  late InventoryModel inventoryModel;
  late String workingUrl;
  late String crossIdentity;
  late int enterpriseCode;

  void initSut() {
    sut = SoapLoadInventoryRepositoryImpl(datasource);
  }

  void initInjections() {
    datasource = SoapLoadInventoryDatasourceSpy();
  }

  void mockSuccess() {
    datasource.mockLoad(inventoryModel);
  }

  void initEntities() {
    inventoryModel = InventoryModel.fromEntity(
      EntityFactory.makeInventoryEntity(),
    );
    workingUrl = faker.internet.httpsUrl();
    crossIdentity = faker.guid.guid();
    enterpriseCode = faker.randomGenerator.integer(1000);
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test('should behave correctly on success', () async {
    final response = await sut.load(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      enterpriseCode: enterpriseCode,
    );

    expect(response, inventoryModel.toEntity());

    verify(
      () => datasource.load(
        workingUrl: workingUrl,
        crossIdentity: crossIdentity,
        enterpriseCode: enterpriseCode,
      ),
    );
    verifyNoMoreInteractions(datasource);
  });
}
