import 'package:hive/hive.dart';

import 'datasource.dart';

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
