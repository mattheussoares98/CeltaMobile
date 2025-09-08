import 'package:celta_intelligence/features/enterprise_manager/data/data_source/data_source.dart';
import 'package:celta_intelligence/features/enterprise_manager/data/models/models.dart';
import 'package:celta_intelligence/features/enterprise_manager/domain/entities/entities.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late EnterpriseDataSource sut;

  late SupabaseClientSpy supabaseClient;

  late EnterprisePermissionEntity enterprisePermissionEntity;

  void initSut() {
    sut = EnterpriseDataSource(supabaseClient);
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
}
