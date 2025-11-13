import 'package:hive/hive.dart';

import 'datasource.dart';

class LocalIpPrintSaleRequestDatasource
    implements ILocalIpPrintSaleRequestDatasource {
  final Box box;
  LocalIpPrintSaleRequestDatasource(this.box);

  @override
  Future<String?> load() async {
    return await box.get('ip');
  }

  @override
  Future<void> save(String ip) async {
    await box.put('ip', ip);
  }
}
