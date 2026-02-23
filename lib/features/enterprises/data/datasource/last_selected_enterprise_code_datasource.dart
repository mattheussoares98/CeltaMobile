import 'package:hive/hive.dart';

import 'datasource.dart';

class LastSelectedEnterpriseCodeDatasource
    implements ILastSelectedEnterpriseCodeDatasource {
  final Box box;
  LastSelectedEnterpriseCodeDatasource(this.box);

  @override
  Future<int?> load() async => await box.get('code') as int?;

  @override
  Future<void> update(int code) async {
    await box.put('code', code);
  }
}
