import '../datasource/datasource.dart';
import 'package:celta_inventario/features/sale_request/domain/repository/repository.dart';

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
