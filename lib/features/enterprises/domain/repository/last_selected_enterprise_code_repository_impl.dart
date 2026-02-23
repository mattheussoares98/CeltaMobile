import '../../data/datasource/datasource.dart';
import 'repository.dart';

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
