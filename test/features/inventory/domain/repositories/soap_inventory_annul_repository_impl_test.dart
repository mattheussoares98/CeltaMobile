import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/features/inventory/domain/repositories/repositories.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapInventoryAnnulRepository sut;

  late SoapInventoryAnnulDatasourceSpy datasource;

  late String baseUrl;
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
    baseUrl = faker.internet.httpsUrl();
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
      baseUrl: baseUrl,
      crossIdentity: crossIdentity,
      codigoInternoInvCont: codigoInternoInvCont,
      codigoInternoProEmb: productPackingCode,
    );
    verify(
      () => datasource.annul(
        baseUrl: baseUrl,
        crossIdentity: crossIdentity,
        codigoInternoInvCont: codigoInternoInvCont,
        codigoInternoProEmb: productPackingCode,
      ),
    );
    verifyNoMoreInteractions(datasource);
  });
}
