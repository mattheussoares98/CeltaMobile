import 'package:celta_intelligence/features/expedition_conference/data/models/models.dart';
import 'package:celta_intelligence/features/expedition_conference/domain/repositories/repositories.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapLoadPendingProductsRepository sut;

  late SoapLoadPendingProductsDatasourceSpy datasource;

  late List<ExpeditionProductModel> expeditionProductsModels;
  late String urlInUse;
  late String crossIdentity;
  late int expeditionControlCode;

  void initSut() {
    sut = SoapLoadPendingProductsRepositoryImpl(datasource);
  }

  void initInjections() {
    datasource = SoapLoadPendingProductsDatasourceSpy();
  }

  void mockSuccess() {
    datasource.mockLoad(expeditionProductsModels);
  }

  void initEntities() {
    expeditionProductsModels = [
      EntityFactory.makeExpeditionProductEntity(),
      EntityFactory.makeExpeditionProductEntity(),
      EntityFactory.makeExpeditionProductEntity(),
    ].map((e) => ExpeditionProductModel.fromEntity(e)).toList();
    urlInUse = faker.internet.httpsUrl();
    crossIdentity = faker.guid.guid();
    expeditionControlCode = faker.randomGenerator.integer(1000);
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test('should behave correctly on success', () async {
    final response = await sut.load(
      urlInUse: urlInUse,
      crossIdentity: crossIdentity,
      expeditionControlCode: expeditionControlCode,
    );

    expect(
      response,
      expeditionProductsModels.map((e) => e.toEntity()).toList(),
    );
    verify(
      () => datasource.load(
        urlInUse: urlInUse,
        crossIdentity: crossIdentity,
        expeditionControlCode: expeditionControlCode,
      ),
    );
    verifyNoMoreInteractions(datasource);
  });
}
