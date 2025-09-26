import 'constants.dart';

class DatabaseConstants {
  DatabaseConstants._();

  static final appSettings = HiveBoxConfig(
    boxName: 'app_settings',
    keys: ['search_type_preference', 'continuous_scan_preference'],
  );

  static final userSession = HiveBoxConfig(
    boxName: 'user_session',
    keys: ['current_user_session'],
  );

  static final transferLot = HiveBoxConfig(
    boxName: 'transfer_lot_items',
    keys: [], //use dynamic keys according to change the lot
  );
}
