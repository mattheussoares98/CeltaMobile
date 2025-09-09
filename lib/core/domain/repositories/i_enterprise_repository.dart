import '../../data/models/models.dart';

abstract class IEnterpriseRepository {
  Future<SupabaseEnterpriseModel?> getEnterpriseByName(String name);
}
