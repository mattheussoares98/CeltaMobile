import '../../models/models.dart';

abstract class ISupabaseEnterpriseDatasource {
  Future<EnterpriseModel?> getEnterpriseByName(String name);
}
