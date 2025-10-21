import 'package:hive/hive.dart';

import '../../../../core/infraestructure/infrastructure.dart';
import '../models/models.dart';
import 'datasource.dart';

class LocalPendingBuyRequestDatasource
    implements ILocalPendingBuyRequestDatasource {
  final Box box;
  LocalPendingBuyRequestDatasource(this.box);

  @override
  Future<void> update(PendingBuyRequestModel model) async {
    await box.put(DatabaseConstants.buyRequest.name, model.toJson());
  }

  @override
  Future<PendingBuyRequestModel?> load() async {
    final value = await box.get(DatabaseConstants.buyRequest.name);
    if (value == null) {
      return null;
    }

    return PendingBuyRequestModel.fromJson(value);
  }
}
