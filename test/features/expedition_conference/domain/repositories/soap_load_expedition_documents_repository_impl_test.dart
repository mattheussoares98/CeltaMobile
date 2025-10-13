import 'package:celta_intelligence/features/expedition_conference/data/models/models.dart';
import 'package:celta_intelligence/features/expedition_conference/domain/repositories/repositories.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late SoapLoadExpeditionDocumentsRepositoryImpl sut;

  late SoapLoadExpeditionDocumentsDatasourceSpy datasource;

  late List<ExpeditionDocumentModel> expeditionDocumentModels;
  late String baseUrl;
  late String crossIdentity;
  late int enterpriseCode;

  void initSut() {
    sut = SoapLoadExpeditionDocumentsRepositoryImpl(datasource);
  }

  void initInjections() {
    datasource = SoapLoadExpeditionDocumentsDatasourceSpy();
  }

  void mockSuccess() {
    datasource.mockLoad(expeditionDocumentModels);
  }

  void initEntities() {
    expeditionDocumentModels = [
      EntityFactory.makeExpeditionDocumentEntity(),
      EntityFactory.makeExpeditionDocumentEntity(),
      EntityFactory.makeExpeditionDocumentEntity(),
    ].map((e) => ExpeditionDocumentModel.fromEntity(e)).toList();
    baseUrl = faker.internet.httpsUrl();
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
      baseUrl: baseUrl,
      crossIdentity: crossIdentity,
      enterpriseCode: enterpriseCode,
    );

    expect(
      response,
      expeditionDocumentModels.map((e) => e.toEntity()).toList(),
    );
    verify(
      () => datasource.load(
        baseUrl: baseUrl,
        crossIdentity: crossIdentity,
        enterpriseCode: enterpriseCode,
      ),
    );
    verifyNoMoreInteractions(datasource);
  });
}
