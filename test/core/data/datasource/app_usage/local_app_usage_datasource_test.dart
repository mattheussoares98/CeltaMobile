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
  const counterKey = 'usage_counter';

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
      final counter = faker.randomGenerator.integer(100);

      await sut.insert(appUsageModels, counter);

      verify(
        () => box.put(dataKey, appUsageModels.map((e) => e.toJson()).toList()),
      ).called(1);
      verify(() => box.put(counterKey, counter)).called(1);
    });
  });

  group('clear', () {
    test('should behave correctly on success', () async {
      await sut.clear();

      verify(() => box.clear()).called(1);
    });
  });

  group('getCounter', () {
    test('should behave correctly when has local data', () async {
      final counter = faker.randomGenerator.integer(100);
      box.mockGet(counterKey, counter);

      final result = await sut.getCounter();

      expect(result, counter);

      verify(() => box.get(counterKey)).called(1);
    });
    test('should behave correctly when doesn\'t have local data', () async {
      box.mockGet(counterKey, null);

      expect(await sut.getCounter(), 0);

      verify(() => box.get(counterKey)).called(1);
    });
  });
}
