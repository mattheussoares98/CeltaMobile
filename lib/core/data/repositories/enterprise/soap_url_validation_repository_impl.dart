import 'package:celta_inventario/core/data/datasource/enterprise/enterprise.dart';
import 'package:celta_inventario/core/domain/repositories/enterprise/enterprise.dart';

class SoapUrlValidationRepositoryImpl implements ISoapUrlValidationRepository {
  final ISoapUrlValidationDatasource datasource;

  SoapUrlValidationRepositoryImpl(this.datasource);

  @override
  Future<String?> findWorkingUrl(List<String> urls) async {
    return await datasource.findWorkingUrl(urls);
  }
}
