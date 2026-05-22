import 'package:celta_inventario/core/data/datasource/settings/settings.dart';
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/domain/repositories/settings/settings.dart';

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
