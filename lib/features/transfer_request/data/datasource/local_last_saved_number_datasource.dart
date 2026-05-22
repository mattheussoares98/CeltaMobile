import 'package:hive/hive.dart';

import 'package:celta_inventario/features/transfer_request/data/datasource/datasource.dart';

class LocalLastSavedNumberDatasource
    implements ILocalLastSavedNumberDatasource {
  final Box box;
  LocalLastSavedNumberDatasource(this.box);

  static const _key = 'transferRequestLastSavedNumber';

  @override
  Future<String?> load() async {
    return await box.get(_key);
  }

  @override
  Future<void> save(String number) async {
    await box.put(_key, number);
  }
}
