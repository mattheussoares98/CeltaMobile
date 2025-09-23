import 'settings.dart';

class AppSettingsEntity {
  final UserPreferredSearchType searchPreference;
  final bool isContinuousScanEnabledInInventory;

  const AppSettingsEntity({
    required this.searchPreference,
    required this.isContinuousScanEnabledInInventory,
  });
}
