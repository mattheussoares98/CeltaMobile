// ignore_for_file: library_private_types_in_public_api

class DatabaseConstants {
  DatabaseConstants._();

  static List<_HiveBoxConfig> get values => <_HiveBoxConfig>[
    appSettings,
    buyRequest,
    userSession,
    transferBetweenStocks,
    transferRequest,
  ];

  static const appSettings = _HiveBoxConfig('app_settings');
  static const userSession = _HiveBoxConfig('user_session');
  static const buyRequest = _HiveBoxConfig('buyRequest');
  static const transferBetweenStocks = _HiveBoxConfig('transfer_lot_items');
  static const transferRequest = _HiveBoxConfig('transfer_request');
}

class _HiveBoxConfig {
  final String name;

  const _HiveBoxConfig(this.name);
}
