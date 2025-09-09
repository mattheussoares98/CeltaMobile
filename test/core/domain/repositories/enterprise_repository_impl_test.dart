import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/domain/repositories/repositores.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/mocks.dart';

void main() {
  late IEnterpriseRepository sut;

  late SoapEnterpriseDataSourceSpy soapEnterpriseDataSource;
  late SupabaseEnterpriseDataSourceSpy supabaseEnterpriseDataSource;

  late List<EnterpriseEntity> enterpriseEntities;
  late String enterpriseName;
  late String url;
  late String crossIdentity;

  void initSut() {
    sut = EnterpriseRepositoryImpl(
      supabaseEnterpriseDatasource: supabaseEnterpriseDataSource,
      soapEnterpriseDatasource: soapEnterpriseDataSource,
    );
  }

  void initInjections() {
    soapEnterpriseDataSource = SoapEnterpriseDataSourceSpy();
    supabaseEnterpriseDataSource = SupabaseEnterpriseDataSourceSpy();
  }

  void mockSuccess() {
    soapEnterpriseDataSource.mockGetEnterprises(
      enterpriseEntities.map((e) => SoapEnterpriseModel.fromEntity(e)).toList(),
    );
    supabaseEnterpriseDataSource.mockGetEnterpriseByName(
      SupabaseEnterpriseModel.fromEntity(enterpriseEntities.first),
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
      () => supabaseEnterpriseDataSource.getEnterpriseByName(enterpriseName),
    ).called(1);
  });
  test("Behave correctly on get soap enterprises", () async {
    final response = await sut.getSoapEnterprises(
      url: url,
      crossIdentity: crossIdentity,
    );

    expect(
      response,
      enterpriseEntities
          .map((e) => SoapEnterpriseModel.fromEntity(e).toEntity())
          .toList(),
    );

    verify(
      () => soapEnterpriseDataSource.getEnterprises(
        crossIdentity: any(named: "crossIdentity"),
        baseUrl: any(named: "url"),
      ),
    ).called(1);
  });
}
