import 'package:celta_inventario/features/enterprises/data/datasource/datasource.dart';
import 'package:celta_inventario/features/enterprises/domain/repository/repository.dart';

class LastSelectedEnterpriseCodeRepositoryImpl
    implements ILastSelectedEnterpriseCodeRepository {
  final ILastSelectedEnterpriseCodeDatasource datasource;
  LastSelectedEnterpriseCodeRepositoryImpl(this.datasource);

  @override
  Future<int?> load() async => await datasource.load();

  @override
  Future<void> update(int code) async {
    await datasource.update(code);
  }
}
