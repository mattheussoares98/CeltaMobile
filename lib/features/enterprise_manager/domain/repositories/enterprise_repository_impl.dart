import '../../data/datasource/datasource.dart';
import '../entities/entities.dart';
import 'repositories.dart';

class EnterpriseRepositoryImpl implements IEnterpriseRepository {
  final IEnterpriseDataSource enterpriseDataSource;

  EnterpriseRepositoryImpl(this.enterpriseDataSource);

  @override
  Future<List<EnterprisePermissionEntity>> getAllEnterprisePermissions() async {
    final enterprises = await enterpriseDataSource
        .getAllEnterprisePermissions();

    return enterprises.map((e) => e.toEntity()).toList();
  }
}
