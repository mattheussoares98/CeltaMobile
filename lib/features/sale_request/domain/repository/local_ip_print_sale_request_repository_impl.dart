import '../../data/datasource/datasource.dart';
import 'repository.dart';

class LocalIpPrintSaleRequestRepositoryImpl
    implements ILocalIpPrintSaleRequestRepository {
  final ILocalIpPrintSaleRequestDatasource datasource;

  LocalIpPrintSaleRequestRepositoryImpl(this.datasource);

  @override
  Future<String?> load() async {
    return await datasource.load();
  }

  @override
  Future<void> save(String ip) async {
    return await datasource.save(ip);
  }
}
