import 'package:hive/hive.dart';

import 'package:celta_inventario/features/enterprises/data/datasource/datasource.dart';

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
