import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/domain/repositories/settings/settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late LocalAppSettingsRepository sut;

  late AppSettingsDatasourceSpy appSettingsDatasource;

  late AppSettingsEntity appSettingsEntity;

  void initSut() {
    sut = LocalAppSettingsRepository(appSettingsDatasource);
  }

  void initInjections() {
    appSettingsDatasource = AppSettingsDatasourceSpy();
  }

  void mockSuccess() {
    appSettingsDatasource.mockLoadDefault(
      AppSettingsModel.fromEntity(appSettingsEntity),
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

  setUpAll(() {
    for (var value in SearchProductTypePreference.values) {
      registerFallbackValue(value);
    }
  });

  test("Should behave correctly on load default", () async {
    final value = await sut.loadSettings();

    expect(value, appSettingsEntity);

    verify(() => appSettingsDatasource.loadSettings()).called(1);
  });
  test("Should behave correctly on change default", () async {
    await sut.changeSettings(appSettingsEntity);

    verify(
      () => appSettingsDatasource.changeSettings(
        AppSettingsModel.fromEntity(appSettingsEntity),
      ),
    ).called(1);
  });
}
