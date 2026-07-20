import 'package:celta_inventario/core/data/datasource/app_usage/app_usage.dart';
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late IRemoteAppUsageDatasource sut;

  late SupabaseClientSpy supabaseClient;

  late List<AppUsageModel> appUsageModels;
  late List<GroupedUsageModel> groupedUsageModels;
  late LoadAppUsageParams params;

  void initEntities() {
    appUsageModels = [
      EntityFactory.makeAppUsageEntity(),
      EntityFactory.makeAppUsageEntity(),
      EntityFactory.makeAppUsageEntity(),
    ].map((e) => AppUsageModel.fromEntity(e)).toList();
    groupedUsageModels = [
      EntityFactory.makeGroupedUsageEntity(),
      EntityFactory.makeGroupedUsageEntity(),
      EntityFactory.makeGroupedUsageEntity(),
    ].map((e) => GroupedUsageModel.fromEntity(e)).toList();
    params = LoadAppUsageParams(
      startDate: faker.date.dateTime(),
      endDate: faker.date.dateTime(),
      enterpriseId: faker.randomGenerator.integer(100),
    );
  }

  void initSut() {
    sut = RemoteAppUsageDatasource(supabaseClient);
  }

  void initInjections() {
    supabaseClient = SupabaseClientSpy();
  }

  void mockSuccess() {}

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  group('Load', () {
    test('should behave correctly on success', () async {
      supabaseClient.mockResponse(
        appUsageModels.map((e) => e.toJson()).toList(),
      );

      final result = await sut.load(params);

      expect(result, appUsageModels);
      expect(supabaseClient.lastRpcFunction, 'get_app_usage_report');
      expect(supabaseClient.lastRpcParams, {
        'p_enterprise_id': params.enterpriseId,
        'p_start_date': params.startDate.toIso8601String(),
        'p_end_date': params.endDate.toIso8601String(),
      });
    });
  });
  group('Load grouped by enterprise', () {
    test('should behave correctly on success', () async {
      supabaseClient.mockResponse(
        groupedUsageModels.map((e) => e.toJson()).toList(),
      );
      final result = await sut.loadGroupedByEnterprise(params);

      expect(result, groupedUsageModels);
      expect(supabaseClient.lastRpcFunction, 'get_app_usage_report_grouped');
      expect(supabaseClient.lastRpcParams, {
        'p_enterprise_id': params.enterpriseId,
        'p_start_date': params.startDate.toIso8601String(),
        'p_end_date': params.endDate.toIso8601String(),
      });
    });
  });

  group("Insert", () {
    test("Should behave correctly on success", () async {
      await sut.insert(appUsageModels);

      expect(supabaseClient.lastRpcFunction, 'batch_increment_app_usage');

      expect(supabaseClient.lastRpcParams, {
        'p_usage_data': appUsageModels.map((e) => e.toJson()).toList(),
      });
    });
  });
}
