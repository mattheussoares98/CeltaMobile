import '../../models/models.dart';

abstract class ISupabaseEnterpriseDatasource {
  Future<EnterpriseModel?> getEnterprise(String name);
}
