import 'package:celta_intelligence/core/constants/database_keys.dart';
import 'package:celta_intelligence/core/data/datasource/settings/settings.dart';
import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late LocalAppSettingsDatasource sut;

  late MockBox hive;

  late AppSettingsEntity appSettingsEntity;

  void initSut() {
    sut = LocalAppSettingsDatasource(hive);
  }

  void initInjections() {
    hive = MockBox();
  }

  void mockSuccess() {
    hive.mockGet(
      DatabaseKeys.appSettings.name,
      AppSettingsModel.fromEntity(appSettingsEntity).toJson(),
    );
  }

  void initEntities() {
    appSettingsEntity = EntityFactory.makeAppSettingsEntity();
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  group('Change default', () {
    test('Should call hive with correct params', () async {
      await sut.changeSettings(AppSettingsModel.fromEntity(appSettingsEntity));

      verify(
        () => hive.put(
          DatabaseKeys.appSettings.name,
          AppSettingsModel.fromEntity(appSettingsEntity).toJson(),
        ),
      ).called(1);
    });
  });
  group('Get', () {
    test('Should return correct value when is not null', () async {
      expect(
        await sut.loadSettings(),
        AppSettingsModel.fromEntity(appSettingsEntity),
      );

      verify(() => hive.get(DatabaseKeys.appSettings.name)).called(1);
    });

    test('Should return correct value when returns null', () async {
      hive.mockGet(DatabaseKeys.appSettings.name, null);

      expect(
        await sut.loadSettings(),
        AppSettingsModel(
          searchPreference: SearchProductTypePreference.dynamic,
          isContinuousScanEnabledInInventory: false,
        ),
      );
    });
  });
}
