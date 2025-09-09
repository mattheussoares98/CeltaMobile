import '../../data/datasource/datasource.dart';
import '../entities/entities.dart';
import 'repositories.dart';

class EnterpriseManagerRepositoryImpl implements IEnterpriseManagerRepository {
  final IEnterpriseManagerDataSource enterpriseManagerDataSource;

  EnterpriseManagerRepositoryImpl(this.enterpriseManagerDataSource);

  @override
  Future<List<EnterprisePermissionEntity>> getAllEnterprisePermissions() async {
    final enterprises = await enterpriseManagerDataSource
        .getAllEnterprisePermissions();

    return enterprises.map((e) => e.toEntity()).toList();
  }
}
