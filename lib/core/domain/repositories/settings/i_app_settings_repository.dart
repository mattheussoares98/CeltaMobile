import 'package:celta_inventario/core/domain/entities/entities.dart';

abstract class IAppSettingsRepository {
  Future<void> changeSettings(AppSettingsEntity appSettings);
  Future<AppSettingsEntity?> loadSettings();
}
