import 'package:hive/hive.dart';

import '../../../../core/domain/entities/entities.dart';
import '../../../constants/database_keys.dart';
import '../../models/models.dart';
import 'settings.dart';

class LocalAppSettingsDatasource implements IAppSettingsDatasource {
  final Box box;
  LocalAppSettingsDatasource(this.box);

  @override
  Future<void> changeSettings(AppSettingsModel model) async {
    await box.put(DatabaseKeys.appSettings.name, model.searchPreference.name);
  }

  @override
  Future<AppSettingsModel?> loadSettings() async {
    final value = await box.get(DatabaseKeys.appSettings.name);
    if (value == null) {
      return AppSettingsModel(
        searchPreference: SearchProductTypePreference.dynamic,
        isContinuousScanEnabledInInventory: false,
      );
    }

    return AppSettingsModel.fromJson(Map<String, dynamic>.from(value));
  }
}
