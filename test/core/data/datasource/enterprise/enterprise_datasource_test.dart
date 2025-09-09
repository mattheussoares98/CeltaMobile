import 'package:celta_intelligence/core/data/datasource/datasource.dart';
import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late SupabaseEnterpriseDataSource sut;

  late SupabaseClientSpy supabaseClient;

  late EnterpriseEntity enterpriseEntity;
  late String enterpriseName;

  void initEntities() {
    enterpriseName = faker.company.name();
    enterpriseEntity = EntityFactory.makeEnterpriseEntity(name: enterpriseName);
  }

  void initSut() {
    sut = SupabaseEnterpriseDataSource(supabaseClient);
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

  group('Get enterprise', () {
    test(
      'should call rpc with correct function name and return the correct values',
      () async {
        final result = await sut.getEnterpriseByName(enterpriseName);

        expect(result, SupabaseEnterpriseModel.fromEntity(enterpriseEntity));
        expect(supabaseClient.rpcCallHistory.length, 1);
        expect(supabaseClient.lastRpcFunction, 'get_enterprise_by_name');
        expect(supabaseClient.lastRpcParams, {'p_name': enterpriseName});
      },
    );
    test('should rethrow the correct error', () async {
      supabaseClient.mockFromError(Exception());

      expect(
        sut.getEnterpriseByName(enterpriseName),
        throwsA(isA<Exception>()),
      );
    });
    test('should return null if there is no result', () async {
      supabaseClient.mockResponse(null);

      expect(await sut.getEnterpriseByName(enterpriseName), isNull);
    });
  });
}
