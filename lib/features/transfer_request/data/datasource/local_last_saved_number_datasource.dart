import 'package:hive/hive.dart';

import '../../../../core/infraestructure/infrastructure.dart';
import 'datasource.dart';

class LocalLastSavedNumberDatasource
    implements ILocalLastSavedNumberDatasource {
  final Box box;
  LocalLastSavedNumberDatasource(this.box);

  static final _key = DatabaseConstants.transferRequestLastSavedNumber.name;

  @override
  Future<String?> load() async {
    return await box.get(_key);
  }

  @override
  Future<void> save(String number) async {
    await box.put(_key, number);
  }
}
