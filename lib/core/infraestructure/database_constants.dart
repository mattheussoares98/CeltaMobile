// ignore_for_file: library_private_types_in_public_api

class DatabaseConstants {
  DatabaseConstants._();

  static List<_HiveBoxConfig> get values => <_HiveBoxConfig>[
    appSettings,
    buyRequest,
    lastSavedSaleRequest,
    saleRequest,
    transferBetweenStocks,
    transferRequest,
    transferRequestLastSavedNumber,
    userSession,
  ];

  static const appSettings = _HiveBoxConfig('app_settings');
  static const buyRequest = _HiveBoxConfig('buy_request');
  static const lastSavedSaleRequest = _HiveBoxConfig('last_saved_sale_request');
  static const saleRequest = _HiveBoxConfig('sale_request');
  static const transferBetweenStocks = _HiveBoxConfig(
    'transfer_between_stocks',
  );
  static const transferRequest = _HiveBoxConfig('transfer_request');
  static const transferRequestLastSavedNumber = _HiveBoxConfig(
    'transfer_request_last_saved_number',
  );
  static const userSession = _HiveBoxConfig('user_session');
}

class _HiveBoxConfig {
  final String name;

  const _HiveBoxConfig(this.name);
}
