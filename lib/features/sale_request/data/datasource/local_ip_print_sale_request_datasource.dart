import 'package:hive/hive.dart';

import 'package:celta_inventario/features/sale_request/data/datasource/datasource.dart';

class LocalIpPrintSaleRequestDatasource
    implements ILocalIpPrintSaleRequestDatasource {
  final Box box;
  LocalIpPrintSaleRequestDatasource(this.box);

  static const String _key = 'ip';

  @override
  Future<String?> load() async {
    return await box.get(_key);
  }

  @override
  Future<void> save(String ip) async {
    await box.put(_key, ip);
  }
}
