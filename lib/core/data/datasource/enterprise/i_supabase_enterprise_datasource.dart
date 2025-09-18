import '../../models/models.dart';

abstract class ISupabaseEnterpriseDatasource {
  Future<SupabaseEnterpriseModel?> getEnterpriseByName(String name);
}
