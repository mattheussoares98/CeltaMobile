import 'settings.dart';

class AppSettingsEntity {
  final UserPreferredSearchType searchPreference;
  final bool isContinuousScanEnabled;

  const AppSettingsEntity({
    required this.searchPreference,
    required this.isContinuousScanEnabled,
  });
}
