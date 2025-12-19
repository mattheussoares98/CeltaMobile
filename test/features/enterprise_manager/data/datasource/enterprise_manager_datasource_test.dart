import 'package:celta_intelligence/features/enterprise_manager/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/enterprise_manager/data/models/models.dart';
import 'package:celta_intelligence/features/enterprise_manager/domain/entities/entities.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late EnterpriseManagerDatasource sut;

  late SupabaseClientSpy supabaseClient;

  late EnterprisePermissionEntity enterprisePermissionEntity;
  late String enterpriseName;
  late String baseUrl;
  late List<SubEnterpriseModel> subEnterprises;
  late int enterpriseId;
  late List<UpdateModulePermissionModel> permissions;

  void initSut() {
    sut = EnterpriseManagerDatasource(supabaseClient);
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
        personalizedCode: faker.randomGenerator.integer(100).toString(),
        id: faker.randomGenerator.integer(100),
      ),
      SubEnterpriseModel(
        cnpj: faker.randomGenerator.integer(14).toString(),
        name: faker.company.name(),
        personalizedCode: faker.randomGenerator.integer(100).toString(),
        id: faker.randomGenerator.integer(100),
      ),
      SubEnterpriseModel(
        cnpj: faker.randomGenerator.integer(14).toString(),
        name: faker.company.name(),
        personalizedCode: faker.randomGenerator.integer(100).toString(),
        id: faker.randomGenerator.integer(100),
      ),
    ];
    enterpriseId = faker.randomGenerator.integer(100);
    permissions = [
      UpdateModulePermissionModel(
        moduleId: faker.randomGenerator.integer(100),
        isEnabled: faker.randomGenerator.boolean(),
        subEnterpriseId: faker.randomGenerator.integer(100),
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
      final result = await sut.getEnterprisePermissions();

      expect(result, [
        EnterprisePermissionModel.fromEntity(enterprisePermissionEntity),
      ]);

      expect(supabaseClient.lastRpcFunction, 'get_enterprise_permissions');
    });
  });
  group('Get enterprises permissions by id', () {
    test('should behave correctly', () async {
      final result = await sut.getEnterprisePermissionsById(enterpriseId);

      expect(
        result,
        EnterprisePermissionModel.fromEntity(enterprisePermissionEntity),
      );

      expect(supabaseClient.lastRpcFunction, 'get_enterprise_permissions');
      expect(supabaseClient.lastRpcParams, {'p_enterprise_id': enterpriseId});
    });
  });

  group("Create enterprise with sub enterprises", () {
    test("Should behave correctly on success", () async {
      await sut.createEnterpriseWithSubEnterprises(
        enterpriseName: "${enterpriseName.toUpperCase()} ",
        baseUrl: "${baseUrl.toUpperCase()} ",
        subEnterprises: subEnterprises,
      );

      expect(
        supabaseClient.lastRpcFunction,
        'create_enterprise_with_sub_enterprises',
      );

      expect(supabaseClient.lastRpcParams, {
        'p_enterprise_name': enterpriseName.toLowerCase().removeWhiteSpaces(),
        'p_base_url': baseUrl.toLowerCase().removeWhiteSpaces(),
        'p_sub_enterprises': subEnterprises.map((e) => e.toJson()).toList(),
      });
    });
  });
  group("Update module permissions", () {
    test("Should behave correctly on success", () async {
      await sut.updateUrlAndPermissions(
        enterpriseId: enterpriseId,
        permissions: permissions,
        baseUrl: baseUrl,
      );

      expect(supabaseClient.lastRpcFunction, 'update_module_permission');

      expect(supabaseClient.lastRpcParams, {
        'p_enterprise_id': enterpriseId,
        'p_base_url': baseUrl,
        'p_permissions_payload': permissions.map((e) => e.toJson()).toList(),
      });
    });
  });
}
