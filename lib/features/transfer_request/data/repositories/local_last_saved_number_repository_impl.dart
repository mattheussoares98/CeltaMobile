import '../datasource/datasource.dart';
import 'package:celta_inventario/features/transfer_request/domain/repositories/repositories.dart';

class LocalLastSavedNumberRepositoryImpl
    implements ILocalLastSavedNumberRepository {
  final ILocalLastSavedNumberDatasource datasource;
  LocalLastSavedNumberRepositoryImpl(this.datasource);

  @override
  Future<String?> load() async {
    return await datasource.load();
  }

  @override
  Future<void> save(String number) async {
    await datasource.save(number);
  }
}
