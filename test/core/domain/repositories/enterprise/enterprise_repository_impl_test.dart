import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/domain/repositories/enterprise/enterprise.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late IEnterpriseRepository sut;

  late SoapEnterpriseDatasourceSpy soapEnterpriseDatasource;
  late SupabaseEnterpriseDatasourceSpy supabaseEnterpriseDatasource;

  late List<EnterpriseEntity> enterpriseEntities;
  late String enterpriseName;
  late String url;
  late String crossIdentity;
  late int? requestTypeCode;
  late int? enterpriseOriginCode;
  late List<EnabledModulesByCnpjEntity> enabledModulesByCnpjEntities;

  void initSut() {
    sut = EnterpriseRepositoryImpl(
      supabaseEnterpriseDatasource: supabaseEnterpriseDatasource,
      soapEnterpriseDatasource: soapEnterpriseDatasource,
    );
  }

  void initInjections() {
    soapEnterpriseDatasource = SoapEnterpriseDatasourceSpy();
    supabaseEnterpriseDatasource = SupabaseEnterpriseDatasourceSpy();
  }

  void mockSuccess() {
    soapEnterpriseDatasource.mockGetEnterprises(
      enterpriseEntities.map((e) => SoapEnterpriseModel.fromEntity(e)).toList(),
    );
    supabaseEnterpriseDatasource.mockGetEnterpriseByName(
      SupabaseEnterpriseModel.fromEntity(enterpriseEntities.first),
    );
    supabaseEnterpriseDatasource.mockGetEnabledModulesByEnterpriseName(
      enabledModulesByCnpjEntities
          .map((e) => EnabledModulesByCnpjModel.fromEntity(e))
          .toList(),
    );
  }

  void initEntities() {
    enterpriseEntities = [
      EntityFactory.makeEnterpriseEntity(),
      EntityFactory.makeEnterpriseEntity(),
      EntityFactory.makeEnterpriseEntity(),
    ];
    enterpriseName = faker.company.name();
    url = faker.internet.httpsUrl();
    crossIdentity = faker.guid.guid();
    requestTypeCode = faker.randomGenerator.boolean() == true
        ? faker.randomGenerator.integer(100)
        : null;
    enterpriseOriginCode = faker.randomGenerator.boolean() == true
        ? faker.randomGenerator.integer(100)
        : null;
    enabledModulesByCnpjEntities = [
      EntityFactory.makeEnabledModulesByCnpjEntity(),
      EntityFactory.makeEnabledModulesByCnpjEntity(),
      EntityFactory.makeEnabledModulesByCnpjEntity(),
    ];
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test("Behave correctly on get supabase enterprise by name", () async {
    final response = await sut.getSupabaseEnterpriseByName(enterpriseName);

    expect(
      response,
      SupabaseEnterpriseModel.fromEntity(enterpriseEntities.first).toEntity(),
    );
    verify(
      () => supabaseEnterpriseDatasource.getEnterpriseByName(enterpriseName),
    ).called(1);
  });
  test("Behave correctly on get soap enterprises", () async {
    final response = await sut.getSoapEnterprises(
      url: url,
      crossIdentity: crossIdentity,
      requestTypeCode: requestTypeCode,
      enterpriseOriginCode: enterpriseOriginCode,
    );

    expect(
      response,
      enterpriseEntities
          .map((e) => SoapEnterpriseModel.fromEntity(e).toEntity())
          .toList(),
    );

    verify(
      () => soapEnterpriseDatasource.getEnterprises(
        crossIdentity: any(named: "crossIdentity"),
        baseUrl: any(named: "baseUrl"),
        requestTypeCode: any(named: "requestTypeCode"),
        enterpriseOriginCode: any(named: "enterpriseOriginCode"),
      ),
    ).called(1);
  });

  group('Get enabled modules by enterprise name', () {
    test('should behave correctly on success', () async {
      final response = await sut.getEnabledModulesByEnterpriseName(
        enterpriseName,
      );

      expect(response, enabledModulesByCnpjEntities);
      verify(
        () => supabaseEnterpriseDatasource.getEnabledModulesByEnterpriseName(
          enterpriseName,
        ),
      );
      verifyNoMoreInteractions(supabaseEnterpriseDatasource);
    });
  });
}
