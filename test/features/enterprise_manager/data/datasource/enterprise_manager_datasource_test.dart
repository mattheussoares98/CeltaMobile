import 'package:celta_intelligence/features/enterprise_manager/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/enterprise_manager/data/models/models.dart';
import 'package:celta_intelligence/features/enterprise_manager/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late EnterpriseManagerDataSource sut;

  late SupabaseClientSpy supabaseClient;

  late EnterprisePermissionEntity enterprisePermissionEntity;
  late String enterpriseName;
  late String baseUrl;
  late List<SubEnterpriseModel> subEnterprises;

  void initSut() {
    sut = EnterpriseManagerDataSource(supabaseClient);
  }

  void initInjections() {
    supabaseClient = SupabaseClientSpy();
  }

  void mockSuccess() {
    supabaseClient.mockResponse([
      EnterprisePermissionModel.fromEntity(enterprisePermissionEntity).toJson(),
    ]);
  }

  void initEntities() {
    enterprisePermissionEntity = EntityFactory.makeEnterprisePermissionEntity();

    enterpriseName = faker.company.name();
    baseUrl = faker.internet.httpsUrl();
    subEnterprises = [
      SubEnterpriseModel(
        cnpj: faker.randomGenerator.integer(14).toString(),
        name: faker.company.name(),
      ),
      SubEnterpriseModel(
        cnpj: faker.randomGenerator.integer(14).toString(),
        name: faker.company.name(),
      ),
      SubEnterpriseModel(
        cnpj: faker.randomGenerator.integer(14).toString(),
        name: faker.company.name(),
      ),
    ];
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  group('Get all enterprises permissions', () {
    test('should behave correctly', () async {
      final result = await sut.getAllEnterprisePermissions();

      expect(result, [
        EnterprisePermissionModel.fromEntity(enterprisePermissionEntity),
      ]);

      expect(supabaseClient.lastRpcFunction, 'get_all_enterprise_permissions');
    });
  });

  group("Create enterprise with sub enterprises", () {
    test("Should behave correctly on success", () async {
      await sut.createEnterpriseWithSubEnterprises(
        enterpriseName: enterpriseName,
        baseUrl: baseUrl,
        subEnterprises: subEnterprises,
      );

      expect(
        supabaseClient.lastRpcFunction,
        'create_enterprise_with_sub_enterprises',
      );

      expect(supabaseClient.lastRpcParams, {
        'p_enterprise_name': enterpriseName,
        'p_base_url': baseUrl,
        'p_sub_enterprises': subEnterprises.map((e) => e.toJson()).toList(),
      });
    });
  });
}
