import 'settings.dart';

class AppSettingsEntity {
  final SearchProductTypePreference searchPreference;
  final bool isContinuousScanEnabledInInventory;

  const AppSettingsEntity({
    required this.searchPreference,
    required this.isContinuousScanEnabledInInventory,
  });
}
