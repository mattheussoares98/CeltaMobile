import 'package:celta_inventario/core/data/datasource/app_usage/app_usage.dart';
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/data/repositories/app_usage/app_usage.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
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
  late List<GroupedUsageModel> groupedUsages;
  late LoadAppUsageParams params;

  void initSut() {
    sut = AppUsageRepositoryImpl(remoteDs, localDs);
  }

  void initInjections() {
    localDs = LocalAppUsageDatasourceSpy();
    remoteDs = RemoteAppUsageDatasourceSpy();
  }

  void mockSuccess() {
    when(() => localDs.load()).thenAnswer((_) async => usageModels);
    when(() => remoteDs.load(any())).thenAnswer((_) async => usageModels);
    when(
      () => remoteDs.loadGroupedByEnterprise(any()),
    ).thenAnswer((_) async => groupedUsages);
    when(
      () => localDs.getLastUpdatedDate(),
    ).thenAnswer((_) async => DateTime.now());
    when(() => localDs.clearData()).thenAnswer((_) async => 0);
    when(() => localDs.insert(any())).thenAnswer((_) async {});
  }

  void initEntities() {
    groupedUsages = [
      EntityFactory.makeGroupedUsageEntity(),
      EntityFactory.makeGroupedUsageEntity(),
      EntityFactory.makeGroupedUsageEntity(),
    ].map((e) => GroupedUsageModel.fromEntity(e)).toList();
    usageModels = [
      EntityFactory.makeAppUsageEntity(),
      EntityFactory.makeAppUsageEntity(),
      EntityFactory.makeAppUsageEntity(),
    ].map((e) => AppUsageModel.fromEntity(e)).toList();
    params = LoadAppUsageParams(
      enterpriseId: faker.randomGenerator.integer(1000),
      startDate: faker.date.dateTime(),
      endDate: faker.date.dateTime(),
    );
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
    registerFallbackValue(
      LoadAppUsageParams(
        enterpriseId: faker.randomGenerator.integer(1000),
        startDate: faker.date.dateTime(),
        endDate: faker.date.dateTime(),
      ),
    );
  });

  group('Load remote usage report', () {
    test('should behave correctly', () async {
      final appUsages = await sut.loadRemoteUsageReport(params);

      expect(appUsages, usageModels.map((e) => e.toEntity()).toList());
      verify(() => remoteDs.load(params)).called(1);
    });
  });
  group('Load remote grouped usage report', () {
    test('should behave correctly', () async {
      final appUsages = await sut.loadGroupedUsageReport(params);

      expect(appUsages, groupedUsages.map((e) => e.toEntity()).toList());
      verify(() => remoteDs.loadGroupedByEnterprise(params)).called(1);
    });
  });

  group('Save', () {
    test(
      'Should behave correctly when doesn\'t has equal request locally',
      () async {
        final newEntity = EntityFactory.makeAppUsageEntity();

        await sut.addUsage(newEntity);

        verify(() => localDs.load()).called(1);
        verify(() => localDs.getLastUpdatedDate()).called(1);
        verify(
          () => localDs.insert([
            ...usageModels,
            AppUsageModel.fromEntity(newEntity),
          ]),
        ).called(1);
      },
    );
    test('Should behave correctly when has equal request locally', () async {
      await sut.addUsage(usageModels.first.toEntity());

      verify(() => localDs.load()).called(1);
      verify(() => localDs.getLastUpdatedDate()).called(1);
      verify(
        () => localDs.insert([
          ...usageModels.where((e) => e != usageModels.first),
          AppUsageModel.fromEntity(
            usageModels.first.toEntity().copyWith(
              requestCount: usageModels.first.requestCount + 1,
            ),
          ),
        ]),
      ).called(1);
    });

    test('Should behave correctly has not sent to remote today', () async {
      when(() => localDs.getLastUpdatedDate()).thenAnswer(
        (_) async => DateTime.now().subtract(const Duration(days: 1)),
      ); //always save with current date
      when(() => remoteDs.insert(any())).thenAnswer((_) async {});
      when(() => localDs.updateLastUploadDate()).thenAnswer((_) async {});

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
      verify(() => localDs.clearData()).called(1);
      verify(() => localDs.updateLastUploadDate()).called(1);
    });
    test('Should behave correctly when sent remotely today', () async {
      when(
        () => localDs.getLastUpdatedDate(),
      ).thenAnswer((_) async => DateTime.now());
      when(() => remoteDs.insert(any())).thenAnswer((_) async {});

      await sut.addUsage(usageModels.first.toEntity());

      verifyNever(() => remoteDs.insert(any()));
      verifyNever(() => localDs.clearData());
      verifyNever(() => localDs.updateLastUploadDate());
    });
  });
}
