import 'package:celta_intelligence/core/data/datasource/enterprise/enterprise.dart';
import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late SupabaseEnterpriseDatasource sut;

  late SupabaseClientSpy supabaseClient;

  late EnterpriseEntity enterpriseEntity;

  void initEntities() {
    enterpriseEntity = EntityFactory.makeEnterpriseEntity();
  }

  void initSut() {
    sut = SupabaseEnterpriseDatasource(supabaseClient);
  }

  void initInjections() {
    supabaseClient = SupabaseClientSpy();
  }

  void mockSuccess() {
    supabaseClient.mockResponse(
      SupabaseEnterpriseModel.fromEntity(enterpriseEntity).toJson(),
    );
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  group('Get enterprise byname', () {
    test('should behave correctly on success', () async {
      final result = await sut.getEnterpriseByName(
        " ${enterpriseEntity.name} ".toUpperCase(),
      );

      expect(result, SupabaseEnterpriseModel.fromEntity(enterpriseEntity));
      expect(supabaseClient.lastRpcFunction, 'get_enterprise_by_name');
      expect(supabaseClient.lastRpcParams, {
        'p_name': enterpriseEntity.name.toLowerCase().removeWhiteSpaces(),
      });
    });
    test('should return null when return null from database', () async {
      supabaseClient.mockResponse(null);

      final result = await sut.getEnterpriseByName(enterpriseEntity.name);

      expect(result, isNull);
    });

    test('Should rethrow the error', () async {
      supabaseClient.mockFromError(Exception());

      final result = sut.getEnterpriseByName(enterpriseEntity.name);

      expect(result, throwsA(isA<Exception>()));
    });
  });

  group("Get enabled modules by cnpj", () {
    test("Should behave correctly on success", () async {
      final enterprises = [
        EntityFactory.makeEnabledModulesByCnpjEntity(),
        EntityFactory.makeEnabledModulesByCnpjEntity(),
        EntityFactory.makeEnabledModulesByCnpjEntity(),
      ];

      supabaseClient.mockResponse(
        enterprises
            .map((e) => EnabledModulesByCnpjModel.fromEntity(e).toJson())
            .toList(),
      );

      final response = await sut.getEnabledModulesByEnterpriseName(
        enterprises.first.name,
      );

      expect(
        response,
        enterprises
            .map((e) => EnabledModulesByCnpjModel.fromEntity(e))
            .toList(),
      );

      expect(
        supabaseClient.lastRpcFunction,
        'get_enabled_modules_for_enterprise',
      );

      expect(supabaseClient.lastRpcParams, {
        'p_enterprise_name': enterprises.first.name,
      });
    });
  });
}
