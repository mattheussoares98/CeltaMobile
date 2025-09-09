import '../../data/datasource/datasource.dart';
import '../entities/entities.dart';
import 'i_enterprise_repository.dart';

class EnterpriseRepositoryImpl implements IEnterpriseRepository {
  final ISupabaseEnterpriseDataSource supabaseEnterpriseDatasource;
  final ISoapEnterpriseDataSource soapEnterpriseDatasource;
  EnterpriseRepositoryImpl({
    required this.supabaseEnterpriseDatasource,
    required this.soapEnterpriseDatasource,
  });

  @override
  Future<EnterpriseEntity?> getSupabaseEnterpriseByName(String name) async {
    final model = await supabaseEnterpriseDatasource.getEnterpriseByName(name);
    return model?.toEntity();
  }

  @override
  Future<List<EnterpriseEntity>> getSoapEnterprises({
    required String url,
    required String crossIdentity,
  }) async {
    final models = await soapEnterpriseDatasource.getEnterprises(
      url: url,
      crossIdentity: crossIdentity,
    );

    return models.map((e) => e.toEntity()).toList();
  }
}
