import '../../data/data_source/data_source.dart';
import '../entities/entities.dart';
import 'repositories.dart';

class EnterpriseRepositoryImpl implements IEnterpriseRepository {
  final IEnterpriseDataSource enterpriseDataSource;

  EnterpriseRepositoryImpl(this.enterpriseDataSource);

  @override
  Future<List<EnterprisePermissionEntity>> getAllEnterprisePermissions() async {
    //TODO create tests
    final enterprises = await enterpriseDataSource
        .getAllEnterprisePermissions();

    return enterprises.map((e) => e.toEntity()).toList();
  }
}
