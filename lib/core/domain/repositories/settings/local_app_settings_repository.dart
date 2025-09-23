import '../../../data/datasource/settings/settings.dart';
import '../../../data/models/models.dart';
import '../../entities/entities.dart';
import '../repositores.dart';

class LocalAppSettingsRepository implements IAppSettingsRepository {
  final IAppSettingsDatasource appSettingsDatasource;

  LocalAppSettingsRepository(this.appSettingsDatasource);

  @override
  Future<void> changeSettings(AppSettingsEntity entity) async {
    await appSettingsDatasource.changeSettings(
      AppSettingsModel.fromEntity(entity),
    );
  }

  @override
  Future<AppSettingsEntity?> loadSettings() async {
    final value = await appSettingsDatasource.loadSettings();

    return value?.toEntity();
  }
}
