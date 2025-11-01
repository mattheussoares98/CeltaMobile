import 'package:hive/hive.dart';

import '../../../../core/domain/entities/entities.dart';
import '../../../infraestructure/infrastructure.dart';
import '../../models/models.dart';
import 'settings.dart';

class LocalAppSettingsDatasource implements IAppSettingsDatasource {
  final Box box;
  LocalAppSettingsDatasource(this.box);

  @override
  Future<void> changeSettings(AppSettingsModel model) async {
    await box.put(DatabaseConstants.appSettings.name, model.toJson());
  }

  @override
  Future<AppSettingsModel?> loadSettings() async {
    final value = await box.get(DatabaseConstants.appSettings.name);
    if (value == null) {
      return const AppSettingsModel(
        searchPreference: SearchProductTypePreference.dynamic,
        isContinuousScanEnabledInInventory: false,
      );
    }

    return AppSettingsModel.fromJson(value);
  }
}
