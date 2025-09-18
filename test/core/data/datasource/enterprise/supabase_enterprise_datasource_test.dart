import 'package:celta_intelligence/core/data/datasource/datasource.dart';
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
}
