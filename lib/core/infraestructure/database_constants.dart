// ignore_for_file: library_private_types_in_public_api

class DatabaseConstants {
  DatabaseConstants._();

  static List<_HiveBoxConfig> get values => <_HiveBoxConfig>[
    appSettings,
    userSession,
    transferLot,
  ];

  static final appSettings = _HiveBoxConfig(
    name: 'app_settings',
    keys: ['search_type_preference', 'continuous_scan_preference'],
  );

  static final userSession = _HiveBoxConfig(
    name: 'user_session',
    keys: ['current_user_session'],
  );

  static final transferLot = _HiveBoxConfig(
    name: 'transfer_lot_items',
    keys: [], //use dynamic keys according to change the lot
  );
}

class _HiveBoxConfig {
  final String name;
  final List<String> keys;

  const _HiveBoxConfig({required this.name, required this.keys});
}
