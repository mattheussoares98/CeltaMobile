import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/features/transfer_request/domain/repositories/repositories.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapLoadDestinyEnterprisesRepository sut;

  late SoapLoadDestinyEnterprisesDatasourceSpy datasource;

  late String baseUrl;
  late String crossIdentity;
  late int enterpriseOriginCode;
  late int requestTypeCode;

  late List<EnterpriseEntity> enterprisesEntities;

  void initSut() {
    sut = SoapLoadDestinyEnterprisesRepositoryImpl(datasource);
  }

  void initInjections() {
    datasource = SoapLoadDestinyEnterprisesDatasourceSpy();
  }

  void mockSuccess() {
    datasource.mockLoad(
      enterprisesEntities
          .map((e) => SoapEnterpriseModel.fromEntity(e))
          .toList(),
    );
  }

  void initEntities() {
    baseUrl = faker.internet.httpsUrl();
    crossIdentity = faker.guid.guid();
    enterpriseOriginCode = faker.randomGenerator.integer(1000);
    requestTypeCode = faker.randomGenerator.integer(1000);

    enterprisesEntities = [
      EntityFactory.makeEnterpriseEntity(),
      EntityFactory.makeEnterpriseEntity(),
      EntityFactory.makeEnterpriseEntity(),
    ].map((e) => SoapEnterpriseModel.fromEntity(e).toEntity()).toList();
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
      requestTypeCode: requestTypeCode,
      enterpriseOriginCode: enterpriseOriginCode,
    );

    expect(response, enterprisesEntities);

    verify(
      () => datasource.load(
        baseUrl: baseUrl,
        crossIdentity: crossIdentity,
        requestTypeCode: requestTypeCode,
        enterpriseOriginCode: enterpriseOriginCode,
      ),
    );
    verifyNoMoreInteractions(datasource);
  });
}
