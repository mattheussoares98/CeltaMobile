import '../../models/models.dart';

abstract class IEnterpriseDatasource {
  Future<EnterpriseModel?> getEnterprise(String name);
}
