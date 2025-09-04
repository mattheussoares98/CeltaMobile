import '../../models/models.dart';

abstract class SupabaseEnterpriseDatasource {
  Future<EnterpriseModel?> getEnterprise(String name);
}
