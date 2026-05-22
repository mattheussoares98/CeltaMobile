import 'package:celta_inventario/core/data/models/models.dart';

abstract class IAppSettingsDatasource {
  Future<void> changeSettings(AppSettingsModel model);
  Future<AppSettingsModel?> loadSettings();
}
