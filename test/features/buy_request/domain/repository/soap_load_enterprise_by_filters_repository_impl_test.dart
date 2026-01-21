import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/features/buy_request/data/models/models.dart';
import 'package:celta_inventario/features/buy_request/domain/repository/repository.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapLoadEnterpriseByFiltersRepository sut;

  late SoapLoadEnterpriseByFiltersDatasourceSpy datasource;

  late List<SoapEnterpriseByFiltersModel> enterprisesModels;
  late String crossIdentity;
  late String workingUrl;
  late int supplierCode;
  late int requestTypeCode;

  void initSut() {
    sut = SoapLoadEnterpriseByFiltersRepositoryImpl(datasource);
  }

  void initInjections() {
    datasource = SoapLoadEnterpriseByFiltersDatasourceSpy();
  }

  void mockSuccess() {
    datasource.mockLoad(enterprisesModels);
  }

  void initEntities() {
    enterprisesModels = [
      EntityFactory.makeEnterpriseEntity(),
      EntityFactory.makeEnterpriseEntity(),
      EntityFactory.makeEnterpriseEntity(),
    ].map((e) => SoapEnterpriseByFiltersModel.fromEntity(e)).toList();

    crossIdentity = faker.guid.guid();
    workingUrl = faker.internet.httpUrl();
    supplierCode = faker.randomGenerator.integer(100);
    requestTypeCode = faker.randomGenerator.integer(100);
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeUserEntity());
    registerFallbackValue(
      UserSessionModel.fromEntity(EntityFactory.makeUserSessionEntity()),
    );
  });

  test('should behave correctly on success', () async {
    final buyers = await sut.load(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      supplierCode: supplierCode,
      requestTypeCode: requestTypeCode,
    );

    expect(buyers, enterprisesModels.map((e) => e.toEntity()).toList());
    verify(
      () => datasource.load(
        workingUrl: workingUrl,
        crossIdentity: crossIdentity,
        supplierCode: supplierCode,
        requestTypeCode: requestTypeCode,
      ),
    ).called(1);

    verifyNoMoreInteractions(datasource);
  });
}
