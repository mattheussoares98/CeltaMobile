import 'package:celta_inventario/features/buy_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/buy_request/data/models/models.dart';
import 'package:hive/hive.dart';

class LocalPendingBuyRequestDatasource
    implements ILocalPendingBuyRequestDatasource {
  final Box box;
  LocalPendingBuyRequestDatasource(this.box);

  static const String _keyPrefix = 'pending_buy_request_';

  String _getKey(int enterpriseCode) {
    return '$_keyPrefix$enterpriseCode';
  }

  @override
  Future<void> update(PendingBuyRequestModel model, int enterpriseCode) async {
    await box.put(_getKey(enterpriseCode), model.toJson());
  }

  @override
  Future<PendingBuyRequestModel?> load(int enterpriseCode) async {
    final value = await box.get(_getKey(enterpriseCode));
    if (value == null) {
      return null;
    }

    return PendingBuyRequestModel.fromJson(Map.from(value));
  }
}
