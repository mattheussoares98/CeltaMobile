import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/features/inventory/domain/repositories/repositories.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapInventoryEntryQuantityRepository sut;

  late SoapInventoryEntryQuantityDatasourceSpy datasource;

  late String baseUrl;
  late String crossIdentity;
  late int codigoInternoInvCont;
  late int productPackingCode;
  late double quantity;
  late bool isSubtract;

  void initSut() {
    sut = SoapInventoryEntryQuantityRepositoryImpl(datasource);
  }

  void initInjections() {
    datasource = SoapInventoryEntryQuantityDatasourceSpy();
  }

  void mockSuccess() {}

  void initEntities() {
    baseUrl = faker.internet.httpsUrl();
    crossIdentity = faker.guid.guid();
    codigoInternoInvCont = faker.randomGenerator.integer(100);
    productPackingCode = faker.randomGenerator.integer(100);
    isSubtract = faker.randomGenerator.boolean();
    quantity = isSubtract
        ? -faker.randomGenerator.decimal()
        : faker.randomGenerator.decimal();
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
    await sut.entry(
      baseUrl: baseUrl,
      crossIdentity: crossIdentity,
      codigoInternoInvCont: codigoInternoInvCont,
      productPackingCode: productPackingCode,
      quantity: quantity,
      isSubtract: isSubtract,
    );
    verify(
      () => datasource.entry(
        baseUrl: baseUrl,
        crossIdentity: crossIdentity,
        codigoInternoInvCont: codigoInternoInvCont,
        productPackingCode: productPackingCode,
        quantity: quantity,
        isSubtract: isSubtract,
      ),
    );
    verifyNoMoreInteractions(datasource);
  });
}
