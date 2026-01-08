import '../../../data/datasource/enterprise/enterprise.dart';
import 'enterprise.dart';

class SoapUrlValidationRepositoryImpl implements ISoapUrlValidationRepository {
  final ISoapUrlValidationDatasource datasource;

  SoapUrlValidationRepositoryImpl(this.datasource);

  @override
  Future<String?> findWorkingUrl(List<String> urls) async {
    return await datasource.findWorkingUrl(urls);
  }
}
