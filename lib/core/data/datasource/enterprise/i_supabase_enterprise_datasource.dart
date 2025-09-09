import '../../models/models.dart';

abstract class ISupabaseEnterpriseDataSource {
  Future<SupabaseEnterpriseModel?> getEnterpriseByName(String name);
}
