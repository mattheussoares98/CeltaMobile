import 'package:celta_inventario/core/data/datasource/app_usage/app_usage.dart';
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ILocalAppUsageDatasource sut;

  late MockBox box;

  late List<AppUsageModel> appUsageModels;
  const dataKey = 'app_usage';
  const lastUpdatedDateKey = 'last_updated_date';

  void initEntities() {
    appUsageModels = [
      EntityFactory.makeAppUsageEntity(),
      EntityFactory.makeAppUsageEntity(),
      EntityFactory.makeAppUsageEntity(),
    ].map((e) => AppUsageModel.fromEntity(e)).toList();
  }

  void initSut() {
    sut = LocalAppUsageDatasource(box);
  }

  void initInjections() {
    box = MockBox();
  }

  void mockSuccess() {
    box.mockGet(dataKey, appUsageModels.map((e) => e.toJson()).toList());
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  group('Load', () {
    test('should behave correctly on success', () async {
      final result = await sut.load();

      expect(result, appUsageModels);

      verify(() => box.get(dataKey)).called(1);
    });
  });

  group('insert', () {
    test('should behave correctly on success', () async {
      await sut.insert(appUsageModels);

      verify(
        () => box.put(dataKey, appUsageModels.map((e) => e.toJson()).toList()),
      ).called(1);

      verifyNever(() => box.put(lastUpdatedDateKey, any()));
    });
  });

  group('Update last uploaded date', () {
    test('should behave correctly on success', () async {
      await sut.updateLastUploadDate();

      final captured =
          verify(() => box.put(lastUpdatedDateKey, captureAny())).captured.first
              as String;
      expect(captured, isNotNull);
      expect(DateTime.tryParse(captured), isNotNull);
    });
  });

  group('clear', () {
    test('should behave correctly on success', () async {
      await sut.clearData();

      verify(() => box.delete(dataKey)).called(1);
    });
  });

  group('get last updated date', () {
    test('should behave correctly when has local data', () async {
      final date = faker.date.dateTime().toIso8601String();
      box.mockGet(lastUpdatedDateKey, date);

      final result = await sut.getLastUpdatedDate();

      expect(result, DateTime.parse(date));

      verify(() => box.get(lastUpdatedDateKey)).called(1);
    });
    test('should behave correctly when doesn\'t have local data', () async {
      box.mockGet(lastUpdatedDateKey, null);

      expect(await sut.getLastUpdatedDate(), null);

      verify(() => box.get(lastUpdatedDateKey)).called(1);
    });
  });
}
