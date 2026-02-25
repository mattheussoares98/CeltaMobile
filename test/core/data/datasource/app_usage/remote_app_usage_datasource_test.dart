import 'package:celta_inventario/core/data/datasource/app_usage/app_usage.dart';
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late IRemoteAppUsageDatasource sut;

  late SupabaseClientSpy supabaseClient;

  late List<AppUsageModel> appUsageModels;
  late int enterpriseId;
  late DateTime startDate;
  late DateTime endDate;

  void initEntities() {
    appUsageModels = [
      EntityFactory.makeAppUsageEntity(),
      EntityFactory.makeAppUsageEntity(),
      EntityFactory.makeAppUsageEntity(),
    ].map((e) => AppUsageModel.fromEntity(e)).toList();
    enterpriseId = faker.randomGenerator.integer(100);
    startDate = faker.date.dateTime();
    endDate = startDate.add(
      Duration(days: faker.randomGenerator.integer(365, min: 1)),
    );
  }

  void initSut() {
    sut = RemoteAppUsageDatasource(supabaseClient);
  }

  void initInjections() {
    supabaseClient = SupabaseClientSpy();
  }

  void mockSuccess() {
    supabaseClient.mockResponse(appUsageModels.map((e) => e.toJson()).toList());
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  group('Load', () {
    test('should behave correctly on success', () async {
      final result = await sut.load(
        enterpriseId: enterpriseId,
        startDate: startDate,
        endDate: endDate,
      );

      expect(result, appUsageModels);
      expect(supabaseClient.lastRpcFunction, 'get_app_usage_report');
      expect(supabaseClient.lastRpcParams, {
        'p_enterprise_id': enterpriseId,
        'p_start_date': startDate.toIso8601String(),
        'p_end_date': endDate.toIso8601String(),
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
