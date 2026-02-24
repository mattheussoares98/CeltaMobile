import 'package:celta_inventario/core/data/datasource/app_usage/app_usage.dart';
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/repositories/app_usage/app_usage.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class LocalAppUsageDatasourceSpy extends Mock
    implements ILocalAppUsageDatasource {}

class RemoteAppUsageDatasourceSpy extends Mock
    implements IRemoteAppUsageDatasource {}

void main() {
  late IAppUsageRepository sut;

  late LocalAppUsageDatasourceSpy localDs;
  late RemoteAppUsageDatasourceSpy remoteDs;

  late List<AppUsageModel> usageModels;
  late int enterpriseId;
  late DateTime start;
  late DateTime end;

  void initSut() {
    sut = AppUsageRepositoryImpl(remoteDs, localDs);
  }

  void initInjections() {
    localDs = LocalAppUsageDatasourceSpy();
    remoteDs = RemoteAppUsageDatasourceSpy();
  }

  void mockSuccess() {
    when(() => localDs.load()).thenAnswer((_) async => usageModels);
    when(
      () => remoteDs.load(
        enterpriseId: any(named: 'enterpriseId'),
        startDate: any(named: 'startDate'),
        endDate: any(named: 'endDate'),
      ),
    ).thenAnswer((_) async => usageModels);
    when(() => localDs.getCounter()).thenAnswer((_) async => 0);
    when(() => localDs.clear()).thenAnswer((_) async => 0);
    when(() => localDs.insert(any(), any())).thenAnswer((_) async {});
  }

  void initEntities() {
    usageModels = [
      EntityFactory.makeAppUsageEntity(),
      EntityFactory.makeAppUsageEntity(),
      EntityFactory.makeAppUsageEntity(),
    ].map((e) => AppUsageModel.fromEntity(e)).toList();
    enterpriseId = faker.randomGenerator.integer(1000);
    start = faker.date.dateTime();
    end = start.add(Duration(days: faker.randomGenerator.integer(100)));
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeUserEntity());
    registerFallbackValue(
      UserSessionModel.fromEntity(EntityFactory.makeUserSessionEntity()),
    );
  });

  group('Load remote usage report', () {
    test('should behave correctly', () async {
      final appUsages = await sut.loadRemoteUsageReport(
        enterpriseId: enterpriseId,
        start: start,
        end: end,
      );

      expect(appUsages, usageModels.map((e) => e.toEntity()).toList());
      verify(
        () => remoteDs.load(
          enterpriseId: enterpriseId,
          startDate: start,
          endDate: end,
        ),
      ).called(1);
    });
  });

  group('Save', () {
    test(
      'Should behave correctly when doesn\'t has equal request locally',
      () async {
        final newEntity = EntityFactory.makeAppUsageEntity();

        await sut.addUsage(newEntity);

        verify(() => localDs.load()).called(1);
        verify(() => localDs.getCounter()).called(1);
        verify(
          () => localDs.insert([
            ...usageModels,
            AppUsageModel.fromEntity(newEntity),
          ], 1),
        ).called(1);
      },
    );
    test('Should behave correctly when has equal request locally', () async {
      await sut.addUsage(usageModels.first.toEntity());

      verify(() => localDs.load()).called(1);
      verify(() => localDs.getCounter()).called(1);
      verify(
        () => localDs.insert([
          ...usageModels.where((e) => e != usageModels.first),
          AppUsageModel.fromEntity(
            usageModels.first.toEntity().copyWith(
              requestCount: usageModels.first.requestCount + 1,
            ),
          ),
        ], 1),
      ).called(1);
    });

    test('Should behave correctly when counter is >= 10', () async {
      when(
        () => localDs.getCounter(),
      ).thenAnswer((_) async => faker.randomGenerator.integer(100, min: 10));
      when(() => remoteDs.insert(any())).thenAnswer((_) async {});

      await sut.addUsage(usageModels.first.toEntity());

      verify(
        () => remoteDs.insert([
          ...usageModels.where((e) => e != usageModels.first),
          AppUsageModel.fromEntity(
            usageModels.first.toEntity().copyWith(
              requestCount: usageModels.first.requestCount + 1,
            ),
          ),
        ]),
      ).called(1);
      verify(() => localDs.clear()).called(1);
    });
    test('Should behave correctly when counter is < 10', () async {
      when(
        () => localDs.getCounter(),
      ).thenAnswer((_) async => faker.randomGenerator.integer(9));
      when(() => remoteDs.insert(any())).thenAnswer((_) async {});

      await sut.addUsage(usageModels.first.toEntity());

      verifyNever(() => remoteDs.insert(any()));
      verifyNever(() => localDs.clear());
    });
  });
}
