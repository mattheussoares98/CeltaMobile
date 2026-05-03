import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/inventory/domain/repositories/repositories.dart';
import 'package:celta_inventario/features/inventory/data/repositories/repositories.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapInventoryAnnulRepository sut;

  late SoapInventoryAnnulDatasourceSpy datasource;

  late String workingUrl;
  late String crossIdentity;
  late int codigoInternoInvCont;
  late int productPackingCode;

  void initSut() {
    sut = SoapInventoryAnnulRepositoryImpl(datasource);
  }

  void initInjections() {
    datasource = SoapInventoryAnnulDatasourceSpy();
  }

  void mockSuccess() {}

  void initEntities() {
    workingUrl = faker.internet.httpsUrl();
    crossIdentity = faker.guid.guid();
    codigoInternoInvCont = faker.randomGenerator.integer(100);
    productPackingCode = faker.randomGenerator.integer(100);
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
    await sut.annul(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      codigoInternoInvCont: codigoInternoInvCont,
      codigoInternoProEmb: productPackingCode,
    );
    verify(
      () => datasource.annul(
        workingUrl: workingUrl,
        crossIdentity: crossIdentity,
        codigoInternoInvCont: codigoInternoInvCont,
        codigoInternoProEmb: productPackingCode,
      ),
    );
    verifyNoMoreInteractions(datasource);
  });
}
